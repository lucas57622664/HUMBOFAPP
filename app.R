## APLICACION WEB " HUMBOFAPP "
## HUMEDALES ALTOANDINOS (BOFEDALES) DE LA REGION DE ANTOFAGASTA
##2021
#---------------------------------------------------
library(tidyverse) #multiples herramientas de análisis, manipulación y visualización
library(readxl) #carga de archivos excel
library(rgdal) #análisis espacial
library(shiny) #facilita la creación de aplicaciones web interactivas poderosas directamente desde R. 
library(sf) #lectura de archivos con info espacial de tipo vectorial (shapefiles, geopackages, etc.))
library(leaflet) #Esta función crea un widget de mapa de folletos utilizando htmlwidgets. El widget se puede representar en páginas HTML generadas a partir de R Markdown, Shiny u otras aplicaciones.
library(ggplot2) #crador de gráficos
library(shinythemes)
library(plotly)
library(htmltools)
library(dygraphs)
library(xts)
#library(rsconnect) #publicar en servidor www.shinyapps.io
#---------------------------------------------------
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
    
server <- function(input, output, session) {
sf::sf_use_s2(FALSE)  

  #lectura de datos
  bofedal<-read_sf('data/capas/bofedales/Bofedal_LOA_TS.gpkg') %>% st_zm() ##archivo con columnas incorporadas. st_zm() elimina valor z
  region <- read_sf('data/capas/region/antofa.shp') %>% st_transform(4326)
  area_estudio <- read_sf('data/capas/area_estudio/area_estudio.shp')
  usos_agua<-read_sf('data/capas/pozos/All_DAA_WGS84_DDAA_3000.shp') %>% st_transform(4326)
  indigenas<-read_sf('data/capas/indigenas/poblados_indigenas_shp.shp')
  mineras<-read_sf('data/capas/mineras/mineras_antofa.shp')
 #input datos climaticos
  est_eltatio<-read_sf('data/capas/estacionElTatio/El_Tatio.shp')
  est_toconce<-read_sf('data/capas/estacionToconce/Toconce.shp')
  Precipitación<-read_xlsx('data/capas/pp_t/ppt_ac_ms_eltatio.xlsx')
  Temp_máxima<-read_xlsx('data/capas/pp_t/tmax_toconce.xlsx')
  Temp_mínima<-read_xlsx('data/capas/pp_t/tmin_toconce.xlsx')

#------------------------------------------------------------
#tabPanelMapa

  ## VENTANA MODAL - INSTRUCCIONES AL USUARIO
  showModal(tags$div(id="modal1", modalDialog(
    inputId = "Dialog1",
    easyClose = TRUE,
    title = HTML('<img height="70" src="logo_instituto_geografia.png" asp="1" align="center" width=250> 
               <button type = "button" class="close" data-dismiss="modal" ">
               <span style="color:white; "><i class="fas fa-window-close"></i><span>
               </button> '),

    h3(strong('Bienvenido/a a HUMBOFAPP')),
    div(HTML(paste0("<br> HUMBOFAPP es una plataforma digital para visualizar información espacial de los bofedales de la Región de Antofagasta. <br><br>",
                    "1) Haga click en un cuerpo de bodedal para obtener la <b>'serie de tiempo NDVI'.</b><br>",
                    "2) Pase el mouse sobre el elementos del mapa para obtener información.")
    )),
    footer = tagList(
      modalButton("Entrar")
    ))))
  
 #custom label 
 mineras$label_min <- paste0('<strong>', 'Faena: ' , '</strong>', mineras$faena, sep = "<br/>", 
                         '<strong>', 'Empresa: ' , '</strong>', mineras$empresa, sep = "<br/>", 
                         '<strong>', 'Tipo Faena: ' , '</strong>', mineras$tipo_faena, sep = "<br/>", 
                         '<strong>', 'Pasta: ' , '</strong>', mineras$pasta) %>% lapply(htmltools::HTML)
  
 usos_agua$label_ua <- paste0('<strong>', 'Fuente: ' , '</strong>', usos_agua$Fuente, sep = "<br/>",
                          '<strong>', 'Uso: ' , '</strong>', usos_agua$Uso, sep = "<br/>",
                          '<strong>', 'Caudal: ' , '</strong>', usos_agua$Caudal, sep = "<br/>",
                          '<strong>', 'Fecha: ' , '</strong>', usos_agua$Fecha) %>% lapply(htmltools::HTML)
 
 indigenas$label_in <- paste0('<strong>', 'Nombre comunidad: ' , '</strong>', indigenas$Name) %>% lapply(htmltools::HTML)
  
 est_toconce$label_toc <- paste0('<strong>', 'Nombre estación: ' , '</strong>', est_toconce$Name) %>% lapply(htmltools::HTML)
 
 est_eltatio$label_tatio <- paste0('<strong>', 'Nombre estación: ' , '</strong>', est_eltatio$name_1) %>% lapply(htmltools::HTML)
 
 #personalizacion de iconos de marcadores
  minerasICON <- makeIcon(
   iconUrl = "www/goldenfever2.png",
   iconWidth = 20, iconHeight = 20,
   iconAnchorX = 20, iconAnchorY = 20,
 )
 
 indigenasICON <- makeIcon(
   iconUrl = "www/familia.png",
   iconWidth = 20, iconHeight = 20,
   iconAnchorX = 20, iconAnchorY = 20
 )
 
 usos_aguaICON <- makeIcon(
   iconUrl = "www/agua.png",
   iconWidth = 15, iconHeight = 15,
   iconAnchorX = 15, iconAnchorY = 15,
 )
 
  ##render mapa base
  output$map <- renderLeaflet({
    leaflet() %>% 
      addTiles() %>% 
      addProviderTiles(providers$Esri.WorldImagery, group = "Esri Map") %>% 
      addProviderTiles(providers$OpenTopoMap, group = "Topo Map") %>% 
      fitBounds(lng1=-71.5, lat1 = -20, lng2 = -66.5, lat2 = -26) %>% 
      
      addPolygons(data = bofedal %>% st_zm(), group = "Bofedales", color = 'green') %>% 
  
      addPolygons(data = region, group = "Región de Antofagasta", fill = F, weight = 4, color = "#f03b20") %>% 
      
      addPolygons(data = area_estudio, group = "Área de estudio", stroke = F, smoothFactor = 0.1, fillOpacity = 0.2) %>% 
      
      addMarkers(data = mineras, group = "Mineras", 
                 icon = minerasICON,
                 label = ~label_min,
                 labelOptions = labelOptions(style = list("font-size" = "11px"))) %>% 
      
      addMarkers(data = usos_agua, group = "Usos de agua",
                 icon = usos_aguaICON,
                 label = ~label_ua,
                 labelOptions = labelOptions(style = list("font-size" = "11px"))) %>%  
      
      addMarkers(data = indigenas,  group = "Pueblos indígenas",
                 icon = indigenasICON,
                 label = ~label_in,
                 labelOptions = labelOptions(style = list("font-size" = "11px"))) %>% 
     
       addCircleMarkers(data = est_eltatio,  group = "Estación El Tatio", color = "black",
                        label = ~label_tatio) %>% 
      
       addCircleMarkers(data = est_toconce,  group = "Estación Toconce", color = "yellow",
                        label = ~label_toc) %>% 
                  
      addLayersControl(
        baseGroups = c("Esri Map", "Topo Map"),
        overlayGroups = c("Región de Antofagasta", "Área de estudio", "Bofedales", 
                          "Mineras", "Usos de agua", "Pueblos indígenas", "Estación El Tatio", "Estación Toconce"),
        options = layersControlOptions(collapsed = T),
        position = "topright")
    
  })
 
  #captura de coordenadas
  #Interseccion
  bof.extract <-  eventReactive(input$map_click,{
    click <- isolate({input$map_click})
    dts <- st_as_sf(data.frame(lng = click$lng,lat = click$lat),coords = c("lng", "lat"), 
                    crs = 4326)
    interBof <- st_join(dts,bofedal)[,2:ncol(bofedal)] %>% as.data.frame() %>% 
      dplyr::select(-c(geometry)) %>%  as.numeric()
    
    return(interBof)
  })

 #marcadores de click
  observeEvent(input$map_click,{
    click <- input$map_click 
    clat <- click$lat
    clng <- click$lng
    #map markers
    leafletProxy('map') %>% addMarkers(lng = click$lng, lat = click$lat, label =  paste(
      'lat:',round(clat,4), '| lng:', round(clng,4))) 
  })
  
  #serie de tiempo
  output$tserie <- renderDygraph({
    req(input$map_click)
    #crear objeto ts
    tserie <- ts(bof.extract(), start = c(1986,1), end = c(2018, 12), frequency = 12) %>% xts::as.xts() #as.xts(),da compatibilidad a la serie
    #plot
    dygraph(tserie) %>% 
      dySeries("V1", label = 'productividad') %>% 
      dyRangeSelector(height = 10,strokeColor = '') %>% 
      dyAxis('y',label = 'ndvi', valueRange = c(-0.2,0.8)) %>% 
      dyOptions(drawPoints = T, pointSize = 2, colors = 'black')
  })
  

  #mouse events
  #mouseover
  observeEvent(input$map_shape_mouseover,{
    data_mouse_over <- input$map_shape_mouseover #guarda los valores
    
    output$mouse_over <- renderText({
      paste('<b>Mouse shape over: </b>',round(data_mouse_over$lat,digits = 4),'|',
            round(data_mouse_over$lng,digits = 4))
    })
  })
  
#---------------------------------------------------------
#tabPanelgraficos
  
  #reactivo plot grafico
  
  plot_serie <- eventReactive(
    input$variables,{
      req(input$variables)
     if(input$variables == 'ppt')
      {g<- ggplot(Precipitación, aes(Año,Valor))+geom_line(aes(color="Precipitación"))+geom_point(size= 0.5)+
      labs(color="Legenda")+ ggtitle("Precipitación (mm) en estación El Tatio")+
      theme(plot.title = element_text(lineheight = .6,face = "bold"))+theme_bw()+
          xlab('Años') + ylab("(mm)")}
 
    if(input$variables == 't_min')
      {g<- ggplot(Temp_mínima, aes(Año,Valor))+geom_line(aes(color="Temp_mínima"))+geom_point(size= 0.5)+
      labs(color="Legenda")+ ggtitle("Temperatura mínima (ºC) en estación Toconce")+
      theme(plot.title = element_text(lineheight = .6,face = "bold"))+theme_bw()+
        xlab('Años') + ylab("(ºC)")}
      
    if(input$variables == 't_max')
      {g<- ggplot(Temp_máxima, aes(Año,Valor))+geom_line(aes(color="Temp_máxima"))+geom_point(size= 0.5)+
      labs(color="Legenda")+ ggtitle("Temperatura máxima (ºC) en estación Toconce")+
      theme(plot.title = element_text(lineheight = .6,face = "bold"))+theme_bw()+
      xlab('Años') + ylab("(ºC)")}

    g
  }) 
  
  #render plot grafico
    output$plot <- renderPlotly({ggplotly(plot_serie())})
}

shinyApp(ui, server)
