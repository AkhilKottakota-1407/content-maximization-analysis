use New_projects

SELECT * FROM Content_Scheduling_for_Maximizing_Engagement;

/*According to the PPT*/

/*Descriptive Analysis*/

/*What are the top 10 most viewed content pieces overall?*/
SELECT TOP 10 Content_ID,AVG(Viewership) AS Total_views
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Content_ID
ORDER BY Total_views DESC;

/*What are the most-watched genres in each region?​*/
WITH temp_table AS (
SELECT Genre,Viewer_Location,SUM(Viewership) AS Total_viewers
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Genre,Viewer_Location),
ranked AS(
SELECT Genre,Viewer_Location,
(RANK() OVER (PARTITION BY Viewer_Location ORDER BY Total_viewers DESC)) AS genre_rank
FROM temp_table)
SELECT * FROM
ranked 
WHERE genre_rank=1;

/*Which genre has the highest average watch time?*/
SELECT Genre,AVG(Average_Watch_Time_mins) AS Avg_watch_time
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Genre
ORDER BY Avg_watch_time DESC;

/*What time of day has the highest viewer engagement?​*/
SELECT Peak_Viewership_Time,SUM(Viewership) AS total_no_of_views
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Peak_Viewership_Time
ORDER BY total_no_of_views DESC;

/*Which days of the week drive the most views?​*/
SELECT Peak_Viewership_Day,SUM(Viewership) AS total_no_of_views
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Peak_Viewership_Day
ORDER BY total_no_of_views DESC;

/*What is the average user rating for different content types (Movies vs Series)?​*/
SELECT Content_Type,AVG(User_Ratings) AS rating
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Content_Type
ORDER BY rating DESC;

/*How many likes, shares, and comments are generated per content type?​*/
SELECT Content_Type,SUM(Likes) AS total_likes,SUM(Shares) AS total_shares,SUM(Comments) AS total_comments
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Content_Type
ORDER BY total_likes DESC, total_shares DESC,total_comments DESC;



/*Diagnostic Analysis*/


/*Why did the viewership for "Thriller" genre spike on weekends?​*/

WITH VIEWS_BY_DAY AS(
SELECT Peak_Viewership_Day,SUM(Viewership) AS Total_viewership
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Peak_Viewership_Day),
Weekend_views AS
(SELECT AVG(Total_viewership) AS Avg_views
FROM VIEWS_BY_DAY
WHERE Peak_Viewership_Day IN ('Saturday','Sunday')),
Weekday_views AS
(SELECT AVG(Total_viewership) AS Avg_views
FROM VIEWS_BY_DAY
WHERE Peak_Viewership_Day IN ('Monday','Tuesday','Wednesday','Thurday','Friday'))

SELECT 'Weekday' AS Type,Avg_views FROM Weekday_views
UNION ALL
SELECT 'Weekend' AS Type,Avg_views FROM Weekend_views;

/*Viewer_age and views for thriller for week_day*/

SELECT Viewer_Age,avg(Viewership) AS avg_views
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Genre='Thriller' AND 
Peak_Viewership_Day IN ('Monday','Tuesday','Wednesday','Thurday','Friday')
GROUP BY Viewer_Age
ORDER BY avg_views DESC;


/*Viewer_age and views for thriller for week_end*/

SELECT Viewer_Age,avg(Viewership) AS avg_views
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Genre='Thriller' AND 
Peak_Viewership_Day IN ('Sunday','Saturday')
GROUP BY Viewer_Age
ORDER BY avg_views DESC;

/*Location and views for thriller IN WEEK_DAY*/

SELECT Viewer_Location,avg(Viewership) AS avg_views
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Genre='Thriller' AND 
Peak_Viewership_Day IN ('Monday','Tuesday','Wednesday','Thurday','Friday')
GROUP BY Viewer_Location
ORDER BY avg_views DESC;

/*Location and views for thriller IN WEEK_end*/

SELECT Viewer_Location,avg(Viewership) AS avg_views
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Genre='Thriller' AND 
Peak_Viewership_Day IN ('Sunday','Saturday')
GROUP BY Viewer_Location
ORDER BY avg_views DESC;


/*Viewer_gender and views for thriller,weekend*/

SELECT Viewer_Gender,avg(Viewership) AS avg_views
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Genre='Thriller' AND 
Peak_Viewership_Day IN ('Monday','Tuesday','Wednesday','Thurday','Friday')
GROUP BY Viewer_Gender
ORDER BY avg_views DESC;

/*Viewer_gender and views for thriller,weekend*/

SELECT Viewer_Gender,avg(Viewership) AS avg_views
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Genre='Thriller' AND 
Peak_Viewership_Day IN ('Sunday','Saturday')
GROUP BY Viewer_Gender
ORDER BY avg_views DESC;

/*views by location,viewer_gender,viewer_age,viewer_location*/

SELECT Peak_Viewership_Day,Viewer_Gender,Viewer_Location,Viewer_Age,AVG(Viewership) AS avg_views
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Genre='Thriller'
GROUP BY Peak_Viewership_Day,Viewer_Gender,Viewer_Location,Viewer_Age
ORDER BY avg_views DESC;


/*------------------------------------------------*/

/*Why did Content A perform better than Content B even with similar ratings?*/

/*RATING*/
SELECT Competitor_Content,AVG(User_Ratings) AS Avg_rating
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Competitor_Content ='Similar Movie A'
GROUP BY Competitor_Content
UNION ALL
SELECT Competitor_Content,AVG(User_Ratings) AS Avg_rating
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Competitor_Content ='Similar Series B'
GROUP BY Competitor_Content

