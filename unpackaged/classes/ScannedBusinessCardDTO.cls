public class ScannedBusinessCardDTO {
    
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
    public String accountId;
    public String contactId;     
    
    public ScannedBusinessCardDTO ( String cardId, String salutation, String firstName, String lastName, String accountName,
                                   String title, String phone, String mobile, String fax, String email, String website, String street1,
                                   String street2, String city, String stateCountry, String country, String postcode, String notes,
                                   String createdById, String status, String accountId, String contactId) {
                                       
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
                                       this.accountId = accountId;
                                       this.contactId = contactId;                    
                                       
                                   }
    
}