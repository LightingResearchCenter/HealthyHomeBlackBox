close all
clear
clc

lightReadingPath = ['testFiles',filesep,'lightReading.csv'];
lightReadingFid  = fopen(lightReadingPath,'r');
lightReading     = LRCread_lightReading(lightReadingFid);

activityReadingPath = ['testFiles',filesep,'activityReading.csv'];
activityReadingFid  = fopen(activityReadingPath,'r');
activityReading     = LRCread_activityReading(activityReadingFid);

pacemakerPath = ['testFiles',filesep,'pacemaker.csv'];
pacemakerFid  = fopen(pacemakerPath,'r');
pacemaker     = LRCread_pacemaker(pacemakerFid);
