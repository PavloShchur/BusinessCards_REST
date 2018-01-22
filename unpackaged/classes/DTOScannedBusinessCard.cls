public class DTOScannedBusinessCard {

	public class CardsList {

		public List<CardItem> cardItemList = new List<CardItem>();

		public cardsList(List<Scanned_Business_Cards__c> someList) {

			for (Scanned_Business_Cards__c x :someList) {
				CardItem y = new CardItem(x.Id,
						x.Account_Name__c,
						x.Full_Name__c,
						x.Status__c,
						x.Title__c);
				cardItemList.add(y);
			}
		}
	}

	public class CardItem {

		public String Id;
		public String accountName;
		public String fullName;
		public String status;
		public String title;

		public cardItem(String Id, String accountName, String fullName, String status, String title) {
			this.Id = Id;
			this.accountName = accountName;
			this.fullName = fullName;
			this.status = status;
			this.title = title;
		}
	}


	public class CardsList_2 {

		public List<CardItem_2> cardItemList = new List<CardItem_2>();

		public CardsList_2(List<Scanned_Business_Cards__c> someList) {
			for (Scanned_Business_Cards__c card :someList) {
				CardItem_2 cardItem = new CardItem_2(card.Account__c,
						card.Contact__c);
				cardItemList.add(cardItem);
			}
		}
	}

	public class CardItem_2 {

		public String accountId;
		public String contactId;

		public CardItem_2(String accountId, String contactId) {
			this.accountId = accountId;
			this.contactId = contactId;
		}
	}

	public class StatusMessage {

		public String message;
		public Integer errorCode;
		public String id;

		public StatusMessage(String message){this.message = message;}

		public StatusMessage(String message, Integer errorCode) {
			this.message = message;
			this.errorCode = errorCode;
		}

		public StatusMessage(String message, Integer errorCode, String id) {
			this.message = message;
			this.errorCode = errorCode;
			this.id = id;
		}
	}

	public class CardItemListFull {

		public List<CardItemFull> cardItemList = new List<CardItemFull>();

		public CardItemListFull(List<Scanned_Business_Cards__c> someList) {
			for (Scanned_Business_Cards__c card :someList) {

				CardItemFull cardItem = new CardItemFull(card.Id, card.Salutation__c, card.First_Name__c,
						card.Last_Name__c, card.Account_Name__c,
						card.Title__c, card.Phone__c,
						card.Mobile__c, card.Fax__c, card.Email__c,
						card.Website__c, card.Street1__c, card.Street2__c,
						card.City__c, card.State_Country__c, card.Country__c,
						card.Postcode__c, card.Notes__c, card.Created_By_Id__c,
						card.Status__c
				);
				cardItemList.add(cardItem);
			}
		}
	}


	public class CardItemFull {

		public String cardId;
		public String salutation;
		public String firstName;
		public String lastName;
		public String accountName;
		public String title;
		public String phone;
		public String mobile;
		public String fax;
		public String email;
		public String website;
		public String street1;
		public String street2;
		public String city;
		public String stateCountry;
		public String country;
		public String postcode;
		public String notes;
		public String createdById;
		public String status;

		public CardItemFull( String cardId,
							 String salutation,
							 String firstName,
							 String lastName,
							 String accountName,
							 String title,
							 String phone,
							 String mobile,
							 String fax,
							 String email,
							 String website,
							 String street1,
							 String street2,
							 String city,
							 String stateCountry,
							 String country,
							 String postcode,
							 String notes,
							 String createdById,
							 String status) {

			this.cardId = cardId;
			this.salutation = salutation;
			this.firstName = firstName;
			this.lastName = lastName;
			this.accountName = accountName;
			this.title = title;
			this.phone = phone;
			this.mobile = mobile;
			this.fax = fax;
			this.email = email;
			this.website = website;
			this.street1 = street1;
			this.street2 = street2;
			this.city = city;
			this.stateCountry = stateCountry;
			this.country = country;
			this.postcode = postcode;
			this.notes = notes;
			this.createdById = createdById;
			this.status = status;

		}
	}

}