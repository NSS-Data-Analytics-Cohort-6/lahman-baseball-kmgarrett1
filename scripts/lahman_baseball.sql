/*1. What range of years for baseball games played does the provided database cover?
SELECT 
	DISTINCT a.yearid, 
FROM people AS p
INNER JOIN appearances AS A
ON p.playerid = a.playerid
GROUP BY a.yearid;

Answer: 1871-2016 */

/*2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?

SELECT
	p.namefirst,
	p.namelast,
	MIN(p.height), 
	a.teamid, 
	a.g_all,
	t.name
FROM people AS p
INNER JOIN appearances AS A
ON p.playerid = a.playerid
INNER JOIN teams AS t
ON a.teamid = t.teamid
GROUP BY 
	p.namefirst,
	p.namelast,
	a.teamid,
	a.g_all,
	t.name
ORDER BY 
	MIN(p.height);
	
Answer: Eddie Gaedel, 43", 1 game, St. Louis Browns */

/*3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?

SELECT
	p.namefirst,
	p.namelast,
	c.schoolid,
	s.schoolname,
	SUM(s2.salary)
FROM people AS p
INNER JOIN collegeplaying AS c
ON p.playerid = c.playerid
INNER JOIN schools AS s
ON c.schoolid = s.schoolid
INNER JOIN salaries AS s2
ON p.playerid = s2.playerid
WHERE s.schoolname = 'Vanderbilt University'
GROUP BY 
	p.namefirst,
	p.namelast,
	c.schoolid,
	s.schoolname
ORDER BY SUM(s2.salary)DESC;

Answer: David Price - $245,553,888 */

/*4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.

SELECT
	SUM(po) AS total_putouts,
	CASE WHEN f.pos = 'OF' THEN 'Outfield'
	     WHEN f.pos IN ('SS', '1B', '2B', '3B') THEN 'Infield'
		 WHEN f.pos IN ('P', 'C') THEN 'Battery' END AS position
FROM people AS p
INNER JOIN fielding AS f
ON p.playerid = f.playerid
WHERE f.yearid ='2016'
GROUP BY 
	position
ORDER BY 
	total_putouts;

Answer:
29560	"Outfield"
41424	"Battery"
58934	"Infield" */

/*5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?

SELECT 
	ROUND(AVG(so),2),
	ROUND(AVG(hr),2),
	CASE WHEN yearid BETWEEN 1920 AND 1929 THEN '1920s'
		 WHEN yearid BETWEEN 1930 AND 1939 THEN '1930s'
		 WHEN yearid BETWEEN 1940 AND 1949 THEN '1940s'
		 WHEN yearid BETWEEN 1950 AND 1959 THEN '1950s'
		 WHEN yearid BETWEEN 1960 AND 1969 THEN '1960s'
		 WHEN yearid BETWEEN 1970 AND 1979 THEN '1970s'
		 WHEN yearid BETWEEN 1980 AND 1989 THEN '1980s'
		 WHEN yearid BETWEEN 1990 AND 1999 THEN '1990s'
		 WHEN yearid BETWEEN 2000 AND 2009 THEN '2000s'
		 WHEN yearid BETWEEN 2010 AND 2019 THEN '2010s' 
		 END AS decade
/* Alternative: CONCAT(LEFT(CAST(yearid AS text), 3), '0s') AS decade */
FROM teams
WHERE yearid >= 1920
GROUP BY 
	decade
ORDER BY 
	decade;

Answer: The average are increasing, with a sharp rise between the 1950s and 1960s, possibly due to racial integration and again in the 90s/2000s possibly due to an increase in steroid use.*/

/*6. Find the player who had the most success stealing bases in 2016, where success is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted at least 20 stolen bases.*/

/*SELECT
	p.namefirst,
	p.namelast,
	p.playerid,
	b.yearid,
	SUM(b.sb) AS total_stolen,
	SUM(b.sb + b.cs) AS total_attempts,
	SUM(b.sb) * 100.0 / NULLIF(SUM(b.sb + b.cs),0) AS percent_success
FROM people AS p
LEFT JOIN batting AS b
ON p.playerid = b.playerid
GROUP BY 
	p.namefirst,
	p.namelast,
	p.playerid,
	b.yearid,
	b.sb,
	b.cs
HAVING SUM(b.sb + b.cs) > 20
	AND yearid = '2016'
ORDER BY percent_success DESC;

Answer: Chris Owings*/

/*7A.From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? 7B. What is the smallest number of wins for a team that did win the world series? 
7C.Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. 
7D.Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?

MLB Strike in 1981

How to find year they won the world series - subquery */

/*7A Answer: Seattle - 2001 - 116 */
/*SELECT
	t.name,
	t.yearid,
	t.w AS Wins,
	t.WSWin AS World_Series_WIN
FROM teams AS t
WHERE t.yearid BETWEEN 1970 AND 2016
	AND t.WSWin = 'N'
GROUP BY 
	t.w,
	t.WSWin,
	t.name,
	t.yearid
ORDER BY t.w DESC; */
	
