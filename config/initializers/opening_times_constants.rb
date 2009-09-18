SITEMAP_PAGE_SIZE = 50_000 # for XML sitemaps

EMAIL_REGX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

POSTCODE_REGX = /[A-Z]{1,2}[0-9R][0-9A-Z]?\s*[0-9][ABD-HJLNP-UW-Z]{2}/i

POSTCODE_REGX2 = \
/\b(
( # begin postal district group
(?:[BEGLMNS][1-9]\d?) |
(?:W[2-9]) |
(?:
(?:A[BL] |
B[ABDHLNRST] |
C[ABFHMORTVW] |
D[ADEGHLNTY] |
E[HNX] |
F[KY] |
G[LUY] |
H[ADGPRSUX] |
I[GMPV] |
JE |
K[ATWY] |
L[ADELNSU] |
M[EKL] |
N[EGNPRW] |
O[LX] |
P[AEHLOR] |
R[GHM] |
S[AEGKL-PRSTWY] |
T[ADFNQRSW] |
UB |
W[ADFNRSV] |
YO |
ZE)
\d\d?) |
(?:[EW]1[A-HJKSTUW0-9]) |
(?:(?:(?:WC[1-2]) |
(?:EC[1-4]) |
(?:SW1))[ABEHMNPRVWXY]?)
) # end postal district group
(?:\s*)
([0-9][ABD-HJLNP-UW-YZ]{2})
) # end complete group
/ix
