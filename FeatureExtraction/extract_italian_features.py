from feature_extraction import Feature_Extraction
#import visualization
import pandas as pd

# To extract features of a file
#filename = "dataset/ReadText/HC/ID00_hc_0_0_0.wav"

f = Feature_Extraction()
#f.features = f.extract_acoustic_features(filename, 75, 100, "Hertz")
#f.mfcc = f.extract_mfcc(filename)
#print("Acoustic features")
#print("f0_mean, f0_std_deviation, hnr, jitter_relative, jitter_absolute, jitter_rap, jitter_ppq5, shimmer_relative, shimmer_localDb, shimmer_apq3, shimmer_apq5")
#print (f.features)
#print("mfcc")
#print(f.mfcc)

#extract the features in the dataset folder
# the healthy controls dataset

folder_hc = r"dataset\ItalianParkinsonSpeech\EHC\*.wav"
# the PD patients dataset
folder_pd = r"dataset\ItalianParkinsonSpeech\PD\*.wav"
# call the function to extract the features from the folder
#df_hc = f.extract_features_from_folder(folder_hc)
df_hc_2 = f.extract_features_from_folder_2(folder_hc) #for replicating the research paper 
#assign 0 as the label for the healthy controls
df_hc_2['label'] = 0
#df_pd = f.extract_features_from_folder(folder_pd)
df_pd_2 = f.extract_features_from_folder_2(folder_pd)
#assign 1 as the label for the patients
df_pd_2['label'] = 1

#save the features in a .csv file
#df_readtext = pd.concat([df_hc,df_pd])
df_readtext_2 = pd.concat([df_hc_2, df_pd_2])
f.convert_to_csv(df_readtext_2,"italian_dataset")

#visualize the sound file
#visualization.visualize_sound_sample(filename)