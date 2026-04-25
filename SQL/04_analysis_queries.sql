USE ConstructionPMO_DB;   
      
      -- STAKEHOLDER'S QUESTIONS   (ANALYSIS)


     -- STAKEHOLDER'S QUESTION - Which projects had the highest cost and schedule overruns?

-- ============================================================
-- 1. Top 10 Projects by Cost & Schedule Overrun
-- ============================================================
SELECT TOP 10
    project_id,
    project_name,
    budget_NGN,
    cost_overrun_NGN,
    ROUND((cost_overrun_NGN * 100 / NULLIF(CAST(budget_NGN AS float),0)),2)  AS overrun_perc,
    sched_delay_months,
    status
FROM projects
ORDER BY cost_overrun_NGN DESC,
         sched_delay_months DESC;

   /*QUERY EXPLANATION
This query sort and returns the TOP 10 projects with highest cost or schedule overruns by 
using the ORDER BY command.

    USE CASE -
It can be used to identify and track high risk projects.*/





         -- STAKEHOLDER'S QUESTION - Which project phases are the biggest risk areas?

-- ============================================================
-- 2. Project Phases Ranked by Risk  (Highest Risk First)
-- ============================================================
SELECT 
    phase,
    COUNT(*) AS total_projects,
    SUM(phase_overrun_NGN) AS total_phase_overrun,
    AVG(phase_overrun_pct) AS avg_overrun_perct
FROM dbo.phase_breakdown
GROUP BY phase
ORDER BY avg_overrun_perct DESC;

   /*QUERY EXPLANATION
This query returns each phase of projects and the total cost overrun by phase, by calculating the 
sum and average overrun per phase. 

    USE CASE -
This shows the stakeholders the phases that surpasses budgets and by how much.*/





  -- STAKEHOLDER'S QUESTION - Does contractor selection predict performance?

-- =================================================================================
-- 3. Contractors Ranked by  Performance score (Showing the best contractors first)
-- =================================================================================

WITH contractor  AS 
(
SELECT  
    contractor,
    project_handled                 AS total_project,
    avg_cost_overrun_pct
FROM dbo.contractor_scorecard c
),
 duration  AS 
(
SELECT 
    contractor,
    ROUND(AVG((CAST(sched_delay_months AS FLOAT) * 100 / NULLIF(planned_dur_months,0))),2)    AS avg_dur_overrun_perc
FROM dbo.projects p
GROUP BY contractor
)

SELECT 
    c.contractor,
    total_project,
    avg_cost_overrun_pct,
    avg_dur_overrun_perc,
    CASE
        WHEN ROUND((100 - avg_cost_overrun_pct - avg_dur_overrun_perc),2) < 0 THEN 0
        WHEN ROUND((100 - avg_cost_overrun_pct - avg_dur_overrun_perc),2) > 100 THEN 100
        ELSE ROUND((100 - avg_cost_overrun_pct - avg_dur_overrun_perc),2) 
    END                    AS perfom_score,
    CASE
        WHEN (100 - avg_cost_overrun_pct - avg_dur_overrun_perc) < 35 THEN 'Poor'
        WHEN (100 - avg_cost_overrun_pct - avg_dur_overrun_perc) < 66 THEN 'Average'
        ELSE 'Good'
    END AS score_categ
FROM contractor c
INNER JOIN duration d
ON c.contractor = d.contractor
ORDER BY perfom_score DESC

   /*QUERY EXPLANATION
This query returns each contractors details and a calculated performance score derived from their 
average cost and duration overruns across all projects handled with the help of CTE's.

    USE CASE -
This can be used to grade and evaluate contractor's performances over time in other to improve decision 
makings about contractors.*/





     -- STAKEHOLDER'S QUESTION - What early warning signs indicate a project heading for trouble?

-- ============================================================
-- 4. Ranking Projects on Risk of failure (Stress Indicators)
-- ============================================================

WITH project_summary AS 
(
SELECT 
    project_id,
    project_name,
    contractor,
    budget_NGN,
    cost_overrun_NGN,
    CASE
        WHEN ROUND((CAST(cost_overrun_NGN AS FLOAT) * 100 / NULLIF(budget_NGN,0)),2) < 0 THEN 0
        ELSE ROUND((CAST(cost_overrun_NGN AS FLOAT) * 100 / NULLIF(budget_NGN,0)),2)
    END                 AS perc_cost_overrun,
    planned_dur_months,
    sched_delay_months,
    ROUND((CAST(sched_delay_months AS FLOAT) * 100 / NULLIF(planned_dur_months,0)),2)   AS perc_dur_overrun, 
    perct_completed,
    status
FROM dbo.projects
)

