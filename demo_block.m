clc
clear

addpath('LRA');
addpath('images');
addpath('metric');

x = double(imread('barb_org.pgm'));   % texture image
% x = double(imread('tile_org.pgm'));   % texture image
% x = double(imread('barb3_org.pgm'));  % non-texture image
% x = double(imread('boat_org.pgm'));   % non-texture image


mask = ones(64);
mask(25:40,25:40) = 0;

%% Stage 1
par.win = 18;
par.nblk = 14;   % texture image
par.K = 280;     % texture image
% par.nblk = 80;   % non-texture image
% par.K = 300;     % non-texture image

par.mask = mask;
par.x_init = x.*mask;
par.step = min(2, par.win-1);
par.ori_im = x;
par.ratio = 1.06;
    
x1 = inpaint_LRA_stage1( par );
x1_temp = x1(:,:,end);

PSNR = csnr( x, x1_temp, 0, 0 );
fprintf( 'PSNR = %f \n', PSNR);


%% Stage 2

xt = x-x1_temp;

par2.win = 13;
par2.nblk = 60;

par2.mask = mask;
par2.K = 14;
par2.x_init = xt.*mask;
par2.step = min(2, par2.win-1);
par2.x1 = x1_temp;
par2.x = x;
par2.ratio = 1.06;

x2 = inpaint_LRA_stage2( par2 );
x2_temp =  x2(:,:,end);
x_final = x1_temp + x2_temp;

PSNR = csnr( x, x_final, 0, 0 );
fprintf( 'PSNR = %f \n', PSNR);

J = find(~par.mask);
PSNR2 = csnr( x(J), x_final(J), 0, 0 );
fprintf( 'PSNR = %f \n', PSNR2);

FSIM = FeatureSIM( uint8(x(25:40,25:40)), uint8(x_final(25:40,25:40)));
fprintf( 'FSIM = %f \n', FSIM);


%% Figures

figure;
imshow(x/255);
figure
imshow(x.*mask/255)
figure;
imshow(x_final/255);

