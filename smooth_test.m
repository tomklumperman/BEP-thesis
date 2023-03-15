function [smooth,smooth_x,smooth_y] = smooth_test(array,array_x,array_y)
% function to get a filtered version as output of an input array with coordinates
more = false;
outlier = [];
diff_disp = diff(array);
for i=1:length(diff_disp)
    if more == true
        if abs(diff_disp(i)) < 3    % (determine threshold)
            outlier = [outlier, i+1];
        else                        % difference higher than threshold while next to outlier
            more = false;           % not an outlier
        end
    else                            % more = false
        if abs(diff_disp(i)) > 12           % if difference is bigger than threshold (determine threshold)
            outlier = [outlier, i+1];
            more = true;            % outlier added, next iteration lies next to outlier             
        end
    end
end

more = false;
outliers = [];
diff_disp = diff(array);
for i=1:length(diff_disp)
    if more == true
        if abs(diff_disp(i)) < 8    % (determine threshold)
            outliers = [outliers, i+1];
        else                        % difference higher than threshold while next to outlier
            more = false;           % not an outlier
        end
    else                            % more = false
        if abs(diff_disp(i)) > 3           % if difference is bigger than threshold (determine threshold)
            outliers = [outliers, i+1];
            more = true;            % outlier added, next iteration lies next to outlier             
        end
    end
end

%detected outliers will be removed here
prev = -1;
count = 1;                  % count for maximum outliers next to each other
for i = outlier             % loop over all outlier values
    if i == prev + 1  % more 'outliers' next to each other
        count = count + 1;
        if count > 8        % change count for less or more outliers next to each other
            %! do nothing
        else
            array(i) = NaN; 
            array_x(i) = NaN;
            array_y(i) = NaN;
        end
    else
        array(i) = NaN; 
        array_x(i) = NaN;
        array_y(i) = NaN;
        count = 1;          % restore count
    end

    prev = i;               % set previous value
end
%detected outliers will be removed here
prev = -1;
count = 1;                  % count for maximum outliers next to each other
for i = outliers             % loop over all outlier values
    if i == prev + 1  % more 'outliers' next to each other
        count = count + 1;
        if count > 8        % change count for less or more outliers next to each other
            %! do nothing
        else
            array(i) = NaN; 
            array_x(i) = NaN;
            array_y(i) = NaN; 
        end
    else
        array(i) = NaN; 
        array_x(i) = NaN;
        array_y(i) = NaN;
        count = 1;          % restore count
    end

    prev = i;               % set previous value
end

%% here the missing values are interpolated
interpolated = fillmissing(array, 'pchip');
interpolated_x = fillmissing(array_x, 'pchip');
interpolated_y = fillmissing(array_y, 'pchip');

smooth = smoothdata(interpolated, 'movmean', 2);
smooth_x = smoothdata(interpolated_x, 'movmean', 2);
smooth_y = smoothdata(interpolated_y, 'movmean', 2);

%% also check moving average if there is still a mistake
% input: array = the coordinate array, k = length of the moving average window, 
% n = maximum difference from the mean 
array_nan = smooth;
array_nanx = smooth_x;
array_nany = smooth_y;
m_avg = movmean(array,5,"omitnan");                  % length of moving average window (k)
for i = 4:length(m_avg)                   % start from round(k/2)+1
    if isnan(m_avg(i-3))                    % take the moving average from before index i
        m_avg(i-3) = last_avg;
    else
        last_avg = m_avg(i-3);
    end

    if abs(m_avg(i-3)-array_nan(i))>0.5     % i-round(k/2) for k = moving average length
        array_nan(i) = NaN;
        array_nanx(i) = NaN;
        array_nany(i) = NaN;
    end
end

smooth = fillmissing(array_nan, 'pchip');
smooth_x = fillmissing(array_nanx, 'pchip');
smooth_y = fillmissing(array_nany, 'pchip');
end