using LinearAlgebra
using Permutations

function blockbk(A)
    n, _ = size(A)
    LL = zeros(size(Array(A)))
    DD = zeros(size(Array(A)))
    pp = Array(1:n)
    ptotal = zeros(15)
    r = 5
    num_block = ceil(Int,n / r)
    D, L, p = bunchkaufman(Symmetric(A[1:r, 1:r],:L))
    ptotal[1:r] = p
    # @show L, D, p
    #@show typeof(D), typeof(L), p
    A = Array(A)
    LL[1:r,1:r] = Array(L)
    DD[1:r,1:r] = Array(D)
    pp[1:r] = p
    k = 1
    pp = Matrix(Permutation(p))

    DLij = Array(L) * Array(D)
    Ap = transpose(A[r+1:n, 1:r] * pp)
    # @show transpose( DLij \ transpose(A[r+1:n, 1:r]) )
    #Ap = transpose(A[r+1:n, 1:r])
    LL[r+1:n, 1:r] = transpose( DLij \ Ap )

    for k = r+1:r:n
        for j = k:r:n
            for i = j:r:n
                A[i:i+r-1, j:j+r-1]-= LL[i:i+r-1,k-r:k-1]*Array(D)*transpose(LL[j:j+r-1,k-r:k-1])
            end
        end
        D, L, p = bunchkaufman(Symmetric(A[k:k+r-1, k:k+r-1],:L))
        #p .+= k-1
        # @show p
        A = Array(A)
        t = floor(Int, k/r)

        DD[t*r+1:(t+1)*r, t*r+1:(t+1)*r] = Array(D)
        #pp[t*r+1:(t+1)*r] = p
        pp = Matrix(Permutation(p))

        DLij = Array(L) * Array(D)
        Ap = transpose(A[(t+1)*r+1:n, t*r+1:(t+1)*r]  * pp)
        #display(LL)
        LL[t*r+1:(t+1)*r, t*r+1:(t+1)*r] = L
        LL[(t+1)*r+1:n, t*r+1:(t+1)*r] = transpose(DLij \ Ap )

        tmp = copy(LL)
        p .+= k-1
        ptotal[k:k+r-1] = p
        for i in k:k + r - 1
            if i != p[i-k+1]
                LL[p[i-k+1],1:k-1] = tmp[i,1:k-1]
            end
        end
    end
    # display(DD)
    # @show pp
    display(LL)
    display(DD)
    return LL, DD, ptotal
end



