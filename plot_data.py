import alpha_vantage
import os
import datetime as dt
from alpha_vantage.cryptocurrencies import CryptoCurrencies
from alpha_vantage.timeseries import TimeSeries
import matplotlib.pyplot as plt

key = os.path.expandvars("$ALPHA_VANTAGE_HIGHER_KEY")
# Or your key here!
cc = CryptoCurrencies(key=key, output_format='pandas')


ts = TimeSeries(key=key, output_format='pandas')
data, meta_data = ts.get_daily('TSLA', outputsize='full')
data = data.head(1750)

from matplotlib.pyplot import figure
figure(num=None, figsize=(15, 6), dpi=80, facecolor='w', edgecolor='k')
data['4. close'].plot()
plt.tight_layout()
plt.grid()
plt.show()
