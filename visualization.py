import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import parselmouth


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


    # def heatmap_visualization():
        