A = zeros(15,15)
# A[1] = 0.776324; A[2] = 20.840404; A[3] = 0.348433; A[4] = 1.500600; A[5] = 0.659031; A[6] = 0.157198; A[7] = 1.257581; A[8] = 11.018425; A[9] = 3.895601; A[10] = 9.041188; A[11] = 8.769512; A[12] = -0.853333; A[13] = 0.682667; A[14] = 1.000000; 
# A[15] = 0.776324; A[16] = 0.000000; A[17] = 21.444451; A[18] = 0.014060; A[19] = 8.769512; A[20] = 3.895601; A[21] = 0.233003; A[22] = 3.100491; A[23] = 18.598233; A[24] = 15.344400; A[25] = 26.608982; A[26] = 21.931813; A[27] = -1.194667; A[28] = 1.536000; A[29] = 1.000000; 
# A[30] = 20.840404; A[31] = 21.444451; A[32] = 0.000000; A[33] = 18.598233; A[34] = 28.056598; A[35] = 10.249877; A[36] = 13.432248; A[37] = 4.971027; A[38] = 1.757523; A[39] = 44.789680; A[40] = 35.810416; A[41] = 11.805275; A[42] = 1.536000; A[43] = 2.048000; A[44] = 1.000000; 
# A[45] = 0.348433; A[46] = 0.014060; A[47] = 18.598233; A[48] = 0.000000; A[49] = 6.210593; A[50] = 2.368323; A[51] = 0.055578; A[52] = 1.918050; A[53] = 14.590726; A[54] = 11.805275; A[55] = 20.840404; A[56] = 16.777216; A[57] = -1.024000; A[58] = 1.365333; A[59] = 1.000000; 
# A[60] = 1.500600; A[61] = 8.769512; A[62] = 28.056598; A[63] = 6.210593; A[64] = 0.000000; A[65] = 0.776324; A[66] = 3.895601; A[67] = 3.100491; A[68] = 9.041188; A[69] = 0.157198; A[70] = 0.899852; A[71] = 2.605051; A[72] = -0.341333; A[73] = -0.341333; A[74] = 1.000000; 
# A[75] = 0.659031; A[76] = 3.895601; A[77] = 10.249877; A[78] = 2.368323; A[79] = 0.776324; A[80] = 0.000000; A[81] = 0.899852; A[82] = 0.157198; A[83] = 2.787465; A[84] = 3.100491; A[85] = 3.895601; A[86] = 1.864022; A[87] = 0.000000; A[88] = 0.512000; A[89] = 1.000000; 
# A[90] = 0.157198; A[91] = 0.233003; A[92] = 13.432248; A[93] = 0.055578; A[94] = 3.895601; A[95] = 0.899852; A[96] = 0.000000; A[97] = 0.659031; A[98] = 8.950323; A[99] = 8.679568; A[100] = 14.590726; A[101] = 10.440274; A[102] = -0.682667; A[103] = 1.194667; A[104] = 1.000000; 
# A[105] = 1.257581; A[106] = 3.100491; A[107] = 4.971027; A[108] = 1.918050; A[109] = 3.100491; A[110] = 0.157198; A[111] = 0.659031; A[112] = 0.000000; A[113] = 1.757523; A[114] = 7.971260; A[115] = 8.679568; A[116] = 3.164417; A[117] = 0.170667; A[118] = 1.024000; A[119] = 1.000000; 
# A[120] = 11.018425; A[121] = 18.598233; A[122] = 1.757523; A[123] = 14.590726; A[124] = 9.041188; A[125] = 2.787465; A[126] = 8.950323; A[127] = 1.757523; A[128] = 0.000000; A[129] = 16.331818; A[130] = 9.779026; A[131] = 1.257581; A[132] = 1.365333; A[133] = 0.853333; A[134] = 1.000000; 
# A[135] = 3.895601; A[136] = 15.344400; A[137] = 44.789680; A[138] = 11.805275; A[139] = 0.157198; A[140] = 3.100491; A[141] = 8.679568; A[142] = 7.971260; A[143] = 16.331818; A[144] = 0.000000; A[145] = 0.659031; A[146] = 4.749017; A[147] = -0.512000; A[148] = -0.853333; A[149] = 1.000000; 
# A[150] = 9.041188; A[151] = 26.608982; A[152] = 35.810416; A[153] = 20.840404; A[154] = 0.899852; A[155] = 3.895601; A[156] = 14.590726; A[157] = 8.679568; A[158] = 9.779026; A[159] = 0.659031; A[160] = 0.000000; A[161] = 1.305034; A[162] = 0.341333; A[163] = -1.024000; A[164] = 1.000000; 
# A[165] = 8.769512; A[166] = 21.931813; A[167] = 11.805275; A[168] = 16.777216; A[169] = 2.605051; A[170] = 1.864022; A[171] = 10.440274; A[172] = 3.164417; A[173] = 1.257581; A[174] = 4.749017; A[175] = 1.305034; A[176] = 0.000000; A[177] = 1.024000; A[178] = -0.170667; A[179] = 1.000000; 
# A[180] = -0.853333; A[181] = -1.194667; A[182] = 1.536000; A[183] = -1.024000; A[184] = -0.341333; A[185] = 0.000000; A[186] = -0.682667; A[187] = 0.170667; A[188] = 1.365333; A[189] = -0.512000; A[190] = 0.341333; A[191] = 1.024000; A[192] = 0.000000; A[193] = 0.000000; A[194] = 0.000000; 
# A[195] = 0.682667; A[196] = 1.536000; A[197] = 2.048000; A[198] = 1.365333; A[199] = -0.341333; A[200] = 0.512000; A[201] = 1.194667; A[202] = 1.024000; A[203] = 0.853333; A[204] = -0.853333; A[205] = -1.024000; A[206] = -0.170667; A[207] = 0.000000; A[208] = 0.000000; A[209] = 0.000000; 
# A[210] = 1.000000; A[211] = 1.000000; A[212] = 1.000000; A[213] = 1.000000; A[214] = 1.000000; A[215] = 1.000000; A[216] = 1.000000; A[217] = 1.000000; A[218] = 1.000000; A[219] = 1.000000; A[220] = 1.000000; A[221] = 1.000000; A[222] = 0.000000; A[223] = 0.000000; A[224] = 0.000000; 



