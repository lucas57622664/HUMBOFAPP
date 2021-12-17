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