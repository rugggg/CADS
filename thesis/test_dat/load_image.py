from astropy.io import fits
from astropy.table import Table
import matplotlib.pyplot as plt

hdulist = fits.open('kplr000892667-2009166043257_llc.fits')
hdulist.info()
lc_data = hdulist[1].data
print(type(lc_data))
print(lc_data.shape)
col_data = hdulist[1].columns
print(col_data)
PDCSAP = lc_data['PDCSAP_FLUX']
print(PDCSAP)
plt.plot(PDCSAP)
plt.show()
