from feature_extraction import Feature_Extraction
#import visualization
import pandas as pd
import os
import glob
from datetime import datetime
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
# main_folder = r"C:\Users\Aeesha\Downloads\ALC_Dataset\ALC"
# main_folder = r"C:\Users\Aeesha\Downloads\ALC_Dataset\ALC"
main_folder = "/home/kompalli/atoye_rd/ALC"
#save the features in a .csv file


df_total_acoustic_features = pd.DataFrame()
df_total_acoustic_mfcc_features = pd.DataFrame()
for root, dirs, files in os.walk(main_folder):
    for name in dirs:
        #print("Processing directory:", name)
        folder_path = os.path.join(root, name)
        folder_path = folder_path + "/*_h_00.wav"
        curr_time = datetime.now()
        print("Processing files:", folder_path, ", time:", curr_time)
        df_acoustic_features = f.extract_features_from_folder(folder_path)
        df_features_mfcc = f.extract_mfcc_from_folder(folder_path)
        df_features_mfcc_2 = df_features_mfcc.drop(columns =['voiceID'])
        df_all_features = pd.concat([df_acoustic_features, df_features_mfcc_2], axis=1)
        
        if(name.startswith("ses1") or name.startswith("ses3")):
            df_acoustic_features['label'] = 1 #assign 1 to alcohol (A)
            df_total_acoustic_features = pd.concat([df_total_acoustic_features, df_acoustic_features])
            df_all_features['label'] = 1 
            df_total_acoustic_mfcc_features = pd.concat([df_total_acoustic_mfcc_features, df_all_features])
            
        elif (name.startswith("ses2") or name.startswith("ses4") ): #these are NA 
            df_acoustic_features['label'] = 0 #assign 0 to not-alcohol (NA)
            df_total_acoustic_features = pd.concat([df_total_acoustic_features, df_acoustic_features])
            df_all_features['label'] = 0 
            df_total_acoustic_mfcc_features = pd.concat([df_total_acoustic_mfcc_features, df_all_features])
    
       
f.convert_to_csv(df_total_acoustic_features,"alc_features")
f.convert_to_csv(df_total_acoustic_mfcc_features,"alc_acoustic_mfcc_features") 
print("Done")


