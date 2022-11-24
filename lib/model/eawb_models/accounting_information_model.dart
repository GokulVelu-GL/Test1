class AccountingInformationModel {
  // ! 7 - Accounting information....
  String accountingInformationDetails = "";
  String accountingInformationId ="";
  int accountingInformationStatus = 0;
  int accountingInformationIdStatus = 0;
  void clearAccountingInformationModel() {
    this.accountingInformationDetails = '';
    this.accountingInformationId ="";
    this.accountingInformationStatus = 0;
    this.accountingInformationIdStatus = 0;

  }

  void setStatusAccountingInformationModel() {
    if (accountingInformationDetails == ""&& accountingInformationId =="") {
      accountingInformationStatus = 0;
      accountingInformationIdStatus = 0;
    }

   else if (accountingInformationDetails != ""|| accountingInformationId !="") {
      accountingInformationStatus = 2;
      accountingInformationIdStatus = 2;

    }  else if (accountingInformationDetails == ""|| accountingInformationId =="") {
      accountingInformationStatus = -1;
      accountingInformationIdStatus = -1;

    }


    else {
      accountingInformationStatus = 1;
      accountingInformationIdStatus = 1;
    }
  }
}
