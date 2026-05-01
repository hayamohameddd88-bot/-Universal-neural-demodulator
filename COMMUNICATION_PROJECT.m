clc;
clear;
close all;

%% =========================
% PART 1: PARAMETERS
% =========================
Fs = 10000;      % Sampling frequency
Fc = 1000;       % Carrier frequency
Fm = 100;        % Message frequency

Am = 1;          % Message amplitude
Ac = 2;          % Carrier amplitude

t = 0:1/Fs:0.05; % Time vector

% Message & carrier
m_t = Am * cos(2*pi*Fm*t);
c_t = Ac * cos(2*pi*Fc*t);

figure;
subplot(2,1,1); plot(t,m_t); title('Message Signal'); grid on;
subplot(2,1,2); plot(t,c_t); title('Carrier Signal'); grid on;

%% =========================
% FILTER (USED FOR ALL DEMOD)
% =========================
[b,a] = butter(5,150/(Fs/2),'low');

%% =========================
% PART 2: DSB-SC
% =========================
s_dsb = m_t .* c_t;

figure;
subplot(2,1,1); plot(t,s_dsb); title('DSB-SC Signal'); grid on;

L = length(s_dsb);
f = linspace(-Fs/2, Fs/2, L);
Y = abs(fftshift(fft(s_dsb)))/L;

subplot(2,1,2); plot(f,Y); title('DSB Spectrum'); xlim([-1500 1500]); grid on;

%% =========================
% PART 3: AM
% =========================
s_am = (Ac + m_t).*cos(2*pi*Fc*t);

figure;
subplot(2,1,1); plot(t,s_am); title('AM Signal'); grid on;

Y = abs(fftshift(fft(s_am)))/L;
subplot(2,1,2); plot(f,Y); title('AM Spectrum'); xlim([-1500 1500]); grid on;

%% =========================
% PART 4: SSB (Hilbert)
% =========================
m_hat = imag(hilbert(m_t));
s_ssb = m_t.*cos(2*pi*Fc*t) - m_hat.*sin(2*pi*Fc*t);

figure;
subplot(2,1,1); plot(t,s_ssb); title('SSB Signal'); grid on;

Y = abs(fftshift(fft(s_ssb)))/L;
subplot(2,1,2); plot(f,Y); title('SSB Spectrum'); xlim([-1500 1500]); grid on;

%% =========================
% PART 5: VSB
% =========================
s_dsb2 = m_t .* c_t;
[b_v,a_v] = butter(4,[800 1200]/(Fs/2),'bandpass');
s_vsb = filtfilt(b_v,a_v,s_dsb2);

figure;
subplot(2,1,1); plot(t,s_vsb); title('VSB Signal'); grid on;

Y = abs(fftshift(fft(s_vsb)))/L;
subplot(2,1,2); plot(f,Y); title('VSB Spectrum'); xlim([-1500 1500]); grid on;

%% =========================
% PART 6: FM
% =========================
kf = 100;
int_m = cumsum(m_t)/Fs;
s_fm = Ac*cos(2*pi*Fc*t + 2*pi*kf*int_m);

figure;
subplot(2,1,1); plot(t,s_fm); title('FM Signal'); grid on;

Y = abs(fftshift(fft(s_fm)))/L;
subplot(2,1,2); plot(f,Y); title('FM Spectrum'); xlim([-1500 1500]); grid on;

%% =========================
% PART 7: PM
% =========================
kp = pi;
s_pm = Ac*cos(2*pi*Fc*t + kp*m_t);

figure;
subplot(2,1,1); plot(t,s_pm); title('PM Signal'); grid on;

Y = abs(fftshift(fft(s_pm)))/L;
subplot(2,1,2); plot(f,Y); title('PM Spectrum'); xlim([-1500 1500]); grid on;

%% =========================
% PART 8: NOISE CHANNEL
% =========================
SNR = 8;

