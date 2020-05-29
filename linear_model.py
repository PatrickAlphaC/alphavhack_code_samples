# Code example
import matplotlib.pyplot as plt
import pandas as pd
from alpha_vantage.timeseries import TimeSeries
# Remember to have an environment variable named:
#ALPHAVANTAGE_API_KEY
# otherwise, use:
# ts = TimeSeries(output_format = "pandas", key = <key_here>)
ts = TimeSeries(output_format = "pandas")
tsla_data, meta_data = ts.get_daily_adjusted(symbol = 'TSLA', outputsize = 'full')
tsla_data = tsla_data.reset_index()
tsla_data.plot(x = 'date', y = '5. adjusted close')
plt.show()

import sklearn.linear_model
# The prediction package doesn't work with dates
# So we convert all the dates in the index to floats
tsla_data['date'] = tsla_data['date'].values.astype(float)

# # We can go over what .c_ does later
X = np.c_[tsla_data['date']]
Y = np.c_[tsla_data['5. adjusted close']]

# Select a linear model
model = sklearn.linear_model.LinearRegression()

# Train the model
model.fit(X, Y)

# Make a prediction
date = [[1736208000000000000.0]] # This is the float value of 2025-01-07
print(model.predict(date))
