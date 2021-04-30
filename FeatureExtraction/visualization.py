import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import parselmouth
import seaborn as sns

def visualize_sound_sample(filename):
    """
    Plots the sound wave

    Parameters:
    
    filename: the sound wave in .wav format that you want to plot
    """
    sound = parselmouth.Sound(filename)
    plt.figure()
    plt.plot(sound.xs(), sound.values.T)
    plt.xlim([sound.xmin, sound.xmax])
    plt.xlabel("time [s]")
    plt.ylabel("amplitude")
    plt.title('Sound wave plot for ' + filename)
    plt.show()


def heatmap_visualization(df):
    """
    Plots the heatmap of the correlation between the features in the dataframe df

    Parameters:
    
    df: the dataframe containing the features
    """

    for k in list(df):
        df[k]=pd.to_numeric(df[k], errors='ignore') #ensure the values are in numeric

    corr = df.corr()
    sns.heatmap(corr) 
            
