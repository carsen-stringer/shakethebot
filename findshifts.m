function xyshift = findshifts(xv)

centerpt = ceil(size(xv)/2);
% find max corr
[~,ix]    = max(xv(:));
[ix,iy]   = ind2sub(size(xv),ix);
xyshift   = [ix iy] - centerpt;