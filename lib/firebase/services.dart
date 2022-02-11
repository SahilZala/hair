class Services
{
  String _service_name = "";
  String _service_type = "";
  String _service_description = "";
  String _service_category = "";
  String _service_gender = "";
  String _online_booking = "";
  String _service_duration = "";
  String _pricing_type = "";
  String _price = "";
  String _discount_available = "";
  String _discount = "";
  String _home_appointment = "";
  String _seat_type = "";


  Services.create(
      this._service_name,
      this._service_type,
      this._service_description,
      this._service_category,
      this._service_gender,
      this._online_booking,
      this._service_duration,
      this._pricing_type,
      this._price,
      this._discount_available,
      this._discount,
      this._home_appointment,
      this._seat_type);


  Services();

  String get service_name => _service_name;

  set service_name(String value) {
    _service_name = value;
  }

  String get service_type => _service_type;

  String get seat_type => _seat_type;

  set seat_type(String value) {
    _seat_type = value;
  }

  String get home_appointment => _home_appointment;

  set home_appointment(String value) {
    _home_appointment = value;
  }

  String get discount => _discount;

  set discount(String value) {
    _discount = value;
  }

  String get discount_available => _discount_available;

  set discount_available(String value) {
    _discount_available = value;
  }

  String get price => _price;

  set price(String value) {
    _price = value;
  }

  String get pricing_type => _pricing_type;

  set pricing_type(String value) {
    _pricing_type = value;
  }

  String get service_duration => _service_duration;

  set service_duration(String value) {
    _service_duration = value;
  }

  String get online_booking => _online_booking;

  set online_booking(String value) {
    _online_booking = value;
  }

  String get service_gender => _service_gender;

  set service_gender(String value) {
    _service_gender = value;
  }

  String get service_category => _service_category;

  set service_category(String value) {
    _service_category = value;
  }

  String get service_description => _service_description;

  set service_description(String value) {
    _service_description = value;
  }

  set service_type(String value) {
    _service_type = value;
  }
}