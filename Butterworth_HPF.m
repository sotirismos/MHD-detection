% function high_pass_filtered_signal = butterworth_high_pass_filter(original_signal,order,cutoff,sampling_frequency)
%
% High-pass filter a given signal using a forward-backward, zero-phase
% butterworth filter.
%
%% INPUTS:
% original_signal: The 1D signal to be filtered
% order: The order of the filter (1,2,3,4 etc). NOTE: This order is
% effectively doubled as this function uses a forward-backward filter that
% ensures zero phase distortion
% cutoff: The frequency cutoff for the high-pass filter (in Hz)
% sampling_frequency: The sampling frequency of the signal being filtered
% (in Hz).
% figures (optional): boolean variable dictating the display of figures
%
%% OUTPUTS:
% high_pass_filtered_signal: the high-pass filtered signal.

function high_pass_filtered_signal = Butterworth_HPF(original_signal,order,cutoff,sampling_frequency)

%Get the butterworth filter coefficients
[B_high,A_high] = butter(order,2*cutoff/sampling_frequency,'high');

%Forward-backward filter the original signal using the butterworth
%coefficients, ensuring zero phase distortion
high_pass_filtered_signal = filtfilt(B_high,A_high,original_signal);
end