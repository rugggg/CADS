import numpy as np

tab = np.genfromtxt("hlsp_k2sff_k2_lightcurve_210370462-c04_kepler_v1_llc-default-aper.txt", dtype=None, delimiter=",")
print(tab[0,1])