SELECT
    project_id,
    project_name,
    contractor,
    budget_NGN,
    cost_overrun_NGN,
    perc_cost_overrun,
    planned_dur_months,
    sched_delay_months,
    perc_dur_overrun,
    perct_completed,
    status,
    ROUND((perc_cost_overrun + perc_dur_overrun) / 2, 2)    AS risk_score,
    CASE
    --  formally delayed projects are always at least Moderate Risk
    WHEN status = 'Delayed' AND 
         ROUND((perc_cost_overrun + perc_dur_overrun) / 2, 2) >= 50 THEN 'High Risk'
    WHEN status = 'Delayed' THEN 'Moderate Risk'
    -- Score-based classification for Ongoing projects
    WHEN ROUND((perc_cost_overrun + perc_dur_overrun) / 2, 2) < 20  AND perct_completed > 50  THEN 'Low Risk'
    WHEN ROUND((perc_cost_overrun + perc_dur_overrun) / 2, 2) < 50  AND perct_completed > 50  THEN 'Moderate Risk'
    ELSE    'High Risk'
END     AS  risk_variation
FROM project_summary
WHERE status <> 'Completed'
ORDER BY risk_score DESC ;

   /*QUERY EXPLANATION
This query returns project details and derived columns (risk - score and variation) that is used to rank 
each projects base on their likelihood of failure,due to multiple stress indicators.

    USE CASE -
This can be used as an indicator to check if projects are on the right track or are heading towards failure.*/


  


        -- STAKEHOLDER'S QUESTION - Where should the PMO focus improvement efforts?

-- ======================================================================
-- 5. Evaluating Potential Causes of Failures and Improvement areas 
-- ========================================================================

WITH project_summary AS
(
    SELECT
        project_id,
        project_name,
        project_type,
        contractor,
        consultant,
        state,
        prim_delay_reas,
        budget_NGN,
        cost_overrun_NGN,
        CASE
            WHEN ROUND((CAST(cost_overrun_NGN AS FLOAT) * 100 
                 / NULLIF(budget_NGN, 0)), 2) < 0 THEN 0
            ELSE ROUND((CAST(cost_overrun_NGN AS FLOAT) * 100 
                 / NULLIF(budget_NGN, 0)), 2)
        END                                                     AS perc_cost_overrun,
        planned_dur_months,
        sched_delay_months,
        ROUND((CAST(sched_delay_months AS FLOAT) * 100 
               / NULLIF(planned_dur_months, 0)), 2)             AS perc_dur_overrun,
        perct_completed,
        status
    FROM dbo.projects
    WHERE status <> 'Completed'
),
risk_variation AS 
(
SELECT
         *,
        CASE
            WHEN status = 'Delayed'
             AND ROUND((perc_cost_overrun + perc_dur_overrun) / 2, 2) >= 50 THEN 'High Risk'
            WHEN status = 'Delayed'                                          THEN 'Moderate Risk'
            WHEN ROUND((perc_cost_overrun + perc_dur_overrun) / 2, 2) < 20
             AND perct_completed > 50                                        THEN 'Low Risk'
            WHEN ROUND((perc_cost_overrun + perc_dur_overrun) / 2, 2) < 50
             AND perct_completed > 50                                        THEN 'Moderate Risk'
            ELSE                                                                  'High Risk'
        END  AS risk_var
FROM project_summary
),
high_risk_projects AS
(
    SELECT
        project_type,
        state,
        contractor,
        consultant,
        prim_delay_reas,
        perc_cost_overrun,
        perc_dur_overrun,
        perct_completed,
        status,
        ROUND((perc_cost_overrun + perc_dur_overrun) / 2, 2)    AS risk_score
    FROM risk_variation
    WHERE risk_var = 'High Risk'     -- Only carry forward High Risk projects              
)

-- Dimension 1: By Delay Reason
SELECT
    prim_delay_reas   AS category,
    'Delay Reason'    AS dimension,
    COUNT(*)          AS high_risk_count,
    ROUND(AVG(risk_score), 2) AS avg_risk_score
FROM high_risk_projects
GROUP BY prim_delay_reas

UNION ALL

-- Dimension 2: By State
SELECT
    state     AS category,
    'State'   AS dimension,
    COUNT(*)  AS high_risk_count,
    ROUND(AVG(risk_score), 2) AS avg_risk_score
FROM high_risk_projects
GROUP BY state

UNION ALL

-- Dimension 3: By Project Type
SELECT
    project_type  AS category,
    'Project Type' AS dimension,
    COUNT(*)   AS high_risk_count,
    ROUND(AVG(risk_score), 2)  AS avg_risk_score
FROM high_risk_projects
GROUP BY project_type

UNION ALL

-- Dimension 4: By Consultant
SELECT
    consultant   AS category,
    'Consultant'  AS dimension,
    COUNT(*)      AS high_risk_count,
    ROUND(AVG(risk_score), 2) AS avg_risk_score
FROM high_risk_projects
GROUP BY consultant
ORDER BY dimension, high_risk_count DESC;

   /*QUERY EXPLANATION
This query identifies High Risk projects with the help of multiple CTE's and then determine the common 
or potential causes or reasons for them being a high risk project, categorized by multiple dimensions. 

    USE CASE -
This can help to identify most frequent causes of failure in projects and help the stakeholders work 
towards eradicating them.*/
