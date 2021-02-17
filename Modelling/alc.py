import pandas as pd
import numpy as np
import matplotlib as plt
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import confusion_matrix
from sklearn.preprocessing import StandardScaler
from sklearn import svm
from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.feature_selection import SelectFromModel

df = pd.read_csv(r"./alc_features.csv")
#print(df)

#drop the first column. It's the voiceID
df.drop('voiceID', inplace = True, axis = 1)

#separate dependent and independent variable
X = df.iloc[:, :-1]
df_X = df.iloc[:, :-1].values
df_Y = df.iloc[:,-1].values

# Split the dataset into the Training set and Test set
X_train, X_test, y_train, y_test = train_test_split(df_X, df_Y, test_size = 0.3, random_state = 0)

# Scale
sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)

# Fit classifier to the Training set
model_knn = KNeighborsClassifier(n_neighbors = 10)
model_knn.fit(X_train, y_train)

model_svm = svm.SVC()
model_svm.fit(X_train, y_train)

model_rf = RandomForestClassifier(max_depth=100, random_state=0)
model_rf.fit(X_train, y_train)

model_gb = GradientBoostingClassifier(random_state=0)
model_gb.fit(X_train, y_train)

#predict
y_pred_knn = model_knn.predict(X_test)
y_pred_svm = model_svm.predict(X_test)
y_pred_rf = model_rf.predict(X_test)
y_pred_gb = model_gb.predict(X_test)

#predictions are in columns and actual values in rows
conf_matrix_knn = confusion_matrix(y_test, y_pred_knn)
conf_matrix_svm = confusion_matrix(y_test, y_pred_svm)
conf_matrix_rf = confusion_matrix(y_test, y_pred_rf)
conf_matrix_gb = confusion_matrix(y_test, y_pred_gb)
print(conf_matrix_knn)
print(conf_matrix_svm)
print(conf_matrix_rf)
print(conf_matrix_gb)

accuracy_knn = ((conf_matrix_knn[0,0] + conf_matrix_knn[1,1])/(conf_matrix_knn[0,0] +conf_matrix_knn[0,1]+conf_matrix_knn[1,0]+conf_matrix_knn[1,1]))*100
accuracy_svm = ((conf_matrix_svm[0,0] + conf_matrix_svm[1,1])/(conf_matrix_svm[0,0] +conf_matrix_svm[0,1]+conf_matrix_svm[1,0]+conf_matrix_svm[1,1]))*100
accuracy_rf = ((conf_matrix_rf[0,0] + conf_matrix_rf[1,1])/(conf_matrix_rf[0,0] +conf_matrix_rf[0,1]+conf_matrix_rf[1,0]+conf_matrix_rf[1,1]))*100
accuracy_gb = ((conf_matrix_gb[0,0] + conf_matrix_gb[1,1])/(conf_matrix_gb[0,0] +conf_matrix_gb[0,1]+conf_matrix_gb[1,0]+conf_matrix_gb[1,1]))*100
print(accuracy_knn)
print(accuracy_svm)
print(accuracy_rf)
print(accuracy_gb)
