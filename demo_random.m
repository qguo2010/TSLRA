clc
clear

addpath('LRA');
addpath('images');
addpath('metric');

x = double(imread('Barbara256.tif'));
ratio = 0.4;
rand('seed',0);
mask = double(rand(size(x)) > (1-ratio));

par.win = 9;
par.nblk = 70;
par.K = 50;     % 40% observed pixels
% par.K = 60;   % 30% observed pixels
% par.K = 70;   % 20% observed pixels
% par.K = 120;  % 10% observed pixels

%% Stage 1

par.mask = mask;
par.x_init = x.*mask;
par.step = min(3, par.win-1);
par.ori_im = x;
par.ratio = 1.06;
 
x1 = inpaint_LRA_stage1( par );

x1_temp = x1(:,:,end);
PSNR = csnr( x, x1_temp, 0, 0 );
fprintf( 'PSNR = %f \n', PSNR);


%% Stage 2

xt = x-x1_temp;

par2.win  = 7;
par2.nblk = 60;
par2.K = 14;
par2.mask = mask;
par2.x_init = xt.*mask;
par2.step = min(3, par2.win-1);
par2.x1 = x1_temp;
par2.x = x;
par2.ratio = 1.02;

x2 = inpaint_LRA_stage2( par2 );
x2_temp =  x2(:,:,end);
x_final = x1_temp + x2_temp;

PSNR = csnr( x, x_final, 0, 0 );
fprintf( 'PSNR = %f \n', PSNR);


%% Figures

figure;
imshow(x/255);
figure
imshow(x.*mask/255)
figure;
imshow(x_final/255);






