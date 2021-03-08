# Research_Project

Source code for the project titled: Feature Extraction and Prediction of PD from Speech Data using Machine Learning 

==> MDVR-KCL Dataset
1. The dataset is stored in the dataset folder. 
2. The dataset/ReadText was used in this project
3. The dataset/ReadText/HC contains the healthy controls
4. The dataset/ReadText/PD contains the PD patients

==> Set up for the python code files:
1. Create/Activate a virtual environment
    python -m venv .venv

2. Run .requirements file to install the packages
    pip install -r requirements.txt

==> To extract the features (FeatureExtraction folder)
1. The feature_extraction.py contains the helper functions definition used to extract features from a sound file
2. The main.py extracts the features of the MDVR_KCL dataset using these functions
3. The extract_italian_features.py shows the extraction of the fetaures from the Italian dataset 
4. The alc_extraction.py shows the extraction of the features from the ALC dataset 
3. The features are saved in different csv files for each dataset

==> SOM experiment Repeatability of Clusters 
1. The som_script_4.r contains the implementation of the repeatability of clusters algorithm
2. Ensure the readtext.csv file is available. This is the file that contains the extracted features. 

==> ML Models (Modelling folder)
1. alc.py includes the implementation of different ML models on the ALC dataset
2. italian.py includes the implementation of different ML models on the Italian dataset
3. mdvr_kcl.py includes the implementation of different ML models on the Italian dataset

==> Experiments
1. Modelling/MDVR_KCL_experiments.ipynb : notebook for the experiemnts involving the MDVR_KCL dataset
2. Modelling/Italian_experiments.ipynb : notebook for the experiemnts involving the Italian dataset

