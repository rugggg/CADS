import numpy as np
import math
import matplotlib.pyplot as plt
from astropy.io import fits
from astropy.table import Table
from scipy.interpolate import BSpline
from scipy.interpolate import splrep
from scipy import stats

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
#print(np.std(x))
#print(np.mean(x))

# detect all outliers and linearly interpolate
#print([i for i in range(len(y)) if (abs(y[i] - np.mean(y)) > 2*np.std(y))])
print("DATA 1006: ",y[1006])
print("MEAN: ",np.mean(y))
print("VAR: ",np.var(y))
def find_bounds(index, outliers, left=1, right=1):
    if left+index not in outliers and right+index not in outliers:
        return left, right
    if left+index in outliers:
        left += 1
    if right+index in outliers:
        right += 1
    return find_bounds(index, outliers, left, right)

# oh - this works - but the problem is we need to use a sort of running/windowed average and std dev bc
# what we get is actually not catching all the transit points as outliers bc the lc has high variabilit before
# smoothing

def interpolate_outliers(data, sigma=2):
    new_data = data
    idx = [i for i in range(len(data)) if (abs(data[i] - np.mean(data)) > sigma*np.std(data))]
    # need to be recursive here - if index i is an outlier, but so is the previous one - then extend one that way by one and repeat as needed
    for i in idx:
        left_offset, right_offset = find_bounds(i, idx)
        print("replacing index: ",i, "offset: -",left_offset," ",right_offset)
        data[i] = data[i-left_offset] + (data[i+right_offset]-data[i-left_offset])
    return new_data

#y = interpolate_outliers(y)

print("DATA 1006: ",y[1006])
calc_s = 0.005 * len(y) * np.nanvar(y)
#calc_s = len(y) + math.sqrt(2*len(y))
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
# calc mean and std dev
y_mean = [np.nanmean(PDCSAP)]*len(x)
y_stddev = np.nanstd(PDCSAP)
print(y_stddev)

plt.subplot(211)
# plot the mean and variance lines
plt.plot(x,y_mean+y_stddev, 'b-',label='1 STD Dev')
plt.plot(x,y_mean+2*y_stddev, 'g-',label='2 STD Dev')
plt.plot(x,y_mean+3*y_stddev, 'y-',label='3 STD Dev')
plt.plot(x,y_mean-y_stddev, 'b-')
plt.plot(x,y_mean-2*y_stddev, 'g-')
plt.plot(x,y_mean-3*y_stddev, 'y-')
plt.plot(xx,y_mean,'r-',label="Mean line")
# plot the original points
plt.plot(x, y, 'bx', label='Original points')
# plot the spline
plt.plot(xx,spline(xx), 'r', label='BSpline')
plt.legend(loc='best')
plt.subplot(212)
#try a divide
flattened = np.divide(y, spline(x))
# plot the resulting spline
plt.plot(x, flattened, 'g', label='Original points')
plt.grid()
plt.legend(loc='best')

# try fitting and dividing again
calc_s_flat = len(flattened) + math.sqrt(2*len(flattened))
print(calc_s_flat)
t2,c2,k2 = splrep(x, flattened, s=calc_s_flat, k=3)
print('''\
        t:{}
        c:{}
        k:{}
'''.format(t2,c2,k2))
xx = np.linspace(xmin, xmax, len(x))
spline2 = BSpline(t2,c2,k2,extrapolate=False)
print(spline2)
plt.plot(xx,spline2(xx), 'r', label='BSpline2')

plt.legend(loc='best')
plt.show()
