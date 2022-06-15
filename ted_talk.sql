Select * from dbo.TED_talk$;

Select * from dbo.TED_talk_v2$;

-- remove interview, music performance and TED-ed
Delete from dbo.TED_talk_v2$ 
Where genre = 'interview' or genre = 'music' or (genre = 'education' and length < 300);

-- merge two tables together
Drop table ted_talk_new if exists;
Select title as Title,
       author as Author,
	   date as Date,
	   views as Views,
	   likes as Likes,
	   link as Links,
	   genre as Genre,
	   length as Length
Into ted_talk_new
From dbo.TED_talk$ t1
Join dbo.TED_talk_v2$ t2 on t1.link = t2.url;

-- check again
Select * from ted_talk_new;

 -- categorized length
 With cteted_talk as
	( 
	 Select genre, views, year(date) as Year,
		(case 
			when Length between 60 and 300 then '1-5'
			when Length between 301 and 600 then '6-10'
			when Length between 601 and 900 then '11-15'
			when Length between 901 and 1200 then '16-20'
			when Length between 1201 and 1500 then '21-25'
			when Length between 1501 and 1800 then '26-30'
			when Length between 1801 and 2100 then '31-35'
			Else 'Not considered'
		End) as RangeInLengthInMinutes
	 From ted_talk_new
	 )

Select genre, RangeInLengthInMinutes, Year, round(Avg(views),2) as AverageViews
From cteted_talk
Group by genre, RangeInLengthInMinutes, Year
Order by 3,4 desc
;


-- Scenario: estimated average views under specific genre and month
Select genre, Month, AverageViews					
From					
(					
Select genre, MONTH(date) as Month, round(AVG(views) over(partition by genre, MONTH(date) order by genre),2) as AverageViews					
From ted_talk_new					
Where (genre = 'technology' or genre = 'culture') and (MONTH(date) = 05 or MONTH(date) = 06)					
) as a					
Group by genre, Month, AverageViews					
;					
