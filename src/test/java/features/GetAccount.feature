@Regression
Feature: Get Account Feature Testing

  Background: Setup test
    Given url BASE_URL
    * def tokenResult = callonce read('GenerateToken.feature')
    And print tokenResult
    * def validToken = "Bearer " + tokenResult.response.token

  Scenario: Testing endpoint /api/accounts/get-account
    Given path "/api/accounts/get-account"
    * def expectedId = 11
    Given param primaryPersonId = expectedId
    Given header Authorization = validToken
    When method get
    Then status 200
    And print response
    And assert response.primaryPerson.id == expectedId


  Scenario: Testing endpoint /api/accounts/get-account with primaryPersonId not exist
    Given path "/api/accounts/get-account"
    * def expectedId = 23423
    Given param primaryPersonId = expectedId
    And header Authorization = validToken
    When method get
    Then status 404
    And print response
    And assert response.httpStatus == "NOT_FOUND"
    And assert response.errorMessage == "Account with id " + expectedId + " not found"
