Create database ttc;

use ttc;

/*create database tables*/
-- create delayCodes table to store information about the delay codes used for TTC subway operations
create table delayCodes(
ID int,
SUB_RMENU_CODE varchar(6),
CODE_DESCRIPTION varchar(255)
);

/*
Create tables to store information about the delays reported between 2014 and 2023. 
Each table holds data for one year. 
Data is available at https://open.toronto.ca/dataset/ttc-subway-delay-data/ 
*/ 
CREATE TABLE delayjan2014_apr2017 (
    eventdate DATE,
    eventTime TIME,
    eventDay VARCHAR(9),
    station VARCHAR(25),
    delayCode VARCHAR(6),
    delayMin INT(4),
    gapMin INT(4),
    bound VARCHAR(2),
    line VARCHAR(5),
    vehicle INT(4)
);

CREATE TABLE delaymay_dec2017 (
    eventdate DATE,
    eventTime TIME,
    eventDay VARCHAR(9),
    station VARCHAR(25),
    delayCode VARCHAR(6),
    delayMin INT(4),
    gapMin INT(4),
    bound VARCHAR(2),
    line VARCHAR(5),
    vehicle INT(4)
);

CREATE TABLE delay2018 (
    eventdate DATE,
    eventTime TIME,
    eventDay VARCHAR(9),
    station VARCHAR(25),
    delayCode VARCHAR(6),
    delayMin INT(4),
    gapMin INT(4),
    bound VARCHAR(2),
    line VARCHAR(5),
    vehicle INT(4)
);

CREATE TABLE delay2019 (
    eventdate DATE,
    eventTime TIME,
    eventDay VARCHAR(9),
    station VARCHAR(25),
    delayCode VARCHAR(6),
    delayMin INT(4),
    gapMin INT(4),
    bound VARCHAR(2),
    line VARCHAR(5),
    vehicle INT(4)
);


CREATE TABLE delay2020 (
    eventdate DATE,
    eventTime TIME,
    eventDay VARCHAR(9),
    station VARCHAR(25),
    delayCode VARCHAR(6),
    delayMin INT(4),
    gapMin INT(4),
    bound VARCHAR(2),
    line VARCHAR(5),
    vehicle INT(4)
);

CREATE TABLE delay2021 (
    eventdate DATE,
    eventTime TIME,
    eventDay VARCHAR(9),
    station VARCHAR(25),
    delayCode VARCHAR(6),
    delayMin INT(4),
    gapMin INT(4),
    bound VARCHAR(2),
    line VARCHAR(5),
    vehicle INT(4)
);

CREATE TABLE delay2022 (
    eventdate DATE,
    eventTime TIME,
    eventDay VARCHAR(9),
    station VARCHAR(25),
    delayCode VARCHAR(6),
    delayMin INT(4),
    gapMin INT(4),
    bound VARCHAR(2),
    line VARCHAR(5),
    vehicle INT(4)
);

CREATE TABLE delay2023 (
    eventdate DATE,
    eventTime TIME,
    eventDay VARCHAR(9),
    station VARCHAR(25),
    delayCode VARCHAR(6),
    delayMin INT(4),
    gapMin INT(4),
    bound VARCHAR(2),
    line VARCHAR(5),
    vehicle INT(4)
);

-- Create a table which holds delay information for 2014 to 2023. 

CREATE TABLE ttcdelayA AS SELECT * FROM
    delayjan2014_apr2017 
UNION ALL SELECT 
    *
FROM
    delaymay_dec2017 
UNION ALL SELECT 
    *
FROM
    delay2018 
UNION ALL SELECT 
    *
FROM
    delay2019 
UNION ALL SELECT 
    *
FROM
    delay2020 
UNION ALL SELECT 
    *
FROM
    delay2021 
UNION ALL SELECT 
    *
FROM
    delay2022 
UNION ALL SELECT 
    *
FROM
    delay2023;
    

/*
Create a table to merge information required from the delayCodes table with the delays table.
Also create new fields that will be required for the visualization of delays information.
*/

CREATE TABLE ttcdelayb AS SELECT a.*,
    b.CODE_DESCRIPTION AS codedesc,
    CASE
        WHEN
            a.eventTime > '05:59:59'
                AND a.eventTime < '09:00:01'
        THEN
            'Yes'
        WHEN
            a.eventTime > '14:59:59'
                AND a.eventTime < '19:00:01'
        THEN
            'Yes'
        ELSE 'No'
    END AS rushHour,
    CASE a.eventDay
        WHEN 'Sunday' THEN 'weekend'
        WHEN 'Saturday' THEN 'weekend'
        ELSE 'weekday'
    END AS weekTime,
    CASE
        WHEN a.gapMin = 0 AND a.delayMin <> 0 THEN 1
        WHEN a.gapMin = 0 AND a.delayMin = 0 THEN 0
        ELSE a.delayMin / a.gapMin
    END AS delayGapRatio FROM
    ttcdelaya a
        JOIN
    delaycodes b ON a.delaycode = b.SUB_RMENU_CODE
WHERE
    a.line IN ('YU' , 'BD', 'SHP');

-- Create table ttcdelay to hold all relevant data required to create a visualization of TTC subway delay data analysis.

CREATE TABLE ttcdelay (
    ID INT NOT NULL AUTO_INCREMENT,
    eventdate DATE,
    eventTime TIME,
    eventDay VARCHAR(9),
    station VARCHAR(25),
    delayCode VARCHAR(6),
    delayMin INT(4),
    gapMin INT(4),
    bound VARCHAR(2),
    line VARCHAR(5),
    vehicle INT(4),
    delayDesc VARCHAR(100),
    rushHour VARCHAR(3),
    weekTime VARCHAR(7),
    delayGapRatio DECIMAL(7 , 4 ),
    PRIMARY KEY (ID)
);

-- Insert data from interim table ttcdelayb into final table ttcdelay to be used in analyzing TTC subway delay data.
Insert into ttcdelay (eventdate,eventTime,eventDay,station,delayCode,delayMin,gapMin,bound,line,vehicle,delayDesc,rushHour,weekTime,delayGapRatio) select * from ttcdelayb;

