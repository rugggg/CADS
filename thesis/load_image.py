from astropy.io import fits
from astropy.table import Table
import matplotlib.pyplot as plt

hdulist = fits.open('kplr000893004-2012277125453_llc.fits')
hdulist.info()
image_data = hdulist[1].data
print(type(image_data))
print(image_data.shape)
col_data = hdulist[1].columns
print(col_data)
evt_data = Table(image_data)
print(evt_data[1])

#NBINS = 50
#bright_hist = plt.hist(evt_data["TIME"], NBINS)
#print(type(image_data.flatten()))
# plot
#plt.imshow(image_data)
