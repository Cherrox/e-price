class Validators {
  //CORREO O NOMBRE DE USUARIO
  static String? emailUsernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa un correo o nombre de usuario';
    }
    if (value.contains(' ')) {
      return "El correo no debe contener espacios";
    }
    return null;
  }

  // PARA VALIDAR EMAIL
  static String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Ingresa un correo';
    }
    if (!value.contains('@')) {
      return "Tu correo debe tener '@'";
    }
    if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value)) {
      return "Ingrese un correo válido";
    }
    if (value.contains(' ')) {
      return "El correo no debe contener espacios";
    }
    return null;
  }

  //PARA VALIDAR CONTRASEÑA
  static String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    if (value.contains(' ')) {
      return "La contraseña no debe contener espacios";
    }
    return null;
  }

  //PARA VALIDAR NOMBRE DE USUARIO
  static String? validateUsername(String? value) {
    if (value!.isEmpty) {
      return 'El nombre de usuario es obligatorio';
    }
    if (value.contains(' ')) {
      return "El nombre de usuario no debe contener espacios";
    }

    //el nombre de usuario tiene que tener maximo 15 caracteres
    if (value.length > 15) {
      return 'El nombre de usuario debe tener máximo 15 caracteres';
    }

    return null;
  }

  //VALIDAR QUE INGRESE SOLO LINKS validos
  static String? validateLink(String? value) {
    if (value!.isEmpty) {
      return 'Ingresa un link';
    }
    if (!RegExp(
      r"^(http|https):\/\/[a-zA-Z0-9-\.]+\.[a-zA-Z]{2,}$",
    ).hasMatch(value)) {
      return "Ingrese un link válido";
    }
    return null;
  }
   
}
