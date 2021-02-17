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

df = pd.read_csv(r"./readtext_2.csv")
#print(df)

#drop the first column. It's the voiceID
df.drop('voiceID', inplace = True, axis = 1)

#separate dependent and independent variable
X = df.iloc[:, :-1]
df_X = df.iloc[:, :-1].values
df_Y = df.iloc[:,-1].values


#print(df_X)

# Split the dataset into the Training set and Test set
X_train, X_test, y_train, y_test = train_test_split(df_X, df_Y, test_size = 0.3, random_state = 0)

# Scale
sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)

#Feature selection
sel = SelectFromModel(RandomForestClassifier(n_estimators = 100))
sel.fit(X_train, y_train)
print(sel.get_support())
selected_feat= X.columns[(sel.get_support())]
print(len(selected_feat))
print(selected_feat)

####Using the selected features used in the paper
#9 features - drop the remaining 4
X_9 = X.drop(['ddpJitter','localdbShimmer','apq3Shimmer','ddaShimmer'], axis = 1)
df_X9 = X_9.values
# Split the dataset into the Training set and Test set
X9_train, X9_test, y9_train, y9_test = train_test_split(df_X9, df_Y, test_size = 0.3, random_state = 0)
# Scale
X9_train = sc.fit_transform(X9_train)
X9_test = sc.transform(X9_test)

#7 features 
X_7 = X[['meanF0Hz','maxF0Hz','minF0Hz','localabsoluteJitter','rapJitter', 'localShimmer', 'apq5Shimmer']]
df_X7 = X_7.values
# Split the dataset into the Training set and Test set
X7_train, X7_test, y7_train, y7_test = train_test_split(df_X7, df_Y, test_size = 0.3, random_state = 0)
# Scale
X7_train = sc.fit_transform(X7_train)
X7_test = sc.transform(X7_test)

#4 features 
X_4 = X[['maxF0Hz','minF0Hz','rapJitter','apq5Shimmer']]
df_X4 = X_4.values
# Split the dataset into the Training set and Test set
X4_train, X4_test, y4_train, y4_test = train_test_split(df_X4, df_Y, test_size = 0.3, random_state = 0)
# Scale
X4_train = sc.fit_transform(X4_train)
X4_test = sc.transform(X4_test)


# Fit classifier to the Training set
model_knn = KNeighborsClassifier(n_neighbors = 10)
model_knn.fit(X_train, y_train)

model_knn9 = KNeighborsClassifier(n_neighbors = 10)
model_knn9.fit(X9_train, y9_train)
model_knn7 = KNeighborsClassifier(n_neighbors = 10)
model_knn7.fit(X7_train, y7_train)
model_knn4 = KNeighborsClassifier(n_neighbors = 10)
model_knn4.fit(X4_train, y4_train)

model_svm = svm.SVC()
model_svm.fit(X_train, y_train)

model_rf = RandomForestClassifier(max_depth=10, random_state=0)
model_rf.fit(X_train, y_train)

model_gb = GradientBoostingClassifier(random_state=0)
model_gb.fit(X_train, y_train)




#predict
y_pred_knn = model_knn.predict(X_test)
y_pred_svm = model_svm.predict(X_test)
y_pred_rf = model_rf.predict(X_test)
y_pred_gb = model_gb.predict(X_test)

y_pred_knn9 = model_knn9.predict(X9_test)
y_pred_knn7 = model_knn7.predict(X7_test)
y_pred_knn4 = model_knn4.predict(X4_test)

#confusion matrix
conf_matrix_knn = confusion_matrix(y_test, y_pred_knn)
conf_matrix_svm = confusion_matrix(y_test, y_pred_svm)
conf_matrix_rf = confusion_matrix(y_test, y_pred_rf)
conf_matrix_gb = confusion_matrix(y_test, y_pred_gb)
print(conf_matrix_knn)
print(conf_matrix_svm)
print(conf_matrix_rf)
print(conf_matrix_gb)

conf_matrix_knn9 = confusion_matrix(y9_test, y_pred_knn9)
print(conf_matrix_knn9)
conf_matrix_knn7 = confusion_matrix(y7_test, y_pred_knn7)
print(conf_matrix_knn7)
conf_matrix_knn4 = confusion_matrix(y4_test, y_pred_knn4)
print(conf_matrix_knn4)

#accuracy
accuracy_knn = ((conf_matrix_knn[0,0] + conf_matrix_knn[1,1])/(conf_matrix_knn[0,0] +conf_matrix_knn[0,1]+conf_matrix_knn[1,0]+conf_matrix_knn[1,1]))*100
accuracy_svm = ((conf_matrix_svm[0,0] + conf_matrix_svm[1,1])/(conf_matrix_svm[0,0] +conf_matrix_svm[0,1]+conf_matrix_svm[1,0]+conf_matrix_svm[1,1]))*100
accuracy_rf = ((conf_matrix_rf[0,0] + conf_matrix_rf[1,1])/(conf_matrix_rf[0,0] +conf_matrix_rf[0,1]+conf_matrix_rf[1,0]+conf_matrix_rf[1,1]))*100
accuracy_gb = ((conf_matrix_gb[0,0] + conf_matrix_gb[1,1])/(conf_matrix_gb[0,0] +conf_matrix_gb[0,1]+conf_matrix_gb[1,0]+conf_matrix_gb[1,1]))*100
print(accuracy_knn)
print(accuracy_svm)
print(accuracy_rf)
print(accuracy_gb)


print("Selected features")
accuracy_knn9 = ((conf_matrix_knn9[0,0] + conf_matrix_knn9[1,1])/(conf_matrix_knn9[0,0] +conf_matrix_knn9[0,1]+conf_matrix_knn9[1,0]+conf_matrix_knn9[1,1]))*100
print(accuracy_knn9)
accuracy_knn7 = ((conf_matrix_knn7[0,0] + conf_matrix_knn7[1,1])/(conf_matrix_knn7[0,0] +conf_matrix_knn7[0,1]+conf_matrix_knn7[1,0]+conf_matrix_knn7[1,1]))*100
print(accuracy_knn7)
accuracy_knn4 = ((conf_matrix_knn4[0,0] + conf_matrix_knn4[1,1])/(conf_matrix_knn4[0,0] +conf_matrix_knn4[0,1]+conf_matrix_knn4[1,0]+conf_matrix_knn4[1,1]))*100
print(accuracy_knn4)
