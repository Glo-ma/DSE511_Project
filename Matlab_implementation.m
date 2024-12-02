% Load data
df = readtable('DSS.csv', 'VariableNamingRule', 'preserve');

% Display column names and summary
disp('Column Names:');
disp(df.Properties.VariableNames);

disp('Data Summary:');
disp(summary(df));

% Check for missing values
disp('Missing Values Per Column:');
disp(sum(ismissing(df)));

% Set plot style
set(groot, 'defaultAxesFontSize', 10, 'defaultAxesFontWeight', 'bold');

%% Distributions
figure;

% Age Distribution
subplot(3, 2, 1);
histogram(df.('Age'), 'FaceColor', 'blue', 'EdgeColor', 'black');
title('Age Distribution');
xlabel('Age');
ylabel('Frequency');

% Academic Pressure Distribution
subplot(3, 2, 2);
histogram(df.('Academic Pressure'), 'FaceColor', 'green', 'EdgeColor', 'black');
title('Academic Pressure Distribution');
xlabel('Academic Pressure');
ylabel('Frequency');

% Study Satisfaction Distribution
subplot(3, 2, 3);
histogram(df.('Study Satisfaction'), 'FaceColor', '#FFA500', 'EdgeColor', 'black');
title('Study Satisfaction Distribution');
xlabel('Study Satisfaction');
ylabel('Frequency');

% Study Hours Distribution
subplot(3, 2, 4);
histogram(df.('Study Hours'), 'FaceColor', 'red', 'EdgeColor', 'black');
title('Study Hours Distribution');
xlabel('Study Hours');
ylabel('Frequency');

% Financial Stress Distribution
subplot(3, 2, 5);
histogram(df.('Financial Stress'), 'FaceColor', '#800080', 'EdgeColor', 'black');
title('Financial Stress Distribution');
xlabel('Financial Stress');
ylabel('Frequency');

sgtitle('Distributions of Variables');

%% Ensure 'Depression' column is categorical
df.('Depression') = categorical(df.('Depression'));

% Ensure 'Depression' column is categorical
if ~iscategorical(df.('Depression'))
    df.('Depression') = categorical(df.('Depression'));
end

% Handle missing values in 'Depression' column
if any(ismissing(df.('Depression')))
    warning('Missing values found in Depression column. Filling with "Unknown".');
    df.('Depression') = fillmissing(df.('Depression'), 'constant', 'Unknown');
end

% Group counts for the 'Depression' column
[depressionCategories, depressionCounts] = groupcounts(df.('Depression'));

% Use categorical labels directly
figure;
pie(depressionCounts, depressionCategories); % Use categorical labels for pie chart
title('Depression Prevalence');


%% Depression by Gender
figure;
genderDepression = groupsummary(df, {'Gender', 'Depression'}, 'IncludeEmptyGroups', true);
stackedData = unstack(genderDepression, 'GroupCount', 'Depression');
bar(categorical(stackedData.Gender), table2array(stackedData(:, 2:end)), 'stacked');
legend(stackedData.Properties.VariableNames(2:end), 'Location', 'Best');
title('Depression Status by Gender');
xlabel('Gender');
ylabel('Count');

%% Depression by Study Satisfaction
figure;
studySatisfactionDepression = groupsummary(df, {'Study Satisfaction', 'Depression'}, 'IncludeEmptyGroups', true);
swarmchart(categorical(studySatisfactionDepression.('Study Satisfaction')), ...
    studySatisfactionDepression.GroupCount, [], 'filled');
title('Study Satisfaction and Depression');
xlabel('Study Satisfaction');
ylabel('Count');

%% Sleep Duration vs Depression
figure;
sleepDurationDepression = groupsummary(df, {'Sleep Duration', 'Depression'}, 'IncludeEmptyGroups', true);
barData = unstack(sleepDurationDepression, 'GroupCount', 'Depression');
bar(categorical(barData.('Sleep Duration')), table2array(barData(:, 2:end)), 'stacked');
legend(barData.Properties.VariableNames(2:end), 'Location', 'Best');
title('Sleep Duration vs Depression');
xlabel('Sleep Duration');
ylabel('Count');

%% Dietary Habits vs Depression
figure;
dietaryDepression = groupsummary(df, {'Dietary Habits', 'Depression'}, 'IncludeEmptyGroups', true);
swarmchart(categorical(dietaryDepression.('Dietary Habits')), ...
    dietaryDepression.GroupCount, [], 'filled');
title('Dietary Habits and Depression');
xlabel('Dietary Habits');
ylabel('Count');

%% Boxplots for Numeric Variables
figure;

