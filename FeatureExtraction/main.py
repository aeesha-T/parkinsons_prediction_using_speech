from feature_extraction import Feature_Extraction
import visualization
import pandas as pd

# To extract features of a file
# filename = "dataset/ReadText/HC/ID00_hc_0_0_0.wav"
f = Feature_Extraction()
#f.features = f.extract_acoustic_features(filename, 75, 100, "Hertz")
#f.mfcc = f.extract_mfcc(filename)
#print("Acoustic features")
#print("f0_mean, f0_std_deviation, hnr, jitter_relative, jitter_absolute, jitter_rap, jitter_ppq5, shimmer_relative, shimmer_localDb, shimmer_apq3, shimmer_apq5")
#print (f.features)
#print("mfcc")
#print(f.mfcc)
#visualize the sound file
# visualization.visualize_sound_sample(filename)

#extract the features in the dataset folder

######## Testing the methods ###################
# f.features = f.extract_acoustic_features(filename, 75, 100, "Hertz")
# f.mfcc = f.extract_mfcc(filename)
# print("Acoustic features")
# print("f0_mean, f0_std_deviation, hnr, jitter_relative, jitter_absolute, jitter_rap, jitter_ppq5, shimmer_relative, shimmer_localDb, shimmer_apq3, shimmer_apq5")
# print (f.features)
# print("mfcc")
# print(f.mfcc)

######################Extract the acoustic features in the dataset folder####################
# the healthy controls dataset
folder_hc = r"dataset/ReadText/HC/*.wav"
# the PD patients dataset
folder_pd = r"dataset/ReadText/PD/*.wav"


# call the function to extract the features from the folder
df_hc = f.extract_features_from_folder(folder_hc)
#assign 0 as the label for the healthy controls
df_hc['label'] = 0
df_pd = f.extract_features_from_folder(folder_pd)
#assign 1 as the label for the patients
df_pd['label'] = 1
df_readtext = pd.concat([df_hc, df_pd])
#save the features in a .csv file
#f.convert_to_csv(df_readtext,"readtext")
df_acoustic_features = pd.concat([df_hc,df_pd])
#f.convert_to_csv(df_acoustic_features,"MDVR_acoustic_features")


# call the function to extract the features from the folder
df_hc_2 = f.extract_features_from_folder_2(folder_hc) #for replicating the original ALC research paper 
df_hc_2['label'] = 0
df_pd_2 = f.extract_features_from_folder_2(folder_pd)
df_pd_2['label'] = 1
df_readtext_2 = pd.concat([df_hc_2, df_pd_2])
#f.convert_to_csv(df_readtext_2,"readtext_2")


################# Extract the mfcc ########################
print("About to get mfcc")
df_mfcc_hc = f.extract_mfcc_from_folder(folder_hc)
df_mfcc_hc['label'] = 0
df_mfcc_pd = f.extract_mfcc_from_folder(folder_pd)
df_mfcc_pd['label'] = 1
df_mfcc_features = pd.concat([df_mfcc_hc,df_mfcc_pd])
#f.convert_to_csv(df_mfcc_features, "MDVR_mfcc_features")
print(df_mfcc_features.head())
print("Done")


##################### Combine the both acoustic features and MFCC in a csv file##################
#drop the label from the aocustic features table
df_acoustic_features_2 = df_acoustic_features.drop(columns = ['label'])
#drop the voiceID from the mfcc table
df_mfcc_features_2 = df_mfcc_features.drop(columns =['voiceID'])
df_all_features = pd.concat([df_acoustic_features_2, df_mfcc_features_2], axis=1)
f.convert_to_csv(df_all_features, "MDVR_all_features")
print(df_all_features)
