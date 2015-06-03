function phaseDiff = LRCphaseDifference(xcn,xn,xcAcrophase,xAcrophase)
%LRCPHASEDIFFERENCE Summary of this function goes here
%   Detailed explanation goes here

pacemakerPhase = atan2(xcn,xn)*43200/pi;
pacemakerPhase = mod(pacemakerPhase,86400);

activityPhase = atan2(xcAcrophase,xAcrophase)*43200/pi;
activityPhase = mod(activityPhase,86400);

phaseDiff = pacemakerPhase - activityPhase;
if (phaseDiff > 43200)
    phaseDiff = 43200 - phaseDiff;
elseif (phaseDiff < -43200)
    phaseDiff = -43200 - phaseDiff;
end

end

