# \# Universal Neural Demodulator: AI vs Conventional Performance Analysis

# 

# \## 📡 Project Overview

# 

# This project is a MATLAB-based implementation of a \*\*Universal Neural Demodulator\*\* designed for ECE 342 – Communication I final project at Misr University for Science \& Technology.

# 

# It compares \*\*traditional signal processing demodulation techniques\*\* with a \*\*deep learning-based (CNN) approach\*\* for recovering messages from noisy modulated signals under AWGN channels.

# 

# The system supports six analog modulation schemes:

# 

# \* AM (Amplitude Modulation)

# \* DSB-SC (Double Sideband Suppressed Carrier)

# \* SSB (Single Sideband)

# \* VSB (Vestigial Sideband)

# \* FM (Frequency Modulation)

# \* PM (Phase Modulation)

# 



# 

# \## 🎯 Objective

# 

# To evaluate and compare:

# 

# \* Conventional demodulation methods based on signal theory

# \* AI-based demodulation using a 1D neural network

# 

# under different Signal-to-Noise Ratio (SNR) conditions using MATLAB simulations.

# 



# 

# \## 🧠 Methodology

# 

# \### Conventional Approach

# 

# Each modulation type is demodulated using standard techniques:

# 

# \* AM → Envelope Detection

# \* DSB-SC → Coherent Detection

# \* SSB → Hilbert Transform + Coherent Detection

# \* VSB → Bandpass Filtering + Detection

# \* FM → Phase differentiation via Hilbert transform

# \* PM → Instantaneous phase extraction

# 

# Performance is evaluated using \*\*Mean Squared Error (MSE)\*\*.

# 


# 

# \### AI-Based Approach

# 

# A \*\*1D Multi-Layer Perceptron (MLP/CNN-based model)\*\* is trained to map noisy signals directly to clean message signals.

# 

# \* Input: Noisy modulated signal

# \* Output: Original message signal

# \* Loss Function: Mean Squared Error (MSE)

# 



# 

# \## 🧬 Dataset Generation

# 

# A synthetic dataset was created with:

# 

# \* Random modulation type (AM, DSB-SC, SSB, VSB, FM, PM)

# \* Message frequency: 50–100 Hz

# \* SNR range: 0–30 dB

# \* AWGN channel simulation

# 

# Each sample contains:

# 

# \* Input → Noisy signal

# \* Target → Clean message signal

# 


# 

# \## 🏗️ Neural Network Architecture

# 

# \* Input size: \~501 samples

# \* Hidden Layer 1: 128 neurons + ReLU

# \* Hidden Layer 2: 256 neurons + ReLU

# \* Output Layer: Regression output

# \* Optimizer: Adam

# \* Epochs: 25

# \* Batch Size: 64

# 



# 

# \## 📊 Results Summary

# 

# \### Conventional vs AI Performance

# 

# \* AM: 83.7% error reduction

# \* DSB-SC: 33.3% improvement

# \* SSB: 81.4% improvement

# \* VSB: 66.0% improvement

# \* FM: 95.1% improvement (171× gain)

# \* PM: 93.9% improvement

# 

# \### Key Observations

# 

# \* CNN significantly outperforms conventional methods in low SNR conditions

# \* FM and PM show the highest AI advantage due to nonlinear modeling

# \* DSB-SC shows smaller gains due to optimal classical performance

# \* One model generalizes across all modulation schemes

# 


# 

# \## 📈 Key Insights

# 

# \* AI removes need for carrier synchronization

# \* CNN learns direct signal reconstruction without explicit formulas

# \* Strong robustness in noisy environments

# \* Unified demodulation system for multiple modulation types

# 



# 

# \## 📁 Project Files

# 

# \* `COMMUNICATION\_PROJECT.m` → Main MATLAB simulation

# \* `net.mat` → Trained neural network model

# \* `.mat datasets` → Signal datasets

# \* PDF report → Full documentation

# \* README.md → Project overview

# 



# 

# \## 🚀 How to Run

# 

# 1\. Open MATLAB

# 2\. Load project folder

# 3\. Run:

# 

# &#x20;  ```matlab

# &#x20;  COMMUNICATION\_PROJECT.m

# &#x20;  ```

# 4\. Ensure required `.mat` files are in the same directory

# 



# 

# \## 👨‍🏫 Supervisor

# 

# \*\*Dr. Ashraf Samy\*\*

# 


# 

# \## 🏫 Course

# 

# ECE 342 – Communication I

# Misr University for Science \& Technology

# 


# 

# \## 📌 Conclusion

# 

# This project demonstrates that deep learning can successfully replace traditional demodulation techniques, providing a \*\*unified, noise-robust, and adaptive communication receiver\*\* capable of handling multiple modulation schemes.





