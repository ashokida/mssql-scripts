
 DECLARE @Query        NVARCHAR(MAX),
         @StrMotSelect NVARCHAR(MAX),
         @StrMotPivot  NVARCHAR(MAX) ,
         @OT_ID        INT
   
 SET @StrMotSelect  = ''  
 SET @StrMotPivot  = ''  
 SET @OT_ID = 97


   SELECT @StrMotSelect += ', ['+MOT_DESCRIP+'] AS ['+MOT_DESCRIP+']', @StrMotPivot += '['+MOT_DESCRIP+'],'  
     FROM INCIDENTE IC INNER JOIN MOTIVO MOT ON IC.MOT_CODIGO = MOT.MOT_CODIGO 
    WHERE OT_ID = @OT_ID
 GROUP BY MOT_DESCRIP   
 
 SET @StrMotPivot  = substring(@StrMotPivot, 0, len(@StrMotPivot))  
 SET @StrMotSelect = SUBSTRING(@StrMotSelect,2,LEN(@StrMotSelect))
 
 SET @Query =' SELECT ' + @StrMotSelect + 
               ' FROM (
                         SELECT MOT_DESCRIP, 
                                COUNT(MOT_DESCRIP) CANTIDAD
                           FROM INCIDENTE IC INNER JOIN MOTIVO MOT ON IC.MOT_CODIGO = MOT.MOT_CODIGO 
                          WHERE OT_ID = ' + LTRIM(@OT_ID) + 
                     ' GROUP BY MOT_DESCRIP ) AUX
                 PIVOT  
                      (  
                         AVG(CANTIDAD)  
                         FOR MOT_DESCRIP IN ('+ @StrMotPivot +')  
                      ) AS  p2 '

 EXECUTE (@Query)
  
   
   
   
   