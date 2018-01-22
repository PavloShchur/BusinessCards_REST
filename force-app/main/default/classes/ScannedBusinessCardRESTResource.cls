@RestResource(urlMapping='/businessCard')
global without sharing class ScannedBusinessCardRESTResource {

    @HttpGet
    global static void doGet() {
        ScannedBusinessCardRESTService.doGet();
    }
    
    @HttpPost
    global static void doPost() {
        ScannedBusinessCardRESTService.doPost();
    }

    @HttpDelete
    global static void doDelete() {

    }
}