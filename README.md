## Overview
During an MRI exam, a subject or patient is exposed to a strong static magnetic field which typically ranges from 1T to 3T in clinical scanners and up to 10.5T in research scanners. The physical interaction between the static magnetic field and the pulsatile blood flow, which is caused by the rhythmic action of the heart, results in the magnetohydrodynamic (MHD) effect.

Ions (electrolytes) contained in the blood are moving inside the vessels where they experience a force due to the presence of the MR scanner’s static magnetic field. This force, which is known as Lorentz force, causes the ions to move perpendicular to the direction of the blood flow and perpendicular to the MR scanner’s static magnetic field. The ions accumulate near the vessel’s wall leading to a potential difference across the vessel. This potential difference or voltage is referred to as the Hall voltage. The Hall voltages across the blood vessels lead to blood flow dependent body surface potentials which are superimposing the ECG signals.

Due to the superposition of the ECG and MHD signals, a detailed and reliable morphological analysis of the ECG during MRI exams, e.g. of the P wave, ST segment or the T wave, is not possible. Another challenge is the detection of the QRS complex. Depending on the characteristics of the MHD signal, QRS detection might be hampered.

In this project consists of the following steps:
- Signal decomposition using Multiresolution Analysis Algorithm by *Mallat, S. G*.
- Implementation of **R-peak detection** algorithm to detect the most accurate wavelet scales.
- Comparison of the different scales using **Positive Predictive Value +P** .
- Signal reconstruction using the 2 scales with the highest Positive Predictive Value.
- Quadratic phase coupling detection of the reconstructed signal and comparison with the non-MHD contaminated ECG.

###### Dataset
This ECG dataset was acquired in different magnetic resonance imaging (MRI) scanners to study the magnetohydrodynamic (MHD) effect. The MHD effect, which is caused an interaction of the MRI’s strong static magnetic field and the patient’s blood flow, superimposes the ECG signal during MRI exams. As a consequence, a detailed morphological analysis of the ECG (e.g. of the P wave, ST segment or the T wave) is prevented. The MHD effect might be a useful signal for extracting further physiological information, e.g. about blood flow or stroke volume.<br />

https://physionet.org/content/mhd-effect-ecg-mri/1.0.0/

###### Signal decomposition
Multiresolution analysis decomposes a signal at different scales. Filters of different cut-off frequencies are used for analyzing the signal at different resolution levels. For this purpose, the signal is passed through series of high pass and low pass filters in order to analyze low as well as high frequencies in the signal. At each level, the high pass filter produces a detail information dn, while the low pass filter associated with scaling function produces coarse approximations An. The half band filters produce signals spanning only half the frequency band. This doubles the frequency resolution.


###### Implementation of **R-peak detection** algorithm
The wavelet coefficient was filtered using a high pass, **5th order Butterworth** filter with a cut-off frequency of 3 Hz for amplitude normalization and DC extraction. The **kurtosis** was then calculated in a sliding window of length L = 0.02 * fs and a step width of 1 sample. The length of the R-wave is calculated as the integer part of D = 0.2 * fs. Next, the coefficient is windowed with a sliding window of L samples. At each window, kurtosis is estimated and their values correspond to the last frame of the window. Then, a Gaussianity test is performed. It is physiologically not possible that a second R-peak occurs 200 ms after another R-peak. This fact was considered by the algorithm.

###### Comparison of the different scales

In order to gather the 2 wavelet coefficients to reconstruct the ECG signal, the positive predictive value (+P) was used to compare the coefficients among them. This approach relies on the fact that the MHD increases the amplitude of the T-wave, which is oftenly datected as an R-wave. This way, we are able to locate the coefficients which MHD most contaminates. These coeffients, will have an increased number of false positive (FP) and thus, low positive predictive p value. As we are mostly interested in the number of false positives per coefficient, this metric is the most suitable for the MHD contamination problem.

###### Quadratic phase coupling detection of the reconstructed signal and comparison with the non-MHD contaminated ECG.

Pulse frequency represents the rhythms of a normal heartbeat, ranged from 1 Hz to 1.7 Hz. This frequency is called as the fundamental frequency of heart dynamics f0.In subjects
outside and inside the MRI, this frequency is the main component of the signal and should contain major fraction ofthe power in the power spectrum. \For a subject outside the MRI, the power is distributed among the frequencies in the range of 0-20 Hz, whereas in case of MHD contamination the power is distributed among the frequencies in the range of 0-10 Hz.<br />

In order to characterize the underlying dynamics of the heart, we have to do a comprehensive bispectral analysis of the ECG signals. The bispectrum measures the volume of the
signal energy at any frequency pair that is quadratically phase coupled. While the pulse frequency indicates strong phase coupling with other frequencies in the case of non MHD contaminated ECG signals, the number of frequency pairs (f0,f1) with significant bispectrum value decreases significantly in the case of MHD contamination. These give interesting MHD specific indications from their relative values.

## In this repo the paper written for the project above is included. 



