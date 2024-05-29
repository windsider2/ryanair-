Feature: Booking API tests

  Background:
    * url 'http://127.0.0.1:8900'
    * def DateUtil = Java.type('util.DateUtils')
    * def currentDate = DateUtil.getCurrentDate()
    * def pastDate = DateUtil.getPastDate(12)
    * def futureDate = DateUtil.getFutureDate(3)
    * karate.log("futureDate ", futureDate);


  Scenario Outline: Create a booking and verify the response

    Given path 'booking'
    And request { "date": "<date>", "destination": "<destination>", "origin": "<origin>", "userId": <userId> }
    When method post
    Then status <status>
    And match response == <expectedResponse>

    Examples:
      | date           | destination | origin | userId | status | expectedResponse                                                                                                                                                                                                                          |
      | #(currentDate) | NYC         | KRK    | 1      | 201    | { "date":#(currentDate),"destination":"NYC","id":'#number? _ > 0',"origin":"KRK","userId":1 }                                                                                                                                             |
      # In the given scenario, it appears that the application allows the setting of a late date,
            # such as "2023-05-29", and returns a response code of 201 along with the provided date in the response body.
      | #(pastDate)    | NYC         | KRK    | 1      | 400    | { "date":#(pastDate),"destination":"NYC","id":'#number? _ > 0',"origin":"KRK","userId":1 }                                                                                                                                                |
      | #(currentDate) | null        | KRK    | 3      | 400    | {"errors":[{"location":{"in":"request","name":"body","docPath":"/paths/~1booking/post/requestBody/content/application~1json/schema","path":"/destination"},"message":"must match pattern \"^[A-Z]{3}$\""}],"message":"Validation errors"} |
      | #(currentDate) | NYC         | null   | 4      | 400    | {"errors":[{"location":{"in":"request","name":"body","docPath":"/paths/~1booking/post/requestBody/content/application~1json/schema","path":"/origin"},"message":"must match pattern \"^[A-Z]{3}$\""}],"message":"Validation errors"}      |
      | #(currentDate) | NYC         | KRK    | null   | 400    | {"errors":[{"location":{"in":"request","name":"body","docPath":"/paths/~1booking/post/requestBody/content/application~1json/schema","path":"/userId"},"message":"must be number"}],"message":"Validation errors"}                         |
      | #(futureDate)  | CHI         | ATL    | 1      | 201    | {"date":#(futureDate),"destination":"CHI","id":'#number? _ > 0',"origin":"ATL","userId":1}                                                                                                                                                |


