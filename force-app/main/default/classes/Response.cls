public without sharing class Response {

	private static Response instance;
	private RestResponse response;

	private Response() {
		if( RestContext.response == null ) {
			RestContext.response = new RestResponse();
		}
		if( response == null ) response = RestContext.response;
	}

	public static Response getInstance() {
		if( instance == null ) {
			instance = new Response();
		}
		return instance;
	}

	private RestResponse getResponse() {
		return getInstance().response;
	}

	public Response setHeader(String contentType, String applicationJSON) {
		getResponse().addHeader(contentType, applicationJSON);
		return getInstance();
	}

	public Response setBody( Blob responseBody ) {
		if( responseBody == null ) responseBody = Blob.valueOf( '' );
		getResponse().responseBody = responseBody;
		return getInstance();
	}

}