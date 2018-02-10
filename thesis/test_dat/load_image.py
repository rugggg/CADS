import numpy as np
import matplotlib.pyplot as plt
from astropy.io import fits
from astropy.table import Table
from scipy.interpolate import BSpline
from scipy.interpolate import splrep

# open using the astropy module
# this one is an NTP 
#hdulist = fits.open('kplr000892667-2009166043257_llc.fits')
# use this one instead - it is a PC
hdulist = fits.open('../data/kplr000757450-2009166043257_llc.fits')
# gather some basic info on the data
hdulist.info()
lc_data = hdulist[1].data
print(type(lc_data))
print(lc_data.shape)
# check what our columns are
col_data = hdulist[1].columns
print(col_data)
# zero in on the corrected flux data
PDCSAP = lc_data['PDCSAP_FLUX']
time = lc_data['TIME']
# print and display the light curve
#print(PDCSAP)
#plt.plot(PDCSAP)
#plt.show()

# now we need to flatten the light curve to remove low frequency 
# variability

# the way the paper does this is to fit a basis spline to to the LC
# and then divide by the best fit spline
t,c,k = splrep(time, PDCSAP, s=0, k=4)
N = 100
xmin, xmax = time.min(), time.max()
print(xmin,xmax)
xx = np.linspace(xmin,xmax,5000)
spline = BSpline(t,c,k,extrapolate=False)
spline(xx)
plt.plot(time, PDCSAP, 'bx', label='Original points')
plt.plot(xx, spline(xx), 'r', label='BSpline')
plt.grid()
plt.legend(loc='best')
plt.show()
