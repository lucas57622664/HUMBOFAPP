ui <- navbarPage(title = 'HUMBOFAPP', id = 'nav',theme = shinytheme("spacelab"),
                 
                 tabPanel("Mapa",
                          div(class ='outer', 
                              tags$style(type = "text/css",".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"), 
                              tags$style('#map { cursor: crosshair;}'),  
                              leafletOutput(outputId = "map", width = "100%", height = '100%'),
                              absolutePanel(top = 75,left = 100,right = 'auto', width = 200,
                                            height = 'auto', bottom = 'auto', fixed = T, draggable = T, style="z-index:500",
                                            class = "panel panel-default",
                                            span(tags$i(h5("Aquí puede visualizar la coordenada del elemento")), style="color:#045a8d"),
                                            
                                            htmlOutput(outputId = "mouse_over")
                                            
                              ),           
                              conditionalPanel(condition = 'input.map_click',  
                                               absolutePanel(
                                                 id="tSeries",  
                                                 style="z-index:500;background-color: white; opacity: 1;margin: auto;border-color: transparent; padding-bottom: 2mm;padding-top: 1mm;",
                                                 class = "panel panel-default",
                                                 top = 'auto',left = 'auto',right = 'auto', width = '100%',
                                                 height = 'auto', bottom = 10, fixed = T, draggable = F,
                                                 dygraphOutput(outputId = 'tserie', width = '100%', height = 200))
                              )) 
                 ),
                 tabPanel('Gráficos',
                          sidebarPanel(
                            
                            span(tags$i(h6(strong("A CONTINUACIÓN PODRÁ VISUALIZAR TRES SERIES DE TIEMPO DE LAS SIGUIENTES VARIABLES CLIMÁTICAS:"))), style="color:#045a8d"),
                            span(tags$i(h6(strong("PRECIPITACIÓN (mm), TEMPERATURA MÁXIMA (ºC) Y TEMPERATURA MÍNIMA (ºC)"))), style="color:#045a8d"),
                            
                            radioButtons(inputId = 'variables', label = h4('Seleccione una variable:'),
                                         c("Precipitación (mm)" = "ppt",
                                           "Temperatura mínima (ºC)" = "t_min",
                                           "Temperatura máxima (ºC)" = "t_max"))
                          ),
                          
                          mainPanel(plotlyOutput(outputId = 'plot', height = "300px")),
                          
                          ("1) Los gráficos son interactivos en la visualización permitiendo un dinamismo. Para esto, debes elegir que acción realizar en la parte superior del gráfico.                  
             2) La variable precipitación corresponde a la estación meteorológica 'El Tatio' y las variables de temperatura max y min a la estacion Toconce, ambas
            estaciones se encuentran por sobre los 3000 (m snm)")
            
                 ),
            
            tabPanel("Información",
                     HTML('<img height="90"  src="logo_instituto_geografia.png" asp="1" align="left"'),
                     br(),
                     br(),
                     br(),
                     br(),
                     br(),
                     br(),
                     br(),
                     h4(strong("SOBRE LA PÁGINA")),
                     h5("'HUMBOFAPP', tiene como objetivo principal la visualización de información espacial para todo tipo de usuario sobre datos actualizados y validados compilados de 31 años de registros Landsat NDVI (1986 a 2017) referido a los humedales altoandinos de la Regón de Antofagasta."),
                     
                     h4(strong("SOBRE SHINY")),
                     h5("Shiny es un paquete de R que facilita la creación de aplicaciones web interactivas directamente desde R. Con este paquete se pueden escribir modelos de micro-simulación en tiempo discreto. Por lo tanto, la aplicación Shiny se puede compartir como una página web, lo que permite al usuario ejecutar una serie de plataformas diferentes y no requiere la instalación de ningún software especializado."),
                     
                     h5("Los códigos empleados para el desarrollo de la aplicación web están estructurados en dos partes, primero en la ui.R y segundo en el server.R. En la interfaz de usuario ui.R se codifica la estructura y diseño de la  aplicación web, contemplando los tres paneles de visualización tabPanel(‘Mapa’), tabPanel(‘Gráficos’) y tabPanel(‘Información’). El server.R se encuentra dividido en dos partes, separados en #tabPanelMapa y #tabPanelGráficos."),
                     
                     h4(strong("SOBRE LOS BOFEDALES")),
                     h5("En la macrozona norte de Chile existen distintos tipos de humedales reunidos en cuencas endorreicas, donde la zona de la Puna predominan los humedales del tipo salares, lagunas andinas, vegas y bofedales. Estos humedales altoandinos son denominados localmente como vegas y bofedales. El nombre bofedal es utilizado principalmente por la población Aymará en la provincia de Parinacota, y la población Atacameña utiliza el término de vegas para identificar la vegetación asociada a los humedales."),
                     
                     h5("Los pueblos indígenas presentan una conexión cultural y social con los bofedales y vegas, pues consumen recursos como peces y algas, canalizan las aguas, y utilizan estas áreas para el forrajeo de ganado. Los bofedales, se encuentran insertos en zonas áridas y semi áridas, donde predomina la intensa radiación solar, vientos de alta velocidad, la hipoxia, una gran amplitud térmica, el cual los bofedales se encuentran cerca de los límites hidrológicos y altitudinales de Perú, Bolivia, Chile y  Argentina. Además, estos cuerpos juegan un papel fundamental en el mantenimiento de una diversidad única de biota rara y endémica en la Cordillera de los Andes."),
                     
                     h4(strong("SOBRE LA INVESTIGACIÓN DE LOS HUMEDALES ALTOANDINOS")),
                     h5("El presente trabajo basa su planteamiento del estudio de Chávez et al. (2019) que tiene como título ‘A Multiscale Productivity Assessment of High Andean Peatlands across the Chilean Altiplano Using 31 Years of Landsat Imagery’. Los objetivos de la investigación fueron: (1) desarrollar un inventario detallado de turberas altoandinas activas (verdes) en esta región semiárida (entre latitud 17.3°S y 24.0°S / longitud 70.0°O y 66.8°O); (2) caracterizar los patrones geográficos en productividad a diferentes escalas espaciales a través de un gradiente latitudinal de ~ 800 (km) a lo largo de los Andes; y (3) evaluar los cambios espacio-temporales regionales en la productividad utilizando análisis de series de tiempo y reconstrucciones fenológicas."),
                     h5("Dentro de los resultados del estudio, se identificaron un total de 5665 polígonos de turberas distribuidos entre 17.3 °S y 23.7 °S, cubriendo un área total de 510.27 km^2."),
                     br(),  
                     h5("Ejemplo bofedales alto andinos a 4238 (m snm) (18.5 ° S, 69.1 ° W) durante el invierno seco (izquierda) y las temporadas de verano húmedo (derecha). Volcán Guallatire se visualiza al fondo"),
                     HTML('<img src="ejemplo_bofedal.png", height="200px"'),
                     br(),
                     h5("Fotografía extraida de Chávez et al. (2019)"),
                     br(),
                     br()
                     
            ),
            
) 