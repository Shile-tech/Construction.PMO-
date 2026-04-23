/*Data validations like row count, check for nulls, check for duplicates and mathematical check of the
  cost_overrun_NGN column to maintain data integrity across the dataset*/


-- Total Row counts
SELECT 'projects'             AS table_name, COUNT(*) AS row_count FROM dbo.projects
UNION ALL
SELECT 'phase_breakdown'      AS table_name, COUNT(*) AS row_count FROM dbo.phase_breakdown
UNION ALL
SELECT 'contractor_scorecard' AS table_name, COUNT(*) AS row_count FROM dbo.contractor_scorecard



-- Check for NULLs
SELECT 
*
FROM dbo.projects
WHERE project_id IS NULL       --This returns all rows with atleast a null in the specified columns
OR    budget_NGN IS NULL
OR    actual_cost_NGN IS NULL
OR    status IS NULL



-- cost_overrun_NGN mathematical check 
SELECT 
    project_id,
    budget_NGN,
    actual_cost_NGN,          -- Returns all rows where the calc_cost_overrun does not match the cost_overrun column                      
    cost_overrun_NGN,
    (actual_cost_NGN - budget_NGN) AS calc_cost_overrun,
    (actual_cost_NGN - budget_NGN) - cost_overrun_NGN AS diff
FROM dbo.projects
WHERE ABS((actual_cost_NGN - budget_NGN) - cost_overrun_NGN) > 0.01




--  Direct duplicate check shows exactly which project_ids are duplicated and how many times
SELECT
    project_id,
    COUNT(*) AS occurrences
FROM dbo.projects
GROUP BY project_id
HAVING COUNT(*) > 1