% Academic Pressure vs Depression
subplot(3, 1, 1);
boxchart(df.('Depression'), df.('Academic Pressure'), 'BoxFaceColor', 'cyan');
title('Academic Pressure vs Depression');
xlabel('Depression');
ylabel('Academic Pressure');

% Study Satisfaction vs Depression
subplot(3, 1, 2);
boxchart(df.('Depression'), df.('Study Satisfaction'), 'BoxFaceColor', 'yellow');
title('Study Satisfaction vs Depression');
xlabel('Depression');
ylabel('Study Satisfaction');

% Financial Stress vs Depression
subplot(3, 1, 3);
boxchart(df.('Depression'), df.('Financial Stress'), 'BoxFaceColor', 'magenta');
title('Financial Stress vs Depression');
xlabel('Depression');
ylabel('Financial Stress');

df.Properties.VariableNames = matlab.lang.makeValidName(df.Properties.VariableNames);

%% Comparison of Categorical Features with Depression
 
categorical_features = {'Gender','FamilyHistoryOfMentalIllness', 'HaveYouEverHadSuicidalThoughts_'};
target_feature = 'Depression';

% Ensure target feature is categorical
if ~iscategorical(df.(target_feature))
    df.(target_feature) = categorical(df.(target_feature));
end

% Handle missing values in the target feature
if any(ismissing(df.(target_feature)))
    warning(['Missing values found in ', target_feature, '. Filling with "Unknown".']);
    df.(target_feature) = fillmissing(df.(target_feature), 'constant', 'Unknown');
end

% Process each categorical feature
for i = 1:length(categorical_features)
    current_feature = categorical_features{i};

    % Ensure current feature is categorical
    if ~iscategorical(df.(current_feature))
        df.(current_feature) = categorical(df.(current_feature));
    end

    % Handle missing values in the current feature
    if any(ismissing(df.(current_feature)))
        warning(['Missing values found in ', current_feature, '. Filling with "Unknown".']);
        df.(current_feature) = fillmissing(df.(current_feature), 'constant', 'Unknown');
    end

    % Use groupsummary to summarize data
    try
        featureDepression = groupsummary(df, {current_feature, target_feature}, 'IncludeEmptyGroups', true);
    catch ME
        disp(['Error processing feature: ', current_feature]);
        rethrow(ME);
    end

    % Visualize the summary using a stacked bar chart
    figure;
    featureCounts = unstack(featureDepression, 'GroupCount', target_feature);

    % Use labels from the current feature and target feature
    bar(categorical(featureCounts.(current_feature)), table2array(featureCounts(:, 2:end)), 'stacked');
    legend(featureCounts.Properties.VariableNames(2:end), 'Location', 'Best');
    title(['Comparison of ', current_feature, ' with ', target_feature]);
    xlabel(current_feature);
    ylabel('Count');
end

figure;
for i = 1:length(categorical_features)
    subplot(length(categorical_features), 1, i);
    featureDepression = groupsummary(df, {categorical_features{i}, 'Depression'}, 'IncludeEmptyGroups', true);
    barData = unstack(featureDepression, 'GroupCount', 'Depression');
    bar(categorical(barData.(categorical_features{i})), table2array(barData(:, 2:end)), 'stacked');
    legend(barData.Properties.VariableNames(2:end), 'Location', 'Best');
    title(['Comparison of ' categorical_features{i} ' with Depression']);
    xlabel(categorical_features{i});
    ylabel('Count');
end

%% Correlation Matrix
% Select numerical columns
numerical_columns = varfun(@isnumeric, df, 'OutputFormat', 'uniform');
numerical_df = df(:, numerical_columns);

% Convert to array
data_matrix = table2array(numerical_df);

% Handle missing values (if any)
data_matrix = rmmissing(data_matrix);

% Compute correlation matrix manually
n = size(data_matrix, 2); % Number of numerical columns
correlation_matrix = zeros(n, n);

for i = 1:n
    for j = 1:n
        x = data_matrix(:, i);
        y = data_matrix(:, j);
        cov_xy = cov(x, y); % Compute covariance matrix
        correlation_matrix(i, j) = cov_xy(1, 2) / (std(x) * std(y)); % Extract covariance value and compute correlation
    end
end

% Display the correlation matrix
disp('Correlation Matrix:');
disp(correlation_matrix);

% Visualize the correlation matrix
figure;
heatmap(numerical_df.Properties.VariableNames, numerical_df.Properties.VariableNames, correlation_matrix, ...
    'Colormap', parula, 'ColorLimits', [-1, 1]);
title('Correlation Matrix Heatmap');