r_am  = awgn(s_am,SNR,'measured');
r_dsb = awgn(s_dsb,SNR,'measured');
r_ssb = awgn(s_ssb,SNR,'measured');
r_vsb = awgn(s_vsb,SNR,'measured');
r_fm  = awgn(s_fm,SNR,'measured');
r_pm  = awgn(s_pm,SNR,'measured');

%% =========================
% PART 9: DEMODULATION
% =========================

% AM (Envelope)
m_rec_am = abs(r_am);
m_rec_am = filtfilt(b,a,m_rec_am);
m_rec_am = m_rec_am - mean(m_rec_am);

% DSB-SC
m_rec_dsb = r_dsb .* cos(2*pi*Fc*t);
m_rec_dsb = filtfilt(b,a,m_rec_dsb) * 2;

% SSB
m_rec_ssb = r_ssb .* cos(2*pi*Fc*t);
m_rec_ssb = filtfilt(b,a,m_rec_ssb) * 2;

% VSB
m_rec_vsb = r_vsb .* cos(2*pi*Fc*t);
m_rec_vsb = filtfilt(b,a,m_rec_vsb) * 2;

% FM
z_fm = hilbert(r_fm);
phase = unwrap(angle(z_fm));
freq = diff(phase)*Fs/(2*pi);
freq = [freq freq(end)];
m_rec_fm = filtfilt(b,a,(freq - Fc)/kf);

% PM
z_pm = hilbert(r_pm);
phase = unwrap(angle(z_pm));
m_rec_pm = filtfilt(b,a,(phase - 2*pi*Fc*t)/kp);

%% =========================
% PART 10: NORMALIZATION
% =========================
m_ref = m_t / max(abs(m_t));

m_rec_am  = m_rec_am  / max(abs(m_rec_am));
m_rec_dsb = m_rec_dsb / max(abs(m_rec_dsb));
m_rec_ssb = m_rec_ssb / max(abs(m_rec_ssb));
m_rec_vsb = m_rec_vsb / max(abs(m_rec_vsb));
m_rec_fm  = m_rec_fm  / max(abs(m_rec_fm));
m_rec_pm  = m_rec_pm  / max(abs(m_rec_pm));

%% =========================
% PART 11: PLOTS (COMPARISON)
% =========================
figure;

subplot(3,2,1);
plot(t,m_ref,'k',t,m_rec_am,'r--'); title('AM'); grid on;

subplot(3,2,2);
plot(t,m_ref,'k',t,m_rec_dsb,'r--'); title('DSB-SC'); grid on;

subplot(3,2,3);
plot(t,m_ref,'k',t,m_rec_ssb,'r--'); title('SSB'); grid on;

subplot(3,2,4);
plot(t,m_ref,'k',t,m_rec_vsb,'r--'); title('VSB'); grid on;

subplot(3,2,5);
plot(t,m_ref,'k',t,m_rec_fm,'r--'); title('FM'); grid on;

subplot(3,2,6);
plot(t,m_ref,'k',t,m_rec_pm,'r--'); title('PM'); grid on;

legend('Original','Recovered');

%% =========================
% PART 12: MSE CALCULATION
% =========================
e_am  = m_ref - m_rec_am;
e_dsb = m_ref - m_rec_dsb;
e_ssb = m_ref - m_rec_ssb;
e_vsb = m_ref - m_rec_vsb;
e_fm  = m_ref - m_rec_fm;
e_pm  = m_ref - m_rec_pm;

figure;
plot(e_am); hold on;
plot(e_dsb);
plot(e_ssb);
plot(e_vsb);
plot(e_fm);
plot(e_pm);
title('Error Signals'); grid on;

mse_values = [
    mean(e_am.^2)
    mean(e_dsb.^2)
    mean(e_ssb.^2)
    mean(e_vsb.^2)
    mean(e_fm.^2)
    mean(e_pm.^2)
];

disp('MSE VALUES:');
disp(mse_values);

%% =========================
% PART 13: MSE vs SNR
% =========================
SNR_vec = 0:2:30;

