import numpy as np
import math
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
#hdulist = fits.open('../data/kplr000891901-2009131105131_llc.fits')
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
# print and display the light curve
#print(PDCSAP)
#plt.show()

# now we need to flatten the light curve to remove low frequency 
# variability

# the way the paper does this is to fit a basis spline to to the LC
# and then divide by the best fit spline

# we want to actually remove the transit events for flattening

x = TIME[~np.isnan(PDCSAP)]
y = PDCSAP[~np.isnan(PDCSAP)]
print(np.std(x))
print(np.mean(x))
#print([i for i in range(len(x)) if (abs(x[i] - np.mean(x)) > 1*np.std(x))])
calc_s = 0.005 * len(y) * np.nanvar(y)
print(calc_s)
calc_s = len(y) + math.sqrt(2*len(y))
print(calc_s)
#(m-sqrt(2*m),m+sqrt(2*m))
t,c,k = splrep(x, y, s=calc_s, k=5)
#print('''\
#        t:{}
#        c:{}
#        k:{}
#'''.format(t,c,k))
xmin, xmax = x.min(), x.max()
xx = np.linspace(xmin, xmax, len(x))
spline = BSpline(t,c,k,extrapolate=False)


plt.subplot(211)
plt.plot(x, y, 'bx', label='Original points')
plt.plot(xx,spline(xx), 'r', label='BSpline')
plt.subplot(212)
#try a divide
flattened = np.divide(y, spline(x))
plt.plot(x, flattened, 'g', label='Original points')

plt.grid()
plt.legend(loc='best')
plt.show()
