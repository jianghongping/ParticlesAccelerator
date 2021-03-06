function  [emittance, err] = getEmittance( x, px, py, pz, gamma )
xMean = mean(x);
pxMean = mean(px);
emittance = 4*sqrt(mean((x-xMean).^2)*mean(((px-pxMean)./gamma).^2) ...
                            - mean(((x-xMean).*(px-pxMean)./gamma)).^2);
err = 100*abs(mean(1- ((px.^2+py.^2+pz.^2)/((gamma.^2)-1))));
end

