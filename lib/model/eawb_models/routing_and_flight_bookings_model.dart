class RoutingAndFlightBookingsModel {
  // ! 4 - Routing and flight bookings....
  //String routeAndFlightDeparture = "";
  String routeAndFlightTo1 = "";
  String routeAndFlightBy1 = "";
  String routeAndFlightTo2 = "";
  String routeAndFlightBy2 = "";
  String routeAndFlightTo3 = "";
  String routeAndFlightBy3 = "";
  //String routeAndFlightDestination = "";
  String routeAndFlightNumber1 = "";
  String routeAndFlightDate1 = "";
  String routeAndFlightNumber2 = "";
  String routeAndFlightDate2 = "";
  String referenceNumber = "";
  String information = "";
  String airline = "";
  String flight = "";
  String date = "";
  String airline1 = "";
  String flight1 = "";
  String date1 = "";
  int routeAndFlightStatus = 0;

  void clearRoutingAndFlightBookingsModel() {
     this.routeAndFlightBy1 =
        this.routeAndFlightBy2 = this.routeAndFlightBy3 =
            this.routeAndFlightTo1 = this.routeAndFlightTo2 =
                this.routeAndFlightTo3 = this.routeAndFlightNumber1=this.routeAndFlightDate1
                =this.routeAndFlightNumber2 =this.routeAndFlightDate2=
                    
                        this.referenceNumber = this.information = 
                        this.airline = this.flight = this.date = 
                        this.flight1 = this.airline1 = this.date1 = '';
    this.routeAndFlightStatus = 0;
  }

  void setStatusRoutingAndFlightBookingsModel() {
    if (
        routeAndFlightTo1 == "" &&
        routeAndFlightBy1 == "" &&
        routeAndFlightTo2 == "" &&
        routeAndFlightBy2 == "" &&
       
        routeAndFlightNumber1== ""&&
        routeAndFlightDate1=="" &&
        routeAndFlightNumber2 ==""&&
        routeAndFlightDate2=="") {
      routeAndFlightStatus = 0;
    }
   else if (
    routeAndFlightTo1 != "" &&
        routeAndFlightBy1 != ""
    ) {
      routeAndFlightStatus = 1;
    }

    else if (
        routeAndFlightTo1 == "" ||
        routeAndFlightBy1 == "" ||
        routeAndFlightTo2 == "" ||
        routeAndFlightBy2 == "" ||
       
        routeAndFlightNumber1== ""||
        routeAndFlightDate1=="" ||
        routeAndFlightNumber2 ==""||
        routeAndFlightDate2=="") {
      routeAndFlightStatus = -1;
    } else {
      routeAndFlightStatus = 1;
    }
  }
}
