%% load shaken bot and convert to grayscale
vr      = VideoReader('tanks2.avi');
nFrames = floor(vr.Duration*vr.FrameRate);
mov     = zeros(vr.Height,vr.Width,nFrames,'single');
nX      = [vr.Height vr.Width];

j = 1;
while hasFrame(vr)
  cFrame     = readFrame(vr);
  mov(:,:,j) = mean(single(cFrame),3)/255;
  j = j+1;
end

%% choose two frames with large shift, see if we can detect it
tpt1 = 156;
tpt2 = 157;
movA = mov(:,:,tpt1);
movB = mov(:,:,tpt2);
xygt = tsm(tpt1,:) - tsm(tpt2,:);
fprintf('true shifts x: %d   y: %d\n',xygt);

%%
% compute cross-correlation
tic;
xv = xcorr2(movA,movB);
t_cpu=toc;

% what about on the GPU?
movA = gpuArray(movA);
movB = gpuArray(movB);
tic;
xv = xcorr2(movA,movB);
xv(1);
t_gpu=toc;
xv = gather(xv);
movA = gather(movA);
movB = gather(movB);

fprintf('CPU: %2.2fs\nGPU: %2.2fs \t speedup = %2.2f\n',t_cpu,t_gpu,t_cpu/t_gpu);

%% find shift from cross-correlation
xyshift = findshifts(xv);
fprintf('found shifts x=%d   y=%d',xyshift);
clf
centerpt = ceil(size(xv)/2);
subplot(1,2,1),
imagesc(xv);
title('cross-correlation');
subplot(1,2,2),
plot(xv(centerpt(1),centerpt(2)+[-20:20]),'linewidth',2);
hold all;
plot(xv(centerpt(1)+[-20:20],centerpt(2)),'linewidth',2);
title('x-y profiles at center');
legend('x','y');
axis tight;


%% how do we high-pass filter? let's do it in the frequency domain!
m1      = fftshift(fftn(movA));
m2      = fftshift(fftn(movB));
clf
subplot(2,2,1),
imagesc(abs(m1),[0 5e2])
subplot(2,2,3),
imagesc(movA);

% remove all the high frequencies
highfilt = ones(size(m1),'single');
centerpt = ceil(size(m1)/2);
% zero out all the frequencies in the center!
nf = 80;
highfilt(centerpt(1)+[-1*nf:nf],centerpt(2)+[-1*nf:nf]) = 0;

m1       = m1.*highfilt;
m2       = m2.*highfilt;
subplot(2,2,2),
imagesc(abs(m1),[0 5e2]);
subplot(2,2,4),
fmovA = real(ifftn(fftshift(m1)));
imagesc(fmovA);

%% let's now do the cross-correlation in the fft domain (so it's fast!)
cc      = real(ifftn(m1 .* conj(m2)));
cc0     = fftshift(cc);

clf
nf = 30;
imagesc(cc0(centerpt(1)+[-1*nf:nf],centerpt(2)+[-1*nf:nf]));
xyshift = findfftshifts(cc);
fprintf('found shifts x=%d   y=%d\n',xyshift);


%% whitening in the frequency domain!
m1      = fftn(movA);
m2      = fftn(movB);
eps0    = single(1e-20);
m1      = m1./(abs(m1)+eps0);
m2      = m2./(abs(m2)+eps0);

% cross-correlation in fft domain
cc      = real(ifftn(m1 .* conj(m2)));
cc0     = fftshift(cc);
clf
nf  = 30;
imagesc(cc0(centerpt(1)+[-1*nf:nf],centerpt(2)+[-1*nf:nf]));
xyshift = findfftshifts(cc);
fprintf('found shifts x=%d   y=%d\n',xyshift);

%% we can actually do all the whitening in parallel on all images
%%%% EXERCISE
% figure out how to do the fft in parallel on all of MOV and on the GPU
% compare speed up to cpu with this problem (it should be massive)








