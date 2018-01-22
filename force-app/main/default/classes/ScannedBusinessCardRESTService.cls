global class ScannedBusinessCardRESTService {

	public static void doGet() {

		RestContext.response.addHeader(Constants.HEADER_CONTENT_TYPE, Constants.CONTENT_TYPE_APPLICATION_JSON);

		String userId = RestContext.request.params.get('creatorId');
		String status = RestContext.request.params.get('status');
		String cardId = RestContext.request.params.get('id');

		if (cardId != null && GeneralService.isValid(cardId, Scanned_Business_Cards__c.sObjectType) == false)
		{

			Response.getInstance().setBody(Blob.valueOf(JSON.serialize(new DTOScannedBusinessCard.StatusMessage(
							'Your request is invalid. ' +
							'Make sure that you specified the correct card Id', Constants.HTTP_STATUS_NOT_FOUND))));

			return;
		}

		if (status != null &&
				!GeneralService.listContains(GeneralService.getValuesOfPicklist_ScannedBusinessCard(), status)) {

			Response.getInstance().setBody(Blob.valueOf(JSON.serialize(new DTOScannedBusinessCard.StatusMessage(
							'Your request is invalid. Please check the status. ' +
							'Maybe you entered the status which does not exist. After that again.',
					Constants.HTTP_STATUS_NOT_FOUND))));

			return;
		}

		if (userId != null && status != null && cardId == null) {

			if (!ScannedBusinessCardDAO.getBusinessCardByCreatedByIdAndStatus(userId, status).isEmpty()) {

				Response.getInstance().setBody(Blob.valueOf(JSON.serialize(
								new DTOScannedBusinessCard.CardsList(
										ScannedBusinessCardDAO.getBusinessCardByCreatedByIdAndStatus(userId, status)))));
			} else {

				Response.getInstance().setBody(Blob.valueOf(JSON.serialize(
								new DTOScannedBusinessCard.StatusMessage(
										'By Id of the User, which you specified, were not found any business cards or this User does not exist.'))));
			}
		}

		else if (userId != null && status == null && cardId == null) {

			status = Constants.STATUS_INCOMPLETE;

			if (!ScannedBusinessCardDAO.getBusinessCardByCreatedByIdAndStatus(userId, status).isEmpty()) {
				Response.getInstance().setBody(Blob.valueOf(JSON.serialize(
								new DTOScannedBusinessCard.CardsList(
										ScannedBusinessCardDAO.getBusinessCardByCreatedByIdAndStatus(userId, status)))));
			} else {
				Response.getInstance().setBody(Blob.valueOf(JSON.serialize(
								new DTOScannedBusinessCard.StatusMessage(
										'By Id of the User, which you specified, were not found any business cards or this User does not exist.'))));
			}
		}

		else if (cardId == null) {
			Response.getInstance().setBody(Blob.valueOf(JSON.serialize(new DTOScannedBusinessCard.StatusMessage(
					'Your request is invalid. Please check the URL and method. And train again.',
					Constants.HTTP_STATUS_NOT_FOUND))));
		}

		if (userId == null && status == null && cardId != null) {

			if (!ScannedBusinessCardDAO.getCardByCardId(cardId).isEmpty()) {
				Response.getInstance().setBody(Blob.valueOf(JSON.serialize(
								new DTOScannedBusinessCard.CardItemListFull(
										ScannedBusinessCardDAO.getCardByCardId(cardId)))));
			} else {
				Response.getInstance().setBody(Blob.valueOf(JSON.serialize(
								new DTOScannedBusinessCard.StatusMessage(
										'By Id of the Card, which you specified, were not found any business card.'))));
			}
		}

		else if (userId == null && status == null) {
			Response.getInstance().setBody(Blob.valueOf(JSON.serialize(new DTOScannedBusinessCard.StatusMessage(
							'Your request is invalid. Please check the URL and method. Also make sure that you entered required parameters.' +
							'After that train again.', Constants.HTTP_STATUS_NOT_FOUND))));
		}

	}

	public static void doPost() {

		Scanned_Business_Cards__c result = new Scanned_Business_Cards__c();

		RestRequest req = RestContext.request;

		ScannedBusinessCardDTO data = (ScannedBusinessCardDTO) Request.getInstance().getBodyAsClass(ScannedBusinessCardDTO.class );

		if (data.cardId != null && !GeneralService.isValid(data.cardId, Scanned_Business_Cards__c.sObjectType)) {
			Response.getInstance().setBody(Blob.valueOf(JSON.serialize(new DTOScannedBusinessCard.StatusMessage(
					'Your request is invalid. Make sure that you specified the correct card Id. After that try again.'))));
			return;
		}

		if (data.cardId != null) {
			result = [SELECT Salutation__c,
					First_Name__c, Last_Name__c,
					Full_Name__c, Account_Name__c,
					Title__c, Phone__c,
					Mobile__c, Fax__c,
					Email__c, Website__c,
					Street1__c, Street2__c,
					City__c, State_Country__c,
					Country__c, Postcode__c, Address__c,
					Created_By_Id__c
					FROM Scanned_Business_Cards__c WHERE Id = :data.cardId];

			if (data.salutation != null) {
				result.Salutation__c = data.salutation;
			}
			if (data.firstName != null) {
				result.First_Name__c = data.firstName;
			}
			if (data.lastName != null) {
				result.Last_Name__c = data.lastName;
			}
			if (data.accountName != null) {
				result.Account_Name__c = data.accountName;
			}
			if (data.title != null) {
				result.Title__c = data.title;
			}
			if (data.phone != null) {
				result.Phone__c = data.phone;
			}
			if (data.mobile != null) {
				result.Mobile__c = data.mobile;
			}
			if (data.fax != null) {
				result.Fax__c = data.fax;
			}
			if (data.email != null) {
				result.Email__c = data.email;
			}
			if (data.website != null) {
				result.Website__c = data.website;
			}
			if (data.street1 != null) {
				result.Street1__c = data.street1;
			}
			if (data.street2 != null) {
				result.Street2__c = data.street2;
			}
			if (data.city != null) {
				result.City__c = data.city;
			}
			if (data.stateCountry != null) {
				result.State_Country__c = data.stateCountry;
			}
			if (data.country != null) {
				result.Country__c = data.country;
			}
			if (data.postcode != null) {
				result.Postcode__c = data.postcode;
			}
			if (data.notes != null) {
				result.Notes__c = data.notes;
			}
			if (data.createdById != null) {
				result.Created_By_Id__c = data.createdById;
			}
			if (data.status != null) {
				result.Status__c = data.status;
			}
			if (data.accountId != null) {
				result.Account__c = data.accountId;
			}
			if (data.contactId != null) {
				result.Contact__c = data.contactId;
			}

		} else {
			result.Salutation__c = data.salutation;
			result.First_Name__c = data.firstName;
			result.Last_Name__c = data.lastName;
			result.Account_Name__c = data.accountName;
			result.Title__c = data.title;
			result.Phone__c = data.phone;
			result.Mobile__c = data.mobile;
			result.Fax__c = data.fax;
			result.Email__c = data.email;
			result.Website__c = data.website;
			result.Street1__c = data.street1;
			result.Street2__c = data.street2;
			result.City__c = data.city;
			result.State_Country__c = data.stateCountry;
			result.Country__c = data.country;
			result.Postcode__c = data.postcode;
			result.Notes__c = data.notes;
			result.Created_By_Id__c = data.createdById;
			result.Status__c = data.status;
			result.Account__c = data.accountId;
			result.Contact__c = data.contactId;
		}

		upsert result;

		Response.getInstance().setBody(Blob.valueOf(JSON.serialize(
						new DTOScannedBusinessCard.CardItemListFull(
								ScannedBusinessCardDAO.getCardByCardId(result.Id)
						))));
	}

}