/*7B. LA Dodgers	1981	63 */
/*SELECT
	t.name,
	t.yearid,
	t.w AS Wins,
	t.WSWin AS World_Series_WIN
FROM teams AS t
WHERE t.yearid BETWEEN 1970 AND 2016
	AND t.WSWin = 'Y'
GROUP BY 
	t.w,
	t.WSWin,
	t.name,
	t.yearid
ORDER BY t.w ASC;*/

/* 7C. MLB Strike in 1981 , excluding 1981 is "an Francisco Giants	2010	92*/
/*SELECT
	t.name,
	t.yearid,
	t.w AS Wins,
	t.WSWin AS World_Series_WIN
FROM teams AS t
WHERE t.yearid BETWEEN 1970 AND 1980 
	OR t.yearid BETWEEN 1982 AND 2016
	AND t.WSWin = 'Y'
GROUP BY 
	t.w,
	t.WSWin,
	t.name,
	t.yearid
ORDER BY t.WSWin DESC; */

/* 7D. STILL NEED TO DO */

/*WITH cte AS 
	(SELECT 
		t.yearid,
		t.name,
		t.w,
		t.wswin
	FROM teams AS t
INNER JOIN 
	(SELECT
		yearid,
		MAX(w) AS w
	FROM teams AS t2
	GROUP BY yearid
	ORDER BY yearid) AS t3
ON t.yearid = t3.yearid
AND t.w = t.w
WHERE t1.yearid BETWEEN 1970 AND 2016)
SELECT AVG(CASE WHEN wswin = 'Y' THEN 1
			WHEN wswin= 'N' THEN 0 END) AS avg
			FROM cte; */
/*
SELECT
	t.name,
	t.yearid,
	t.w AS Wins,
	t.WSWin AS World_Series_WIN
FROM teams AS t
WHERE t.yearid BETWEEN 1970 AND 1980 
	OR t.yearid BETWEEN 1982 AND 2016
	AND t.WSWin = 'Y'
GROUP BY 
	t.w,
	t.WSWin,
	t.name,
	t.yearid
ORDER BY t.WSWin DESC; */

/*8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.*/ 

/* 8A. Answer:
"LAN"	"LOS03"		45719
"SLN"	"STL10"		42524
"TOR"	"TOR02"		41877
"SFN"	"SFO03"		41546
"CHN"	"CHI11"		39906
SELECT 
	hg.year,
	hg.team,
	hg.park,
	hg.games,
	hg.attendance,
	hg.attendance/hg.games AS avg_attendance
FROM homegames AS hg
WHERE hg.year = 2016
	AND hg.games > 10
GROUP BY 
	hg.year,
	hg.team,
	hg.park,
	hg.games,
	hg.attendance
ORDER BY 
	avg_attendance DESC; */

/* 8B. Answer: 
"TBA"	"STP01"		15878
"OAK"	"OAK01"		18784
"CLE"	"CLE08"		19650
"MIA"	"MIA02"		21405
"CHA"	"CHI12"		21559 */
/* SELECT 
	hg.year,
	hg.team,
	hg.park,
	hg.games,
	hg.attendance,
	hg.attendance/hg.games AS avg_attendance
FROM homegames AS hg
WHERE hg.year = 2016
	AND hg.games > 10
GROUP BY 
	hg.year,
	hg.team,
	hg.park,
	hg.games,
	hg.attendance
ORDER BY 
	avg_attendance ASC; */


/*9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.*/

/* Answer: Missing Team Name
"Davey"	"Johnson"	1997	"AL"	"NL"
"Jim"	"Leyland"	2006	"AL"	"NL"*/

/*WITH L1 AS
	(SELECT *
	 FROM awardsmanagers AS a
	 WHERE a.lgid = 'AL'),
	  
L2 AS 
	(SELECT *
	 FROM awardsmanagers AS a
	 WHERE a.lgid = 'NL')

SELECT 
	DISTINCT L1.playerid,
	p.namefirst,
	p.namelast,
	L1.yearid,
	L1.lgid,
	L2.lgid,
	m.teamid
FROM L1
INNER JOIN L2
ON L1.playerid = L2.playerid
INNER JOIN people AS p
ON L1.playerid = p.playerid
LEFT JOIN managers as M
ON m.playerid = p.playerid AND 
WHERE L1.awardid = 'TSN Manager of the Year'
AND L2.awardid = 'TSN Manager of the Year'; */

/*10. Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.*/

SELECT
	b.playerid,
	b.hr,
	p.namefirst,
	p.namelast,
	b.yearid,
	COUNT(DISTINCT b.yearid) AS years
FROM batting AS b
INNER JOIN people AS p
ON b.playerid = p.playerid
WHERE b.yearid = 2016
HAVING years > 10
GROUP BY 
	b.playerid,
	b.hr,
	p.namefirst,
	p.namelast,
	b.yearid
;
	
