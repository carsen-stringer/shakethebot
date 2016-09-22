function ix = findfftshifts(cc)
% find max corr
[~,ix]    = max(cc(:));
[ix,iy]   = ind2sub(size(cc),ix);
ix        = [ix iy];
nA = size(cc);
ixind = ix > nA/2;

ix(ixind) = ix(ixind) - (nA(ixind)+1);
ix(~ixind) = ix(~ixind)-1;