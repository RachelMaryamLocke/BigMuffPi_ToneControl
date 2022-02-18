%Big Muff Pi Tone Control 

close all
clc
 
Fs = 44100; %sampling frequency
input = [1;zeros(1000,1)]; %impulse signal
alphas = (0:0.1:1);

for potValue = alphas %sweeps through knob values of the potentiometer
    
            output = bigMuffToneControl(input, potValue);
            B = output; %B = toneControl() output
            [X, w] = freqz(B); %frequency response (X), angular frequency (w), for the output of tone Control
            F = w / pi * Fs / 2; %creates a frequency vector
            fontsize = 20;

            xrange = [20 100000];
            yrange = [-20 0.2];
            subplot(2,1,1)
            semilogx(F, 20*log10(abs(X)),'linewidth', 1.5); %plots the magnitude response of frequency response X
            grid on
%             hold on 
            title(sprintf('Pot Value: %f', potValue)) %formats the title to show changing values for the potentiomenter.
            g = gca(); %sets g to current axis, subplot(2,1,1)
            g.Title.FontSize = fontsize; %sets title fontsize
            g.FontSize = fontsize; %sets all other fontsizes
            xlabel('Frequency[Hz] (Magnitude Response)')
            ylabel('Gain[dB]')
            xlim(xrange); %sets limits for xaxis
            ylim(yrange);

            subplot(2,1,2)
            semilogx(F, angle(X),'linewidth', 1.5); %plots the phase response of frequency response X
            grid on
            g = gca();
            g.FontSize = fontsize;
            xlabel('Frequency[Hz] (Phase Response)')
            ylabel('Phase [Deg]')
            xlim(xrange);

            print('-dpng', sprintf('output_for_potValue_%f.png', potValue));
end

function output = bigMuffToneControl(input,potValue)

if potValue < 0 || potValue > 1
  
msg = 'expected value between 0 and 1';
error(msg)

end 

a = round(potValue, 1);

if a == 0.1 
a = 0.145;
end

if a == 0.2
a = 0.23;
end

if a == 0.3
a = 0.29;
end

if a == 0.4
a = 0.345;
end

if a == 0.5
a = 0.4;
end

if a == 0.6 
a = 0.475;
end

if a == 0.7
a = 0.55;
end

if a == 0.8
a = 0.625;
end

if a == 0.9
a = 0.72;
end 

if a == 1 
a = 0.8222;
end

th = 0.0000765; %high pass time constant
tl = 0.00029; %low pass time constant
Fs = 44100;
T = 1/Fs;
Ts = T^2;
tp = th * tl;

zrs = [ ((6.6 * tp * a) + (2 * T * th) + (Ts) - (Ts * a)), ((2 * Ts) - (2 * Ts * a) - (13.2 * tp * a)), ((6.6 * tp * a) - (2 * T * th) + (Ts) - (Ts * a)) ];
pls = [ ((Ts) + ((th + tl) * 2 * T) + (4 * tp)), (((Ts) * 2) - (8 * tp)), ((4 * tp) - ((th + tl) * 2 * T) + (Ts)) ];

output = filter(zrs, pls, input);

gainShift = 10^(-2.65/20); %converts a dB shift of -2.65 to linear gain
 
output = output *  gainShift; 

end