# Research_Project

Source code for the project titled: Feature Extraction and Prediction of PD from Speech Data using Machine Learning 

==> Dataset
1. The dataset is stored in the dataset folder. 
2. The dataset/ReadText was used in this project
3. The dataset/ReadText/HC contains the healthy controls
4. The dataset/ReadText/PD contains the PD patients

==> Set up for the python code files:
1. Create/Activate a virtual environment
    python -m venv .venv

2. Run .requirements file to install the packages
    pip install -r requirements.txt

==> To extract the features
1. The feature_extraction.py contains the functions definition used to extract features from a sound file
2. The main.py extracts the features of the dataset using these functions
3. The features are then saved in the readtext.csv file 

==> Repeatability of Clusters 
1. The som_script_4.r contains the implementation of the repeatability of clusters algorithm
2. Ensure the readtext.csv file is available. This is the file that contains the extracted features. 

