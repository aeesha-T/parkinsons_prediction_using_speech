import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import librosa 
import librosa.display
import IPython.display as ipd
import parselmouth
import seaborn as sns
from parselmouth.praat import call
import glob
import os.path

class Feature_Extraction:
    """
    Feature extraction class containing the methods to extract features for each voice sample
    
    Attributes:
    acoustic_features : list
         a list of acoustic features such as jitters and shimmers for a voice sample
    mfcc: list
         a list of mfcc extracted from the voice sample 
            
    """
    
    def __init__(self):
        self.acoustic_features = []
        self.mfcc = []

    def extract_acoustic_features(self, voice_sample, f0_min, f0_max, unit):
        """
        Extracts the acoustic features such as the jitters and shimmers from the voice sample using functions from Praat software

        Parameters:
        voice_sample : .wav file
            the voice sample we want to extract the features from
        f0_min: integer
            minimum fundamental frequency of the signal. defualt is 75 on Praat software
        f0_max: integer
            maximum fundamental frequency of the signal. default is 500 on Praat software

        """
        sound = parselmouth.Sound(voice_sample)
        pitch = call(sound, "To Pitch", 0.0, f0_min, f0_max)
        f0_mean = call(pitch, "Get mean", 0, 0, unit) 
        f0_std_deviation= call(pitch, "Get standard deviation", 0, 0, unit) 
        harmonicity = call(sound, "To Harmonicity (cc)", 0.01, f0_min, 0.1, 1.0)
        hnr = call(harmonicity, "Get mean", 0, 0)
        pointProcess = call(sound, "To PointProcess (periodic, cc)", f0_min, f0_max)
        jitter_relative = call(pointProcess, "Get jitter (local)", 0, 0, 0.0001, 0.02, 1.3)
        jitter_absolute = call(pointProcess, "Get jitter (local, absolute)", 0, 0, 0.0001, 0.02, 1.3)
        jitter_rap = call(pointProcess, "Get jitter (rap)", 0, 0, 0.0001, 0.02, 1.3)
        jitter_ppq5 = call(pointProcess, "Get jitter (ppq5)", 0, 0, 0.0001, 0.02, 1.3)
        shimmer_relative =  call([sound, pointProcess], "Get shimmer (local)", 0, 0, 0.0001, 0.02, 1.3, 1.6)
        shimmer_localDb = call([sound, pointProcess], "Get shimmer (local_dB)", 0, 0, 0.0001, 0.02, 1.3, 1.6)
        shimmer_apq3 = call([sound, pointProcess], "Get shimmer (apq3)", 0, 0, 0.0001, 0.02, 1.3, 1.6)
        shimmer_apq5 = call([sound, pointProcess], "Get shimmer (apq5)", 0, 0, 0.0001, 0.02, 1.3, 1.6)
    
        return f0_mean, f0_std_deviation, hnr, jitter_relative, jitter_absolute, jitter_rap, jitter_ppq5, shimmer_relative, shimmer_localDb, shimmer_apq3, shimmer_apq5
    
    def extract_mfcc(self, voice_sample):
        """
        Extracts the mel frequency ceptral coefficients from the voice sample

        Parameters:
        voice_sample : .wav file
            the voice sample we want to extract the features from
        """

        sound = parselmouth.Sound(voice_sample)
        mfcc_object = sound.to_mfcc(number_of_coefficients=12) #the optimal number of coeefficient used is 12
        mfcc = mfcc_object.to_array()

        return mfcc