mse_am  = zeros(1,length(SNR_vec));
mse_dsb = zeros(1,length(SNR_vec));
mse_ssb = zeros(1,length(SNR_vec));
mse_vsb = zeros(1,length(SNR_vec));
mse_fm  = zeros(1,length(SNR_vec));
mse_pm  = zeros(1,length(SNR_vec));

for i = 1:length(SNR_vec)

    r_am  = awgn(s_am,SNR_vec(i),'measured');
    r_dsb = awgn(s_dsb,SNR_vec(i),'measured');
    r_ssb = awgn(s_ssb,SNR_vec(i),'measured');
    r_vsb = awgn(s_vsb,SNR_vec(i),'measured');
    r_fm  = awgn(s_fm,SNR_vec(i),'measured');
    r_pm  = awgn(s_pm,SNR_vec(i),'measured');

    % demod again
    m1 = filtfilt(b,a,abs(r_am));
    m2 = filtfilt(b,a,(r_dsb.*cos(2*pi*Fc*t))*2);
    m3 = filtfilt(b,a,(r_ssb.*cos(2*pi*Fc*t))*2);
    m4 = filtfilt(b,a,(r_vsb.*cos(2*pi*Fc*t))*2);

    z_fm = hilbert(r_fm);
    ph = unwrap(angle(z_fm));
    f_inst = diff(ph)*Fs/(2*pi);
    f_inst = [f_inst f_inst(end)];
    m5 = filtfilt(b,a,(f_inst-Fc)/kf);

    z_pm = hilbert(r_pm);
    ph = unwrap(angle(z_pm));
    m6 = filtfilt(b,a,(ph-2*pi*Fc*t)/kp);

    mse_am(i)  = mean((m_ref - m1).^2);
    mse_dsb(i) = mean((m_ref - m2).^2);
    mse_ssb(i) = mean((m_ref - m3).^2);
    mse_vsb(i) = mean((m_ref - m4).^2);
    mse_fm(i)  = mean((m_ref - m5).^2);
    mse_pm(i)  = mean((m_ref - m6).^2);
end

figure;
semilogy(SNR_vec,mse_am,'r-o'); hold on;
semilogy(SNR_vec,mse_dsb,'b-s');
semilogy(SNR_vec,mse_ssb,'m-^');
semilogy(SNR_vec,mse_vsb,'g-d');
semilogy(SNR_vec,mse_fm,'k-*');
semilogy(SNR_vec,mse_pm,'c-x');


legend('AM','DSB','SSB','VSB','FM','PM');
title('MSE vs SNR');
grid on;
%% =========================
% PART 14: AI TRAINING
% =========================

num_samples = 3000;

X = zeros(num_samples,length(t));
Y = zeros(num_samples,length(t));

for i = 1:num_samples

    Fm_r = 50 + (200-50)*rand;
    m_r = cos(2*pi*Fm_r*t);

    type = randi(6);

    switch type
        case 1, s = (Ac + m_r).*cos(2*pi*Fc*t);
        case 2, s = m_r .* c_t;
        case 3
            m_hat = imag(hilbert(m_r));
            s = m_r.*cos(2*pi*Fc*t) - m_hat.*sin(2*pi*Fc*t);
        case 4
            s = filtfilt(b,a,m_r .* c_t);
        case 5
            int_m = cumsum(m_r)/Fs;
            s = Ac*cos(2*pi*Fc*t + 2*pi*kf*int_m);
        case 6
            s = Ac*cos(2*pi*Fc*t + kp*m_r);
    end

    X(i,:) = awgn(s, rand*20, 'measured');
    Y(i,:) = m_r;
end

%% =========================
% TRAIN NETWORK
% =========================

layers = [
    featureInputLayer(length(t))
    fullyConnectedLayer(128)
    reluLayer
    fullyConnectedLayer(256)
    reluLayer
    fullyConnectedLayer(length(t))
    regressionLayer];

