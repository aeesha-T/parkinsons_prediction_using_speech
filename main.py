from feature_extraction import Feature_Extraction
import visualization
import pandas as pd

# Extracting features of a file
filename = "dataset/ReadText/HC/ID00_hc_0_0_0.wav"

f = Feature_Extraction()
#f.features = f.extract_acoustic_features(filename, 75, 100, "Hertz")
#f.mfcc = f.extract_mfcc(filename)
print("Acoustic features")
print("f0_mean, f0_std_deviation, hnr, jitter_relative, jitter_absolute, jitter_rap, jitter_ppq5, shimmer_relative, shimmer_localDb, shimmer_apq3, shimmer_apq5")
#print (f.features)
print("mfcc")
#print(f.mfcc)

#extract features in a folder
folder_hc = r"dataset\ReadText\HC\*.wav"
folder_pd = r"dataset\ReadText\PD\*.wav"
df_hc = f.extract_features_from_folder(folder_hc)
df_hc['label'] = 0
df_pd = f.extract_features_from_folder(folder_pd)
df_pd['label'] = 1

#save .csv
df_readtext = pd.concat([df_hc,df_pd])
f.convert_to_csv(df_readtext,"readtext")

#visualize the sound file
#visualization.visualize_sound_sample(filename)