lightReadingPath = ['testFiles',filesep,'lightReading.csv'];
lightReadingFid = fopen(lightReadingPath);
[timeUTC,timeOffset,red,green,blue,cla,cs] = LRCread_lightReading(lightReadingFid);