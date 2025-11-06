class TValidator {
  // Method to validate empty text fields
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null; // Return null if the text is valid
  }

  // Regular expression for validating email addresses
  static final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$',
  );

  // Method to validate email addresses
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null; // Return null if the email is valid
  }

  // Method to validate passwords
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null; // Return null if the password is valid
  }

  // Method to validate phone numbers
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Regular expression pattern to validate a phone number
    final RegExp phoneRegExp = RegExp(r'^\+?[\d\s]{3,}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null; // Return null if the phone number is valid
  }

  // Method to validate pin codes
  static String? validatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pincode is required';
    }
    if (value.length != 6) {
      return 'Enter a valid 6-digit pincode';
    }
    return null; // Return null if the pincode is valid
  }

  // Method to validate names
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null; // Return null if the name is valid
  }

  // Method to validate addresses
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    return null; // Return null if the address is valid
  }

  // Method to validate cities
  static String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'City is required';
    }
    return null; // Return null if the city is valid
  }

  // Method to validate states
  static String? validateState(String? value) {
    if (value == null || value.isEmpty) {
      return 'State is required';
    }
    return null; // Return null if the state is valid
  }

  // Method to validate countries
  static String? validateCountry(String? value) {
    if (value == null || value.isEmpty) {
      return 'Country is required';
    }
    return null; // Return null if the country is valid
  }
}
