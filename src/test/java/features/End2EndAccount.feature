@Regression
Feature: End to end account creation

  Background: Setup Test get token
    Given url BASE_URL
    * def tokenResult = callonce read('GenerateToken.feature')
    * def token = "Bearer " + tokenResult.response.token

    @End2End
  Scenario: Create Account end to end
    Given path "/api/accounts/add-primary-account"
    * def dataGenerator = Java.type('data.DataGenerator')
    * def autoEmail = dataGenerator.getEmail();
    * def firstName = dataGenerator.getFirstName();
    And request
    """
    {
  "email": "#(autoEmail)",
  "firstName": "#(firstName)",
  "lastName": "Smith",
  "title": "Mr.",
  "gender": "MALE",
  "maritalStatus": "MARRIED",
  "employmentStatus": "SDET",
  "dateOfBirth": "2023-10-12",
}
    """
    And header Authorization = token
    When method post
    Then status 201
    And print response
      And assert response.email == autoEmail
      * def createdAccountId = response.id
      Given path "/api/accounts/add-account-address"
      And param primaryPersonId = createdAccountId
      And header Authorization = token
      And request
      """
      {
  "addressType": "9873 Windrose Ave",
  "addressLine1": "string",
  "city": "Plano",
  "state": "TExas",
  "postalCode": "23421",
  "countryCode": "string",
  "current": true
}
      """
      When method post
      Then status 201
      And assert response.postalCode == 23421
      Given path "/api/accounts/add-account-car"
      And param primaryPersonId = createdAccountId
      And header Authorization = token
      And request
      """
      {
  "make": "Toyota",
  "model": "X3",
  "year": "2023",
  "licensePlate": "ABC-214"
}
      """
      When method post
      Then status 201
      And assert response.make == "Toyota"
      Given path "/api/accounts/add-account-phone"
      And param primaryPersonId = createdAccountId
      And header Authorization = token
      And request
      """
      {
  "phoneNumber": "1234567809",
  "phoneExtension": "",
  "phoneTime": "Day",
  "phoneType": "Cell"
}
      """
      When method post
      Then status 201
      And assert response.phoneNumber == "1234567809"
      And print createdAccountId
      And print response
      Given path "/api/accounts/delete-account"
      And param primaryPersonId = createdAccountId
      And header Authorization = token
      When method delete
      Then status 200
      And match response == {"status" : true,"httpStatus": "OK", "message": "Account Successfully deleted"}
