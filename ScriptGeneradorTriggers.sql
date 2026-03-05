
 SELECT --DB_NAME() AS DataBaseName,                  
        --dbo.SysObjects.Name AS TriggerName,
          dbo.sysComments.Text AS SqlContent
   FROM   dbo.SysObjects INNER JOIN dbo.sysComments ON dbo.SysObjects.ID = dbo.sysComments.ID
  WHERE  (dbo.SysObjects.xType = 'TR') 
  --AND   dbo.SysObjects.Name = '<YourTriggerName>'
ORDER BY  dbo.SysObjects.Name