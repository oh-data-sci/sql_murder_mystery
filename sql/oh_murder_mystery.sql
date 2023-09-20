SELECT name, sql
    FROM sqlite_master
    WHERE type = 'table'
    ORDER BY name
;

SELECT *
    FROM sqlite_master
    WHERE type = 'table'
;

SELECT COUNT(*) FROM crime_scene_report;

-- collect some medadata
SELECT COUNT(*) AS crime_scene_report_count     FROM crime_scene_report;
SELECT COUNT(*) AS get_fit_now_check_in_count   FROM get_fit_now_check_in;
SELECT COUNT(*) AS interview_count              FROM interview;
SELECT COUNT(*) AS drivers_license_count        FROM drivers_license;
SELECT COUNT(*) AS get_fit_now_member_count     FROM get_fit_now_member;
SELECT COUNT(*) AS person_count                 FROM person;
SELECT COUNT(*) AS facebook_event_checkin_count FROM facebook_event_checkin;
SELECT COUNT(*) AS income_count                 FROM income;
SELECT COUNT(*) AS solution_count               FROM solution;

-- all in one table: 
          SELECT 'crime_scene_report'     AS tab_name, COUNT(*) AS count_rows FROM crime_scene_report
UNION ALL SELECT 'get_fit_now_check_in'   AS tab_name, COUNT(*) AS count_rows FROM get_fit_now_check_in
UNION ALL SELECT 'interview'              AS tab_name, COUNT(*) AS count_rows FROM interview
UNION ALL SELECT 'drivers_license'        AS tab_name, COUNT(*) AS count_rows FROM drivers_license
UNION ALL SELECT 'get_fit_now_member'     AS tab_name, COUNT(*) AS count_rows FROM get_fit_now_member
UNION ALL SELECT 'person'                 AS tab_name, COUNT(*) AS count_rows FROM person
UNION ALL SELECT 'facebook_event_checkin' AS tab_name, COUNT(*) AS count_rows FROM facebook_event_checkin
UNION ALL SELECT 'income'                 AS tab_name, COUNT(*) AS count_rows FROM income
UNION ALL SELECT 'solution'               AS tab_name, COUNT(*) AS count_rows FROM solution
;
-- 
-- 
-- 
-- end preliminaries
-- 
-- 
----------------------------------------------
-- the crime:
-- 
-- 
-- a murder happened in sql city. on 2018-01-01
-- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--- 1st clue
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
SELECT *
FROM crime_scene_report
WHERE city = 'SQL City'
ORDER BY date DESC;
-- Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".	

-- ┌──────────┬─────────┬────────────────────────────────────────────────────────────────────────────────────────────┬──────────┐
-- │   date   │  type   │                                        description                                         │   city   │
-- ├──────────┼─────────┼────────────────────────────────────────────────────────────────────────────────────────────┼──────────┤
-- │ 20180115 │ murder  │ Security footage shows that there were 2 witnesses. The first witness lives at the last ho │ SQL City │
-- │          │         │ use on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin  │          │
-- │          │         │ Ave".                                                                                      │          │

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--- 2nd clue
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- from the descrition of the first witness
SELECT * 
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1 
;

-- ┌───────┬────────────────┬────────────┬────────────────┬─────────────────────┬───────────┐
-- │  id   │      name      │ license_id │ address_number │ address_street_name │    ssn    │
-- ├───────┼────────────────┼────────────┼────────────────┼─────────────────────┼───────────┤
-- │ 14887 │ Morty Schapiro │ 118009     │ 4919           │ Northwestern Dr     │ 111564949 │
-- └───────┴────────────────┴────────────┴────────────────┴─────────────────────┴───────────┘

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--- 3rd clue
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- from the description of the second witness
SELECT * 
FROM person
WHERE address_street_name = 'Franklin Ave'
    AND name LIKE 'Annabel%'
;
-- ┌───────┬────────────────┬────────────┬────────────────┬─────────────────────┬───────────┐
-- │  id   │      name      │ license_id │ address_number │ address_street_name │    ssn    │
-- ├───────┼────────────────┼────────────┼────────────────┼─────────────────────┼───────────┤
-- │ 16371 │ Annabel Miller │ 490173     │ 103            │ Franklin Ave        │ 318771143 │
-- └───────┴────────────────┴────────────┴────────────────┴─────────────────────┴───────────┘

SELECT id
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1 
;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
--- 4th clue
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- let us read monty schapiro's witness statements
SELECT * 
FROM interview 
WHERE person_id = 14887
; 

-- or:
SELECT * 
FROM interview 
WHERE person_id = (
    SELECT id
    FROM person
    WHERE address_street_name = 'Northwestern Dr'
    ORDER BY address_number DESC
    LIMIT 1 
);

-- ┌───────────┬────────────────────────────────────────────────────────────────────────────────────────────┐
-- │ person_id │                                         transcript                                         │
-- ├───────────┼────────────────────────────────────────────────────────────────────────────────────────────┤
-- │ 14887     │ I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membersh │
-- │           │ ip number on the bag started with "48Z". Only gold members have those bags. The man got in │
-- │           │ to a car with a plate that included "H42W".                                                │
-- └───────────┴────────────────────────────────────────────────────────────────────────────────────────────┘




