close all 
clc
%%

% Tests the analog transfer function 

th = 0.0000765; %high pass time constant
tl = 0.00029; %low pass time constant

dbs = 10^(-15/20);
alphas = [0 0.145 0.23 0.3 0.4 0.5 0.6 0.7 1-dbs];
clf
legs = {};

subplot(211)
for a = alphas
    Ba = [th*tl*a*1.65, th, (1-a)];
    Aa = [th*tl, (th+tl), 1];
    F = 0:22049;
    [h, s] = freqs(Ba, Aa, F*2*pi);
    semilogx(F, 20*log10(abs(h)),'LineWidth',1.5)
    hold on
    grid on
    legs{end+1} = sprintf('\\alpha = %.1f', a);
end

title('Analog Frequency Response H(s)')
xlabel('Frequency[Hz]')
ylabel('Amplitude [dB]');
hold off
legend(legs)
xlim([0 100000])
ylim([-17.5 2.7])

%% 

% Tests the digital transfer function 

alphas = [0, 0.145, 0.23, 0.3, 0.4, 0.5, 0.6, 0.7, 1-dbs];
legs = {};

th = 0.0000765; %high pass time constant
tl = 0.00029; %low pass time constant

Fs = 44100;
T = 1/Fs;
Ts = T^2;
tp = th * tl;

subplot(212)
for a = alphas
    Ba = [ ((6.6 * tp * a) + (2 * T * th) + (Ts) - (Ts * a)), ((2 * Ts) - (2 * Ts * a) - (13.2 * tp * a)), ((6.6 * tp * a) - (2 * T * th) + (Ts) - (Ts * a)) ]; 
    Aa = [ ((Ts) + ((th + tl) * 2 * T) + (4 * tp)), (((Ts) * 2) - (8 * tp)), ((4 * tp) - ((th + tl) * 2 * T) + (Ts)) ];
    BA = Ba/Aa;
    [h,f] = freqz(Ba, Aa, Fs/2, Fs);  
    semilogx(f, 20*log10(abs(h)),'linewidth', 1.5)
    hold on
    grid on
    legs{end+1} = sprintf('\\alpha = %.1f', a);
end

title('Digital Frequency Response H(z)')
xlabel('Frequency[Hz]')
ylabel('Amplitude[dB]')
hold off
legend(legs)
xlim([1 100000])
ylim([-17.5 2.7])

%%