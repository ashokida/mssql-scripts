
DECLARE  @STR VARCHAR(MAX) = '|ROS0001467D505004BUE,CL700037821AR,54444444,30161216124258|R1S0001467D505004COR,CD700037821ZR,24444444,60161216124258' --'a:b,c:d,e:f' --'a:b,c:d,e:f'
SELECT ID_LINEA = MAX(ROWID),
       CARATULA = MAX(VALUE1),
       TN       = MAX(VALUE2),
       COD      = MAX(VALUE3),
       FECHA    = MAX(VALUE4)
FROM (
      SELECT ROWID,
             VALUE1 = CASE WHEN ID = 1 THEN LINEA ELSE NULL END,
             VALUE2 = CASE WHEN ID = 2 THEN LINEA ELSE NULL END,
             VALUE3 = CASE WHEN ID = 3 THEN LINEA ELSE NULL END,
             VALUE4 = CASE WHEN ID = 4 THEN LINEA ELSE NULL END
         FROM (
                SELECT S.ID ROWID, 
                       T.ID, 
                       T.LINEA
                  FROM (SELECT * 
                         FROM dbo.SPLIT(@STR, '|')
                       ) S
                CROSS APPLY dbo.Split(S.LINEA, ',') T
              ) K
     ) M 
GROUP BY ROWID