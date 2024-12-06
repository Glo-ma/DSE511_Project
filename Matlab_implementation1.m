% Load data
df = readtable('DSS_preprocessed.csv', 'VariableNamingRule', 'preserve');

% Display column names and summary
disp('Column Names:');
disp(df.Properties.VariableNames);

% Clean up column names to valid MATLAB identifiers
df.Properties.VariableNames = matlab.lang.makeValidName(df.Properties.VariableNames);

% Define X as the feature matrix and y as the target variable
X = df{:, {'Age','Gender','SleepDuration', 'AcademicPressure', 'DietaryHabits', 'StudySatisfaction', 'StudyHours', 'FinancialStress','FamilyHistoryOfMentalIllness','HaveYouEverHadSuicidalThoughts_', }};  % Adjust according to your feature columns
y = df{:, 'Depression'};  % Assuming 'Depression' is your target column

% Normalize numerical features using z-score
X_mean = mean(X);       % Mean of each feature
X_std = std(X);         % Standard deviation of each feature
X = (X - X_mean) ./ X_std;  % Z-score normalization

% Train a Logistic Regression model using fitglm
mdl = fitglm(X, y, 'Distribution', 'binomial', 'Link', 'logit');  % Logistic regression (binary classification)

% Make predictions on the input data
predictions = predict(mdl, X);  % Predicted probabilities for class '1'

% Convert predictions to binary labels (0 or 1)
predictions_binary = predictions >= 0.5;  % Set threshold for binary classification

% Ensure binary labels are properly defined
y = categorical(y, [0, 1], {'0', '1'});
predictions_binary = categorical(predictions_binary, [0, 1], {'0', '1'});

% Calculate Logistic Regression accuracy
lr_accuracy = sum(predictions_binary == y) / numel(y) * 100;  % Calculate percentage accuracy
disp(['Logistic Regression Accuracy: ', num2str(lr_accuracy), '%']);

% Generate confusion matrix
conf_matrix = confusionmat(y, predictions_binary);
disp('Confusion Matrix:');
disp(conf_matrix);

% Check for valid confusion matrix values
if sum(conf_matrix(:)) == 0
    disp('Confusion matrix is empty. Check the input data and predictions.');
else
    % Classification Report (Precision, Recall, F1-Score)
    true_positives = conf_matrix(2, 2);
    false_positives = conf_matrix(1, 2);
    false_negatives = conf_matrix(2, 1);
    true_negatives = conf_matrix(1, 1);

    % Handle division by zero
    if true_positives + false_positives == 0
        precision = NaN;
    else
        precision = true_positives / (true_positives + false_positives);
    end

    if true_positives + false_negatives == 0
        recall = NaN;
    else
        recall = true_positives / (true_positives + false_negatives);
    end

    if isnan(precision) || isnan(recall) || (precision + recall == 0)
        f1_score = NaN;
    else
        f1_score = 2 * (precision * recall) / (precision + recall);
    end

    % Display results
    disp('Classification Report:');
    disp(['Precision: ', num2str(precision)]);
    disp(['Recall: ', num2str(recall)]);
    disp(['F1-Score: ', num2str(f1_score)]);
end

% Plot Confusion Matrix
figure;
confusionchart(conf_matrix);
title('Confusion Matrix for Logistic Regression');

% ROC Curve and AUC
[Xroc, Yroc, ~, AUC] = perfcurve(double(y == '1'), predictions, 1);  % Using probabilities for class '1'

% Plot ROC curve
figure;
plot(Xroc, Yroc, '-o');
xlabel('False Positive Rate');
ylabel('True Positive Rate');
title(['ROC Curve for Logistic Regression - AUC: ', num2str(AUC)]);


% Random Forest Classifier
disp('Running Random Forest Classifier...');

% Ensure y is properly defined as categorical
if ~iscategorical(y)
    y = categorical(y);  % Convert target variable to categorical
end

% Check for categorical predictors in X
categorical_vars = {'Gender', 'FamilyHistoryOfMentalIllness', 'HaveYouEverHadSuicidalThoughts_'};
categorical_indices = find(ismember(df.Properties.VariableNames, categorical_vars));

% Ensure X is numeric and process categorical predictors
if ~isempty(categorical_indices)
    for i = categorical_indices
        X(:, i) = grp2idx(categorical(df{:, i}));  % Convert to numeric indices
    end
end

% Define the number of trees in the forest
num_trees = 100;

% Train the Random Forest model
rf_model = TreeBagger(num_trees, X, y, ...
    'Method', 'classification', ...
    'CategoricalPredictors', categorical_indices, ...
    'OOBPrediction', 'on');

% Make predictions on the input data
[rf_predictions, rf_scores] = predict(rf_model, X);

% Convert predictions from cell array to categorical
rf_predictions = categorical(rf_predictions, categories(y));  % Ensure categories match y

% Calculate Random Forest accuracy
rf_accuracy = sum(rf_predictions == y) / numel(y) * 100;
disp(['Random Forest Accuracy: ', num2str(rf_accuracy), '%']);

% Generate confusion matrix
conf_matrix_rf = confusionmat(y, rf_predictions);
disp('Confusion Matrix for Random Forest:');
disp(conf_matrix_rf);

% Plot Confusion Matrix
figure;
confusionchart(conf_matrix_rf);
title('Confusion Matrix for Random Forest');

% ROC Curve and AUC
[rf_Xroc, rf_Yroc, ~, rf_AUC] = perfcurve(double(y == '1'), rf_scores(:, 2), 1);

% Plot ROC curve
figure;
plot(rf_Xroc, rf_Yroc, '-o');
xlabel('False Positive Rate');
ylabel('True Positive Rate');
title(['ROC Curve for Random Forest - AUC: ', num2str(rf_AUC)]);



% Define the feature names
feature_names = {'Age', 'Gender', 'SleepDuration', 'AcademicPressure', 'DietaryHabits', ...
                 'StudySatisfaction', 'StudyHours', 'FinancialStress', 'FamilyHistoryOfMentalIllness', 'HaveYouEverHadSuicidalThoughts_'};

% Train Random Forest model with OOB importance enabled
num_trees = 100;  % Number of trees in the forest
rf_model = TreeBagger(num_trees, X, y, 'Method', 'classification', 'OOBPredictorImportance', 'on', 'PredictorNames', feature_names);

% Get and display feature importance from OOB data
importance = rf_model.OOBPermutedVarDeltaError;  % Out-of-Bag Permuted Variable Importance

% Display feature importance
disp('Feature Importance:');
for i = 1:length(importance)
    disp([rf_model.PredictorNames{i}, ': ', num2str(importance(i))]);
end

% Plot Feature Importance
figure;
bar(importance);
title('Random Forest - Feature Importance');
xlabel('Features');
ylabel('Importance');
set(gca, 'XTickLabel', rf_model.PredictorNames, 'XTick', 1:length(rf_model.PredictorNames));
xtickangle(45);


% Save Logistic Regression model parameters
model_params.coefficients = mdl.Coefficients.Estimate; % Coefficients and intercept
model_params.mean = X_mean; % Mean for normalization
model_params.std = X_std; % Standard deviation for normalization

% Save to a .mat file
save('logistic_model.mat', 'model_params');
