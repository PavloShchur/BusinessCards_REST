@RestResource(urlMapping='/image')
global class ImageRESTResource {
    
    @HttpGet
    global static void getAttachedPicture() { ImageRESTService.getAttachedPicture();  }
    
    @HttpPost
    global static void attachPicture() { ImageRESTService.attachPicture(); }
    
}