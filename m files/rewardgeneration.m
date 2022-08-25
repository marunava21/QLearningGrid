function[reward]=rewardgeneration()
clc
clear all
load("task1.mat");
M =2^7;
k = log2(M);
snr = 3;
% data = randi([0 M-1],2000,1);
reward = awgn(reward,snr);
end