SELECT id
FROM person
WHERE address_street_name = 'Franklin Ave'
    AND name LIKE 'Annabel%'
; 

SELECT * 
FROM interview 
WHERE person_id = 16371
;

SELECT *
FROM interview
WHERE person_id = (
    SELECT id
    FROM person
    WHERE address_street_name = 'Franklin Ave'
        AND name LIKE 'Annabel%'
);



-- ┌───────────┬────────────────────────────────────────────────────────────────────────────────────────────┐
-- │ person_id │                                         transcript                                         │
-- ├───────────┼────────────────────────────────────────────────────────────────────────────────────────────┤
-- │ 16371     │ I saw the murder happen, and I recognized the killer from my gym when I was working out    │
-- │           │ last week on January the 9th.                                                              │
-- └───────────┴────────────────────────────────────────────────────────────────────────────────────────────┘

┌────────┬─────┬────────┬───────────┬────────────┬────────┬──────────────┬───────────┬───────────┐
│   id   │ age │ height │ eye_color │ hair_color │ gender │ plate_number │ car_make  │ car_model │
├────────┼─────┼────────┼───────────┼────────────┼────────┼──────────────┼───────────┼───────────┤
│ 183779 │ 21  │ 65     │ blue      │ blonde     │ female │ H42W0X       │ Toyota    │ Prius     │
│ 423327 │ 30  │ 70     │ brown     │ brown      │ male   │ 0H42W2       │ Chevrolet │ Spark LS  │
│ 664760 │ 21  │ 71     │ black     │ black      │ male   │ 4H42WR       │ Nissan    │ Altima    │
└────────┴─────┴────────┴───────────┴────────────┴────────┴──────────────┴───────────┴───────────┘



SELECT
    p.id,
    p.name
FROM
    person p -- for every person of interest:
    INNER JOIN drivers_license        dl ON p.license_id = dl.id              -- get their licence plate
    INNER JOIN get_fit_now_member   gfnm ON         p.id = gfnm.person_id     -- and membership number
    INNER JOIN get_fit_now_check_in gfnc ON      gfnm.id = gfnc.membership_id -- and gym check-in dates
WHERE
    gfnm.membership_status = 'gold'     -- only gold member have bags
    AND gfnm.id LIKE '48Z%'            -- partial match membership number
    AND dl.plate_number LIKE '%H42W%'   -- partial match licence plate number
    AND gfnc.check_in_date = '20180109' -- date when witness met murderer in gym
;




--
SELECT *
FROM
    person p
    INNER JOIN drivers_license        dl ON p.license_id = dl.id
    INNER JOIN income                  i ON p.ssn = i.ssn
    INNER JOIN get_fit_now_member   gfnm ON p.id = gfnm.person_id
    INNER JOIN get_fit_now_check_in gfnc ON gfnm.id = gfnc.membership_id
WHERE
    gfnm.membership_status = 'gold'
    AND gfnm.id LIKE '48Z%'
    AND dl.plate_number LIKE '%H42W%'
    AND gfnc.check_in_date = '20180109'
;

SELECT * 
FROM interview 
WHERE person_id = 67318
;


SELECT * 
FROM facebook_event_checkin 
WHERE event_name = 'SQL Symphony Concert' 
LIMIT 5
;

SELECT 
    COUNT(*) AS num_checkins, 
    COUNT(DISTINCT person_id) AS num_concertgoers 
FROM facebook_event_checkin 
WHERE 
    event_name = 'SQL Symphony Concert' 
    AND date BETWEEN 20171200 AND 20180000
;



WITH concertgoers AS(
    SELECT person_id, COUNT(DISTINCT "date") AS num_attendances
    FROM facebook_event_checkin
    WHERE event_name = 'SQL Symphony Concert'
    GROUP BY person_id
    HAVING num_attendances >=3
), physical_description_matches AS (
    SELECT p.id
    FROM 
        drivers_license dl
        INNER JOIN person p ON dl.id = p.license_id
    WHERE 
        dl.car_make = 'Tesla'
        AND dl.hair_color = 'red' 
        AND dl.height BETWEEN 65 AND 67 
    LIMIT 5
)
SELECT person_id FROM concertgoers
INTERSECT
SELECT id AS person_id FROM physical_description_matches
;

-- ┌───────────┐
-- │ person_id │
-- ├───────────┤
-- │ 99716     │
-- └───────────┘

SELECT * FROM person WHERE id = 99716;

-- ┌───────┬──────────────────┬────────────┬────────────────┬─────────────────────┬───────────┐
-- │  id   │       name       │ license_id │ address_number │ address_street_name │    ssn    │
-- ├───────┼──────────────────┼────────────┼────────────────┼─────────────────────┼───────────┤
-- │ 99716 │ Miranda Priestly │ 202298     │ 1883           │ Golden Ave          │ 987756388 │
-- └───────┴──────────────────┴────────────┴────────────────┴─────────────────────┴───────────┘



SELECT MIN(annual_income), AVG(annual_income), MAX(annual_income) FROM income;

