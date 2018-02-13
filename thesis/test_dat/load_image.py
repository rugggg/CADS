import numpy as np
import matplotlib.pyplot as plt
from astropy.io import fits
from astropy.table import Table
from scipy.interpolate import BSpline
from scipy.interpolate import splrep
from scipy.stats import zscore

# open using the astropy module
# this one is an NTP 
#hdulist = fits.open('kplr000892667-2009166043257_llc.fits')
# use this one instead - it is a PC
hdulist = fits.open('../data/kplr000757450-2009166043257_llc.fits')
# gather some basic info on the data
#hdulist.info()
lc_data = hdulist[1].data
#print(type(lc_data))
#print(lc_data.shape)
# check what our columns are
col_data = hdulist[1].columns
#print(col_data)
# zero in on the corrected flux data
PDCSAP = lc_data['PDCSAP_FLUX']
TIME = lc_data['TIME']
print(TIME.shape)
# print and display the light curve
#print(PDCSAP)
#plt.plot(PDCSAP)
#plt.show()

# now we need to flatten the light curve to remove low frequency 
# variability

# the way the paper does this is to fit a basis spline to to the LC
# and then divide by the best fit spline

x = np.array([ 0. ,  1.2,  1.9,  3.2,  4. ,  6.5])
y = np.array([ 0. ,  2.3,  3. ,  4.3,  2.9,  3.1])

x = TIME[~np.isnan(PDCSAP)]
y = PDCSAP[~np.isnan(PDCSAP)]

calc_s = 0.05 * len(y) * np.nanvar(y)
t,c,k = splrep(x, y, s=calc_s, k=5)
#print('''\
#        t:{}
#        c:{}
#        k:{}
#'''.format(t,c,k))
xmin, xmax = x.min(), x.max()
xx = np.linspace(xmin, xmax, 100)
spline = BSpline(t,c,k,extrapolate=False)

#plt.plot(x, y, 'bx', label='Original points')
#plt.plot(xx,spline(xx), 'r', label='BSpline')

#try a divide
#print(PDCSAP.shape)
#print(arraymagU2.shape)
#print(PDCSAP)
#print(arraymagU2)
#print(arraymagU)
print(spline(x))
flattened = np.divide(y, spline(x))
print(flattened)
plt.plot(x, flattened, 'g', label='Original points')

plt.grid()
plt.legend(loc='best')
plt.show()