/*VIEWERSHIP*/
SELECT Competitor_Content,AVG(Viewership) AS Avg_rating
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Competitor_Content ='Similar Movie A'
GROUP BY Competitor_Content
UNION ALL
SELECT Competitor_Content,AVG(Viewership) AS Avg_rating
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Competitor_Content ='Similar Series B'
GROUP BY Competitor_Content

/*SHARES*/
SELECT Competitor_Content,AVG(Shares) AS Avg_rating
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Competitor_Content ='Similar Movie A'
GROUP BY Competitor_Content
UNION ALL
SELECT Competitor_Content,AVG(Shares) AS Avg_rating
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Competitor_Content ='Similar Series B'
GROUP BY Competitor_Content

/*LIKES*/
SELECT Competitor_Content,AVG(Likes) AS Avg_rating
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Competitor_Content ='Similar Movie A'
GROUP BY Competitor_Content
UNION ALL
SELECT Competitor_Content,AVG(Likes) AS Avg_rating
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Competitor_Content ='Similar Series B'
GROUP BY Competitor_Content

/*COMMENTS*/
SELECT Competitor_Content,AVG(Comments) AS Avg_rating
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Competitor_Content ='Similar Movie A'
GROUP BY Competitor_Content
UNION ALL
SELECT Competitor_Content,AVG(Comments) AS Avg_rating
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Competitor_Content ='Similar Series B'
GROUP BY Competitor_Content

/*views by gender*/
SELECT Viewer_Gender,Competitor_Content,AVG(Comments) AS Avg_rating
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Competitor_Content ='Similar Movie A'
GROUP BY Viewer_Gender,Competitor_Content
UNION ALL
SELECT Viewer_Gender,Competitor_Content,AVG(Comments) AS Avg_rating
FROM Content_Scheduling_for_Maximizing_Engagement
WHERE Competitor_Content ='Similar Series B'
GROUP BY Viewer_Gender,Competitor_Content


/*Is there a relationship between content duration and completion rate?*/
SELECT 
(
COUNT(*)*SUM(CAST (Duration_mins AS FLOAT)*CAST (Average_Watch_Time_mins AS FLOAT)) - SUM(CAST (Duration_mins AS FLOAT))* 
SUM(CAST (Average_Watch_Time_mins AS FLOAT)))/
SQRT((COUNT(*) * SUM(CAST (Duration_mins AS FLOAT) * CAST(Average_Watch_Time_mins AS FLOAT)) - POWER(SUM(CAST(Duration_mins AS FLOAT)),2))*
(COUNT(*) * SUM(CAST(Duration_mins AS FLOAT) * CAST(Average_Watch_Time_mins AS FLOAT)) - POWER(SUM(CAST(Average_Watch_Time_mins AS FLOAT)),2)))
FROM Content_Scheduling_for_Maximizing_Engagement;

/*Are poor-performing contents linked to certain times or days?*/





/*Why did engagement drop in a specific region or age group?*/
SELECT Viewer_age,SUM(Viewership) AS Total_views,SUM(Likes) AS Total_likes,SUM(Comments) AS Total_comments,SUM(Shares) AS Total_shares
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Viewer_age
ORDER BY Total_views ASC,Total_likes ASC,Total_comments ASC,Total_shares ASC;

SELECT Viewer_Location,SUM(Viewership) AS Total_views,SUM(Likes) AS Total_likes,SUM(Comments) AS Total_comments,SUM(Shares) AS Total_shares
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Viewer_Location
ORDER BY Total_views ASC,Total_likes ASC,Total_comments ASC,Total_shares ASC;

SELECT Viewer_Gender,SUM(Viewership) AS Total_views,SUM(Likes) AS Total_likes,SUM(Comments) AS Total_comments,SUM(Shares) AS Total_shares
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Viewer_Gender
ORDER BY Total_views ASC,Total_likes ASC,Total_comments ASC,Total_shares ASC;

SELECT Viewer_Location,Viewer_Gender,SUM(Viewership) AS Total_views,SUM(Likes) AS Total_likes,SUM(Comments) AS Total_comments,SUM(Shares) AS Total_shares
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Viewer_Location,Viewer_Gender
ORDER BY Total_views ASC,Total_likes ASC,Total_comments ASC,Total_shares ASC;

SELECT Viewer_age,Viewer_Gender,SUM(Viewership) AS Total_views,SUM(Likes) AS Total_likes,SUM(Comments) AS Total_comments,SUM(Shares) AS Total_shares
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Viewer_age,Viewer_Gender
ORDER BY Total_views ASC,Total_likes ASC,Total_comments ASC,Total_shares ASC;

SELECT Viewer_Location,Viewer_age,Viewer_Gender,SUM(Viewership) AS Total_views,SUM(Likes) AS Total_likes,SUM(Comments) AS Total_comments,SUM(Shares) AS Total_shares
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Viewer_Location,Viewer_age,Viewer_Gender
ORDER BY Total_views ASC,Total_likes ASC,Total_comments ASC,Total_shares ASC;

SELECT Viewer_Location,Viewer_age,Viewer_Gender,SUM(Viewership) AS Total_views
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Viewer_Location,Viewer_age,Viewer_Gender
ORDER BY Total_views ASC;


SELECT Viewer_Location,Viewer_age,Viewer_Gender,SUM(Likes) AS Total_likes
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Viewer_Location,Viewer_age,Viewer_Gender
ORDER BY Total_likes ASC;


SELECT Viewer_Location,Viewer_age,Viewer_Gender,SUM(Comments) AS Total_comments
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Viewer_Location,Viewer_age,Viewer_Gender
ORDER BY Total_comments ASC;


SELECT Viewer_Location,Viewer_age,Viewer_Gender,SUM(Shares) AS Total_shares
FROM Content_Scheduling_for_Maximizing_Engagement
GROUP BY Viewer_Location,Viewer_age,Viewer_Gender
ORDER BY Total_shares ASC;