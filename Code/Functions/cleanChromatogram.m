function [clean_chromatogram,tmp1,tmp2] = cleanChromatogram(rawchrom,steps)

% Cleans raw chromatograms.
%
% This function takes a 'raw' chromatogram, i.e. one row from the Excel tables produced by MQ, and
% pre-processes it. The pre-processing steps include:
%   1. Impute (fill in) single missing values (nans) by linear interpolation;
%   2. Fill in first and last fractions with a 0 if they're missing;
%   3. Replace values <0.2 with nan;
%   4. If a value is not part of 5 consecutive values, replace it with 0;
%   5. Add 5 zeros to either side of the chromatogram;
%   6. Smooth whole chromatogram with a boxcar filter (moving average).
%   7. Replace nan with zero.
%
% Input:
%   rawchrom: nx1 vector, where n is the number of fractions. Raw chromatogram.
%   steps: Vector specifying the steps to take. E.g. steps=[1 5] would impute single values and add
%          5 zeres to either side of the chromatogram. Default is all steps.
% Output:
%   clean_chromatogram: nx1 vector. Cleaned chromatogram.
%   tmp1: intermediate stage in the cleaning process, outputted for housekeeping.
%   tmp2: intermediate stage in the cleaning process, outputted for housekeeping.
%
% Adapted from Nichollas Scott's Gaus_build_24_1.m.
% Made by Greg Stacey on Nov 25 2015.



%% 0. Initialize

if nargin<1
  error('Input must be a single variable, i.e. one chromatogram.')
end

if nargin<2
  steps=1:6;
end

if sum(ismember(1:6,steps))<1
  disp('cleanChromatograms is not doing any cleaning...')
end

[n1,n2] = size(rawchrom);
if n1~=1 && n2~=1 || (n1==1 && n2==1)
  error('Input must be a 1-dimensional vector, i.e. a single chromatogram.')
end

% transform into row vector if necessary
if n1>n2
  rawchrom = rawchrom';
end

tmpchrom = rawchrom; % dummy variable


%% 1. Replace single missing values with mean of neighbours
if ismember(1,steps)
  tmp = [1 0 1]; % look for a single nan flanked by real values, i.e. [1 0 1]
  tmp2 = strfind(~isnan(tmpchrom),tmp); % find where [1 0 1] occurs in the chromatogram
  for ii = 1:length(tmp2)
    I = tmp2(ii) + 1;
    tmpchrom(I) = mean(tmpchrom([I-1 I+1]));
  end
end


% 2. Fill in first and last fractions
if ismember(2,steps)
  if isnan(tmpchrom(1))
    tmpchrom(1)=0;
  end
  
  if isnan(tmpchrom(end))
    tmpchrom(end)=0;
  end
  tmp1=tmpchrom;
end


% 3. Replace values <0.2 with nan
if ismember(3,steps)
  tmpchrom(tmpchrom<0.2) = nan;
end

% 4. Consecutive numbers, if less then 5 consecutive number removes chromogram and replace with 0.05
if ismember(4,steps)
  Nminconsecutive = 5; % minimum number of consecutive non-nan values
  a = ones(1,Nminconsecutive); % the pattern to look for: [1 1 1 1 1]
  a2 = strfind(~isnan(tmpchrom),a); % find the pattern
  %tmpchrom2 = ones(size(tmpchrom))*0.05; % dummy variable
  tmpchrom2 = zeros(size(tmpchrom)); % dummy variable
  for ii = 1:length(a2)
    I = a2(ii) : a2(ii) + Nminconsecutive-1;
    tmpchrom2(I) = tmpchrom(I);
  end
  tmpchrom = tmpchrom2;
end


% 5. Add 5 zeros to either side of the chromatogram
if ismember(5,steps)
  tmpchrom = [zeros(1,5) tmpchrom zeros(1,5)];
  tmp2=tmpchrom;
end


% 6. Smooth whole chromatogram with a boxcar filter (moving average).
if ismember(6,steps)
  tmpchrom= smooth(tmpchrom,4);
end


% 7. Replace nan with 0.
if ismember(7,steps)
  tmpchrom(isnan(tmpchrom)) = 0;
end


clean_chromatogram = tmpchrom;


