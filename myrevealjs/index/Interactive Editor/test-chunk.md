<html>
    <head>
        <meta charset="utf-8">
        <title>R chunk</title>
        <style>
            
body{
    font-family: "Helvetica Ssm 
　　 Book",HelveticaNeue,Helvetica,Arial,sans-serif;
    margin-left: 7.5%;
    margin-right: 7.5%;
    line-height: 1.4;
    }
    
table {
    margin: 2em 0;
    font-size: 0.9em;
    border: 1px solid #888888;
}

td{
    padding: 0.5em;
    }

img{
    width: 100%;
}
    

        </style>
    </head>
    <body>
        library(ggplot2)
ggplot(airquality, aes(Temp, Ozone)) + 
  geom_point() + 
  geom_smooth(method = "loess")
    </body>
</html>
