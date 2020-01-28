//TODO - Make the list of Flight, Accomodation, Transport and Event Booking types more configurable vs in a hard coded query
global class tth_NBA_Generate_TripDisruption {

  global class TripDisruptionInputs {
    @InvocableVariable(label='Traveler Contact ID' description='Traveler ID, if person account use PersonContact.ID' required=true)
    global String travelerContactId;

    @InvocableVariable(label='Trip ID' description='Which trip ID to base booking types from?' required=true)
    global String tripId;
  }

  @InvocableMethod(label='Get Trip Disruption Recommendations'
                     description='Return appropriate Recommendations based on what has been booked on the trip')

   global static List<List<Recommendation>> getTripDisruptionRecommendations(List<TripDisruptionInputs> travelerInfo){
      List<List<Recommendation>> returnedRecList = new List<List<Recommendation>>();
      List<Recommendation> recommendations = new List<Recommendation>();
      List<tth_Booking__c> bookings;

      for (TripDisruptionInputs inputVariables : travelerInfo) {
        try {
          bookings = [SELECT ID, tth_Booking_Type__c FROM tth_Booking__c where tth_Trip__c = :inputVariables.tripId AND tth_Rebooking_Required__c = true];
          System.debug('**** for Trip ' + inputVariables.tripId + ' Found bookings: ' + bookings);
          for(tth_Booking__c curBooking : bookings) {

            System.debug('****** Booking ' + curBooking.ID + ' and Type: ' + curBooking.tth_Booking_Type__c);

            if (curBooking.tth_Booking_Type__c == 'Flight') {
              recommendations.addAll(getFlightRecommendations());

            } else if (curBooking.tth_Booking_Type__c == 'Hotel' || curBooking.tth_Booking_Type__c == 'Accomodation') {
              recommendations.addAll(getAccomRecommendations());

            } else if (curBooking.tth_Booking_Type__c == 'Transport' ||
                        curBooking.tth_Booking_Type__c == 'Bus' ||
                        curBooking.tth_Booking_Type__c == 'Ferry' ||
                        curBooking.tth_Booking_Type__c == 'Rail' ||
                        curBooking.tth_Booking_Type__c == 'Car') {

               recommendations.addAll(getTransportRecommendations());

            } else {
              recommendations.addAll(getEventRecommendations());
            }
          }
       } catch (Exception ex){
          //System.debug('No bookings found for trip ' + inputVariables.tripId);
          //recommendations = new List<Recommendation>();
        }
        returnedRecList.add(recommendations);

      }
      return returnedRecList;
   }


   private static List<Recommendation> getFlightRecommendations() {
     //category__c = RebookFlight
     return getRecommendationsForCategory('RebookFlight');
   }

   private static List<Recommendation> getAccomRecommendations() {
     //category__c = RebookAccomodation
     return getRecommendationsForCategory('RebookAccomodation');
   }

   private static List<Recommendation> getTransportRecommendations() {
     //category__c = RebookTransport
     return getRecommendationsForCategory('RebookTransport');
   }

   private static List<Recommendation> getEventRecommendations() {
     //category__c = RebookEvent
     return getRecommendationsForCategory('RebookEvent');
   }


   private static List<Recommendation> getRecommendationsForCategory(String category) {
     List<Recommendation> recs;
     try {
        recs = [SELECT ID, Name, Description, ActionReference, AcceptanceLabel, RejectionLabel, ImageId, tth_Trip_stage__c, tth_Trip_Sub_stage__c FROM Recommendation WHERE category__c = :category];
        System.debug('Found some ' + category + ' recs: ' + recs);
     } catch (Exception ex) {
       System.debug('No Recommendation found for category ' + category);
        recs = new List<Recommendation>();
     }
     return recs;
   }

}