net = trainNetwork(X, Y, layers, ...
    trainingOptions('adam', ...
    'MaxEpochs', 25, ...
    'MiniBatchSize', 64, ...
    'Shuffle','every-epoch', ...
    'Verbose', true, ...
    'Plots','training-progress'));

%% =========================
% SAVE MODEL 
% =========================

save('net.mat','net');
%% =========================
% PART 14: LOAD AI MODEL
% =========================
load net.mat   % contains trained neural network "net"
%% =========================
% PART 15: AI vs CONVENTIONAL (ALL MODELS)
% =========================

SNR_vec_final = 0:5:30;
mod_names = {'AM','DSB-SC','SSB','VSB','FM','PM'};

mse_ai_all = zeros(6,length(SNR_vec_final));
mse_conv_all = zeros(6,length(SNR_vec_final));

for mod_type = 1:6

    for i = 1:length(SNR_vec_final)

        m_f = cos(2*pi*120*t);

        % =========================
        % MODULATION
        % =========================
        switch mod_type
            case 1
                s_f = (Ac + m_f).*cos(2*pi*Fc*t);

            case 2
                s_f = m_f .* c_t;

            case 3
                m_hat = imag(hilbert(m_f));
                s_f = m_f.*cos(2*pi*Fc*t) - m_hat.*sin(2*pi*Fc*t);

            case 4
                s_f = filtfilt(b,a,m_f .* c_t);

            case 5
                int_m = cumsum(m_f)/Fs;
                s_f = Ac*cos(2*pi*Fc*t + 2*pi*kf*int_m);

            case 6
                s_f = Ac*cos(2*pi*Fc*t + kp*m_f);
        end

        % =========================
        % CHANNEL adding noise
        % =========================
        r_f = awgn(s_f, SNR_vec_final(i), 'measured');

        % =========================
        % AI DEMOD
        % =========================
        m_ai = predict(net, r_f);

        % =========================
        % CONVENTIONAL DEMOD
        % =========================
        switch mod_type
            case 1
                m_conv = filtfilt(b,a,abs(r_f));

            case 2
                m_conv = filtfilt(b,a,(r_f.*cos(2*pi*Fc*t))*2);

            case 3
                m_conv = filtfilt(b,a,(r_f.*cos(2*pi*Fc*t))*2);

            case 4
                m_conv = filtfilt(b,a,(r_f.*cos(2*pi*Fc*t))*2);

            case 5
                z_fm = hilbert(r_f);
                ph = unwrap(angle(z_fm));
                f_inst = diff(ph)*Fs/(2*pi);
                f_inst = [f_inst f_inst(end)];
                m_conv = filtfilt(b,a,(f_inst-Fc)/kf);

            case 6
                z_fm = hilbert(r_f);
                ph = unwrap(angle(z_fm));
                m_conv = filtfilt(b,a,(ph-2*pi*Fc*t)/kp);
        end

        % =========================
        % NORMALIZATION
        % =========================
        m_f = m_f / max(abs(m_f));
        m_ai = m_ai / max(abs(m_ai));
        m_conv = m_conv / max(abs(m_conv));

        % =========================
        % MSE
        % =========================
        mse_ai_all(mod_type,i) = mean((m_f - m_ai).^2);
        mse_conv_all(mod_type,i) = mean((m_f - m_conv).^2);

    end
end
%% =========================
% PART 16: AI vs CONVENTIONAL PLOTS
% =========================

figure('Name','AI vs Conventional (ALL MODES)');

for mod_type = 1:6

    subplot(3,2,mod_type);

    semilogy(SNR_vec_final, mse_conv_all(mod_type,:), 'r-o','LineWidth',1.2);
    hold on;
    semilogy(SNR_vec_final, mse_ai_all(mod_type,:), 'b-s','LineWidth',1.2);

    title(mod_names{mod_type});
    xlabel('SNR (dB)');
    ylabel('MSE');
    grid on;

    if mod_type == 1
        legend('Conventional','AI');
    end
end

