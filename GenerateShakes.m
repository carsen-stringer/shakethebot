vr = VideoReader('tanks.mp4');
nFrames = floor(vr.Duration*vr.FrameRate);

rng(1);
txy = 15*randn(nFrames,2);
sigx = 1;
gaus = exp(-([-4:4]).^2/(2*sigx^2))/sqrt(2*pi*sigx^2);
tsm = filter(gaus',1,txy);
tsm = round(tsm);
%% translate each frame in x-y
newMov = 75*ones(vr.Height,vr.Width,3,nFrames,'uint8');
nX = [vr.Height vr.Width];

clear indx cindx;
for j = 1:nFrames
  cFrame = readFrame(vr);
  for k = 1:2
    tx        = tsm(j,k);
    indx{k}   = [max(1,tx+1):min(nX(k),nX(k)+tx)];
    cindx{k}  = [max(1,-1*tx+1):min(nX(k),nX(k)-tx)];
  end
  newMov(indx{1},indx{2},:,j) = cFrame(cindx{1},cindx{2},:);
end

%% save movie
vn = VideoWriter('tanks2.avi');
vn.FrameRate = vr.FrameRate;
open(vn);
writeVideo(vn,newMov);
close(vn);