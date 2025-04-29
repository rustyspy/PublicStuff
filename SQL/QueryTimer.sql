DECLARE @Timer DateTime
SET @Timer = getDate()

/* Your Query Goes Here */

PRINT 'Elapsed Time:  ' + Convert(varchar(255),Convert(decimal(15,3),DateDiff(ms,@Timer,getDate()))/1000) + ' second(s)'
