// This is optional for MySQL, but good for schema documentation
class Location {
    constructor(latitude, longitude, address) {
      this.latitude = latitude;
      this.longitude = longitude;
      this.address = address;
    }
  }
  
  module.exports = Location;