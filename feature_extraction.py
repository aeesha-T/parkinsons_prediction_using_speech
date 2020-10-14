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

    def extract_acoustic_features(self, voice_sample):
        """
        Extracts the acoustic features such as the jitters and shimmers from the voice sample

        Parameters:
        voice_sample : .wav file
            the voice sample we want to extract the features from
        """
        
