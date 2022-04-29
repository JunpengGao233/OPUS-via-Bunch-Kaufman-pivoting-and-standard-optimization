#include <iostream>
#include <Eigen/Dense>
using namespace std;

void get_eigen_matrix(const double* mat_d, Eigen::MatrixXd& mat_e, int m, int n){
    mat_e.setZero(m, n);
    for(int i = 0; i < m; i++){
        for(int j = 0; j < n; j++){
            mat_e(i, j) = mat_d[i * n + j];
        }
    }
}

void get_eigen_vector(const double* vec_d, Eigen::VectorXd& vec_e, int n){
    vec_e.setZero(n);
    for(int i = 0; i < n; i++){
        vec_e(i) = vec_d[i];
    }
}

void get_eigen_vector(const double* vec_d, Eigen::RowVectorXd& vec_e, int n){
    vec_e.setZero(n);
    for(int i = 0; i < n; i++){
        vec_e(i) = vec_d[i];
    }
}

void get_double_vector(double* vec_d, const Eigen::VectorXd& vec_e, int n){
    for(int i = 0; i < n; i++){
        vec_d[i] = vec_e(i);
    }
}

void build_surrogate(const Eigen::MatrixXd& points, const Eigen::VectorXd& f, Eigen::VectorXd& lambda_c){
    // points           : (N x d matrix) represents particles
    // f                : (N x 1 vector) represents the corresponding value
    // return lambda_c  : ((N  + d + 1) x 1 vector
    // optimization: only compute upper part of phi, sparsity (zeros) 
    int N = points.rows(), d = points.cols();
    Eigen::MatrixXd A(N + d + 1, N + d + 1);
    Eigen::MatrixXd phi(N, N);
    Eigen::MatrixXd zeros; zeros.setZero(d + 1, d + 1);
    Eigen::VectorXd zeros_vec; zeros_vec.setZero(d + 1);
    Eigen::MatrixXd poly(N, d + 1);
    Eigen::VectorXd ones = Eigen::VectorXd::Ones(N);
    poly << points, ones;
    for (int s = 0; s < N; s++){
        phi.col(s) = (points.rowwise() - points.row(s)).matrix().rowwise().norm();
        phi.col(s) = phi.col(s).cwiseProduct(phi.col(s).cwiseProduct(phi.col(s)));
    } 
    A <<    phi             , poly,
            poly.adjoint()  , zeros;
    cout << A << endl;
    Eigen::VectorXd b(N + d + 1);
    b << f, zeros_vec;
    lambda_c = A.colPivHouseholderQr().solve(b);
}

void build_surrogate_eigen(const double* points, const double* f, int N, int d, double* lambda_c){
    Eigen::MatrixXd points_e;
    Eigen::VectorXd f_e, lambda_c_e;
    get_eigen_matrix(points, points_e, N, d);
    get_eigen_vector(f, f_e, N);
    build_surrogate(points_e, f_e, lambda_c_e);
    get_double_vector(lambda_c, lambda_c_e, N + d + 1);
}

double evaluate_surrogate(const double* x, const double* points, const double* lambda_c, int N, int d){
    double phi, error, res = 0;
    for(int i = 0; i < N; i++){
        phi = 0;
        for(int j = 0; j < d; j++){
            error = x[j] - points[i * d + j];
            phi += error * error;
        }
        phi = sqrt(phi);
        phi = phi * phi * phi;
        cout << phi << " ";
        res += phi * lambda_c[i];
    }
    cout << endl;
    for(int i = 0; i < d; i++){
        res += x[i] * lambda_c[N + i];
    }
    res += lambda_c[N + d];
    return res;
}

int main(){
    double points[6] = {1, 1, 4, 5, 3, 3};
    double f[3] = {1, 2, 3};
    int N = 3, d = 2;
    double* lambda_c = (double*)malloc((N + d + 1) * sizeof(double));;
    build_surrogate_eigen(points, f, 3, 2, lambda_c);
    double x[2] = {3, 3};
    cout << evaluate_surrogate(x, points, lambda_c, N, d) << endl;

    return 0;
}