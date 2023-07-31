class IndividualBill {
  IndividualBill({
    required this.message,
    required this.individualBills,
  });
  late final String message;
  late final List<IndividualBills> individualBills;
  
  IndividualBill.fromJson(Map<String, dynamic> json){
    message = json['message'];
    individualBills = List.from(json['individualBills']).map((e)=>IndividualBills.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['individualBills'] = individualBills.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class IndividualBills {
  IndividualBills({
    required this.id,
    required this.subadminid,
    required this.financemanagerid,
    required this.residentid,
    required this.billstartdate,
    required this.billenddate,
    required this.duedate,
    required this.billtype,
    required this.paymenttype,
    required this.status,
    required this.charges,
    required this.latecharges,
    required this.tax,
    required this.balance,
    required this.payableamount,
    required this.totalpaidamount,
    required this.isbilllate,
    required this.createdAt,
    required this.updatedAt,
    required this.billItems,
  });
  late final int id;
  late final int subadminid;
  late final int financemanagerid;
  late final int residentid;
  late final String billstartdate;
  late final String billenddate;
  late final String duedate;
  late final String billtype;
  late final String paymenttype;
  late final String status;
  late final String charges;
  late final String latecharges;
  late final String tax;
  late final String balance;
  late final String payableamount;
  late final String totalpaidamount;
  late final int isbilllate;
  late final String createdAt;
  late final String updatedAt;
  late final List<BillItems> billItems;
  
  IndividualBills.fromJson(Map<String, dynamic> json){
    id = json['id'];
    subadminid = json['subadminid'];
    financemanagerid = json['financemanagerid'];
    residentid = json['residentid'];
    billstartdate = json['billstartdate'];
    billenddate = json['billenddate'];
    duedate = json['duedate'];
    billtype = json['billtype'];
    paymenttype = json['paymenttype'];
    status = json['status'];
    charges = json['charges'];
    latecharges = json['latecharges'];
    tax = json['tax'];
    balance = json['balance'];
    payableamount = json['payableamount'];
    totalpaidamount = json['totalpaidamount'];
    isbilllate = json['isbilllate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    billItems = List.from(json['bill_items']).map((e)=>BillItems.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['subadminid'] = subadminid;
    _data['financemanagerid'] = financemanagerid;
    _data['residentid'] = residentid;
    _data['billstartdate'] = billstartdate;
    _data['billenddate'] = billenddate;
    _data['duedate'] = duedate;
    _data['billtype'] = billtype;
    _data['paymenttype'] = paymenttype;
    _data['status'] = status;
    _data['charges'] = charges;
    _data['latecharges'] = latecharges;
    _data['tax'] = tax;
    _data['balance'] = balance;
    _data['payableamount'] = payableamount;
    _data['totalpaidamount'] = totalpaidamount;
    _data['isbilllate'] = isbilllate;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['bill_items'] = billItems.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class BillItems {
  BillItems({
    required this.id,
    required this.individualbillid,
    required this.billname,
    required this.billprice,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final int individualbillid;
  late final String billname;
  late final String billprice;
  late final String createdAt;
  late final String updatedAt;
  
  BillItems.fromJson(Map<String, dynamic> json){
    id = json['id'];
    individualbillid = json['individualbillid'];
    billname = json['billname'];
    billprice = json['billprice'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['individualbillid'] = individualbillid;
    _data['billname'] = billname;
    _data['billprice'] = billprice;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}