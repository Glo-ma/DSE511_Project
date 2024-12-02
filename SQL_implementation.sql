USE dss_sql_fp;
SELECT * FROM dss;
# To get the total number of values in the table
SELECT COUNT(*) AS total_records FROM dss;

# Rename columns with spaces to use underscores
ALTER TABLE dss 
CHANGE `Academic Pressure` Academic_Pressure VARCHAR(255),
CHANGE `Study Satisfaction` Study_Satisfaction VARCHAR(255),
CHANGE `Sleep Duration` Sleep_Duration VARCHAR(255),
CHANGE `Dietary Habits` Dietary_Habits VARCHAR(255),
CHANGE `Have you ever had suicidal thoughts ?` Any_suicidal_thoughts VARCHAR(255),
CHANGE `Family History of Mental Illness` Family_history_of_mental_illness VARCHAR(255);

ALTER TABLE dss 
CHANGE `Study Hours` Study_Hours VARCHAR(255),
CHANGE `Financial Stress` Financial_Stress VARCHAR(255);

# Distribution of Age
SELECT 
    Age, 
    COUNT(*) AS count, 
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dss), 2) AS percentage
FROM dss
GROUP BY Age
ORDER BY Age;

# Distribution of Academic Pressure
SELECT 
    Academic_Pressure, 
    COUNT(*) AS count, 
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dss), 2) AS percentage
FROM dss
GROUP BY Academic_Pressure
ORDER BY Academic_Pressure;

# Distribution of Study Satisfaction
SELECT 
    Study_Satisfaction, 
    COUNT(*) AS count, 
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dss), 2) AS percentage
FROM dss
GROUP BY Study_Satisfaction
ORDER BY Study_Satisfaction;

# Distribution of Study Hours
SELECT 
    Study_Hours, 
    COUNT(*) AS count, 
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dss), 2) AS percentage
FROM dss
GROUP BY Study_Hours
ORDER BY Study_Hours;

# Distribution of Financial Stress
SELECT 
    Financial_Stress, 
    COUNT(*) AS count, 
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dss), 2) AS percentage
FROM dss
GROUP BY Financial_Stress
ORDER BY Financial_Stress;

# Depression Prevalence
SELECT 
    Depression, 
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dss), 2) AS percentage
FROM dss
GROUP BY Depression;

# Distribution table of depression by gender
SELECT 
    Gender, 
    Depression, 
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dss WHERE Gender = dss.Gender), 2) AS percentage
FROM dss
GROUP BY Gender, Depression
ORDER BY Gender, Depression;

# Distri... depression by study sat...
SELECT 
    Study_Satisfaction, 
    Depression, 
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dss WHERE Study_Satisfaction = dss.Study_Satisfaction), 2) AS percentage
FROM dss
GROUP BY Study_Satisfaction, Depression
ORDER BY Study_Satisfaction;

# Distri.. by sleep duration
SELECT 
    Sleep_Duration, 
    Depression, 
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dss WHERE Sleep_Duration = dss.Sleep_Duration), 2) AS percentage
FROM dss
GROUP BY Sleep_Duration, Depression
ORDER BY Sleep_Duration;

# D by study hours
SELECT 
    Study_Hours, 
    Depression, 
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dss WHERE Study_Hours = dss.Study_Hours), 2) AS percentage
FROM dss
GROUP BY Study_Hours, Depression
ORDER BY Study_Hours;

# D by Fin stress
SELECT 
    Financial_Stress, 
    Depression, 
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dss WHERE Financial_Stress = dss.Financial_Stress), 2) AS percentage
FROM dss
GROUP BY Financial_Stress, Depression
ORDER BY Financial_Stress;

# D by Dietary Habits
SELECT 
    Dietary_Habits, 
    Depression, 
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dss WHERE Dietary_Habits = dss.Dietary_Habits), 2) AS percentage
FROM dss
GROUP BY Dietary_Habits, Depression
ORDER BY Dietary_Habits;

# D by suicidal thoughts
SELECT 
    Any_suicidal_thoughts, 
    Depression, 
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dss WHERE Any_suicidal_thoughts = dss.Any_suicidal_thoughts), 2) AS percentage
FROM dss
GROUP BY Any_suicidal_thoughts, Depression
ORDER BY Any_suicidal_thoughts;


# D by family problems
SELECT 
    Family_history_of_mental_illness, 
    Depression, 
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dss WHERE Family_history_of_mental_illness = dss.Family_history_of_mental_illness), 2) AS percentage
FROM dss
GROUP BY Family_history_of_mental_illness, Depression
ORDER BY Family_history_of_mental_illness;

 