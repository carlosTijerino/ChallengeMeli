# ChallengeMeli

Desarrollar una APP utilizando las APIs de Mercado Libre, que le permita a un usuario ver los detalles de un producto

***Descripción de la aplicación***

La aplicación cuenta con 3 pantallas
  * La pantalla de busqueda: 
      La cual ingresas el nombre de un producto ó palabra clave (query) y muestra algunas sugerencias de productos para buscar el detalle de un producto
  * Listado de los productos encontrados: 
      Muestra la imagen, el nombre y el precio de una lista de productos encontrados de acuerdo a la palabra buscada
  * Detalle del producto: 
      Muestra la información detallada del producto seleccionado, consta de la condición del producto (nuevo o usado), el titulo del producto, un carrousel de imagenes del producto, el precio del producto, el stock cantidad de articulos disponibles, la descripción del producto, información de el vendedor (ubicación), las publicaciones del vendedor, e información del producto.
      
Detalles técnicos
Versión de xcode 13.0
Lenguaje utilizado: Swift
Arquitectura utilizada: MVC
Versión minima de iOS: 8.0

Librerias utilizadas
Reachability - Para obtener la información de conectividad de internet

Endpoints utilizados
* static let apiMELI = "https://api.mercadolibre.com" ----> API de Mercado Libre
* static let searchItems = "/sites/MLA/search?q=" -------> para obtener ítems de una consulta de búsqueda
* static let searchItemsSeller = "/sites/MLA/search?seller_id=" -----> Obtener ítems de vendedor por id del vendedor
* static let items = "/items/" ----> Obtener el detalle de un ítem (descripción del item, imagenes del item)
* static let domain_discovery = "/sites/MLA/domain_discovery/search?" ----> obtener sugerencias de categorioas

Test
Se creo la pruebas automatizadas para el flujo de una busqueda y ver el detalle del producto
Se utilizo XCTest para realizar la prueba automatizada
La prueba fue ejecutada con exito

Notas
*El código se encuenta documentado
*No se pide ningún permiso ya que no accedemos a ningún dato personal del dispositivo como acceso a cámara, fotos, localización o datos personales
    
    