B = zeros(15,15)
for i in 1:224
    B[i+1] = A[i]
end


B = [0.8402 0.7831 0.9116 0.7682 0.6289 0.6357 0.1372 0.2183 0.9728 0.8077 0.0642 0.7602 0.3540 0.6573 0.6411 
0.7831 0.3944 0.1976 0.2778 0.3648 0.7173 0.8042 0.5129 0.2925 0.9190 0.0200 0.5125 0.6879 0.8587 0.4320 
0.9116 0.1976 0.7984 0.5540 0.5134 0.1416 0.1567 0.8391 0.7714 0.0698 0.4577 0.6677 0.1660 0.4396 0.6196 
0.7682 0.2778 0.5540 0.3352 0.9522 0.6070 0.4009 0.6126 0.5267 0.9493 0.0631 0.5316 0.4401 0.9240 0.2811 
0.6289 0.3648 0.5134 0.9522 0.4774 0.0163 0.1298 0.2960 0.7699 0.5260 0.2383 0.0393 0.8801 0.3984 0.7860 
0.6357 0.7173 0.1416 0.6070 0.0163 0.9162 0.1088 0.6376 0.4002 0.0861 0.9706 0.4376 0.8292 0.8148 0.3075 
0.1372 0.8042 0.1567 0.4009 0.1298 0.1088 0.2429 0.5243 0.8915 0.1922 0.9022 0.9318 0.3303 0.6842 0.4470 
0.2183 0.5129 0.8391 0.6126 0.2960 0.6376 0.5243 0.9989 0.2833 0.6632 0.8509 0.9308 0.2290 0.9110 0.2261 
0.9728 0.2925 0.7714 0.5267 0.7699 0.4002 0.8915 0.2833 0.4936 0.8902 0.2667 0.7210 0.8934 0.4825 0.1875 
0.8077 0.9190 0.0698 0.9493 0.5260 0.0861 0.1922 0.6632 0.8902 0.3525 0.5398 0.2843 0.3504 0.2158 0.2762 
0.0642 0.0200 0.4577 0.0631 0.2383 0.9706 0.9022 0.8509 0.2667 0.5398 0.3489 0.7385 0.6867 0.9503 0.5564 
0.7602 0.5125 0.6677 0.5316 0.0393 0.4376 0.9318 0.9308 0.7210 0.2843 0.7385 0.3752 0.9565 0.9201 0.4165 
0.3540 0.6879 0.1660 0.4401 0.8801 0.8292 0.3303 0.2290 0.8934 0.3504 0.6867 0.9565 0.6400 0.1477 0.1696 
0.6573 0.8587 0.4396 0.9240 0.3984 0.8148 0.6842 0.9110 0.4825 0.2158 0.9503 0.9201 0.1477 0.5886 0.9068 
0.6411 0.4320 0.6196 0.2811 0.7860 0.3075 0.4470 0.2261 0.1875 0.2762 0.5564 0.4165 0.1696 0.9068 0.8811 ]

# LL, DD = blockbk(Symmetric(B,:L))
# display(bunchkaufman(Symmetric(B,:L)))
# A = Inplaceblockbk(Symmetric(B,:L))
# display(A)
LL, DD, ptotal = blockbk(Symmetric(B,:L))
F = LL * DD * transpose(LL)
#  display(F)
#  display(B)
#display(maximum(F-B))
pp = Matrix(Permutation(ptotal))
@show ptotal
display(pp)
F = pp*F*pp^(-1)
#F = pp^(-1)*F*pp
@show maximum(F-B)
# A =  [0.339279   0.67969    0.889256  0.72944   0.0812167  0.55535
# 0.67969    0.0695184  0.38732   0.68994   0.12333    0.630734
# 0.889256   0.38732    0.449146  0.224204  0.919446   0.305251
# 0.72944    0.68994    0.224204  0.104077  0.536392   0.730962
# 0.0812167  0.12333    0.919446  0.536392  0.680282   0.834829
# 0.55535    0.630734   0.305251  0.730962  0.834829   0.678613]

# # A = Symmetric(A,:L)
# # display(bunchkaufman(A))
# LL, DD = blockbk(A)
# F = LL * DD *transpose(LL)
# display(F)
# display(A)
