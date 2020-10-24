from feature_extraction import Feature_Extraction
import visualization

# Extracting features of a file
filename = "dataset/ReadText/HC/ID00_hc_0_0_0.wav"

f = Feature_Extraction()
f.features = f.extract_acoustic_features(filename, 75, 100, "Hertz")
f.mfcc = f.extract_mfcc(filename)
print("Acoustic features")
print("f0_mean, f0_std_deviation, hnr, jitter_relative, jitter_absolute, jitter_rap, jitter_ppq5, shimmer_relative, shimmer_localDb, shimmer_apq3, shimmer_apq5")
print (f.features)
print("mfcc")
print(f.mfcc)

#visualize the sound file
visualization.visualize_sound_sample(filename)