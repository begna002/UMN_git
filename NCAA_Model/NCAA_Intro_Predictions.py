import pandas as pd
from sklearn.tree import DecisionTreeRegressor
from sklearn.model_selection import train_test_split
from sklearn.impute import SimpleImputer
from sklearn.metrics import mean_absolute_error
from xgboost import XGBRegressor

data = pd.read_csv("NCAATourneyDetailedREsultsEnriched2018.csv")

    
y = data.WTeamID
data.dropna(axis = 0, subset = ['WTeamID'], inplace = True)
X = data.drop(['WTeamID'], axis = 1).select_dtypes(exclude=['object'])

train_X, test_X, train_y, test_y = train_test_split(X.as_matrix(), y.as_matrix(),
                                                    test_size = 0.25)

my_imputer = SimpleImputer()
train_X = my_imputer.fit_transform(train_X)
test_X = my_imputer.transform(test_X)

#model = DecisionTreeRegressor(random_state = 1)
#model.fit(X, y)

model = XGBRegressor(n_estimators = 100, learning_rate = 0.05)
model.fit(train_X, train_y, early_stopping_rounds=5, 
             eval_set=[(test_X, test_y)], verbose=False)
predictions = model.predict(test_X)

print(predictions)
print(y)
print("MAE: ", mean_absolute_error(predictions, test_y))
