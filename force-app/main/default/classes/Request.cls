public without sharing class Request {

	private static Request instance;
	private RestRequest request;

	private Request() {
		if( RestContext.request == null ) {
			RestContext.request = new RestRequest();
		}
		if( request == null ) request = RestContext.request;
	}

	public static Request getInstance() {
		if( instance == null ) {
			instance = new Request();
		}
		return instance;
	}

	private RestRequest getRequest() {
		return getInstance().request;
	}

	public Blob getBody() {
		return getRequest().requestBody;
	}

	public Object getBodyAsClass( String apexTypeName ) {
		if( apexTypeName == null ) return null;
		Type apexType = Type.forName( '', apexTypeName );
		if( apexType == null ) return null;
		return JSON.deserialize( getBodyAsString(), apexType );
	}

	public Object getBodyAsClass( Type apexType ) {
		if( apexType == null ) return null;
		return JSON.deserialize( getBodyAsString(), apexType );
	}

	public String getBodyAsString() {
		return getBody().toString();
	}

}