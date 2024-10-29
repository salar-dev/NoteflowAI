List getLocale(local) {
  List localLang = ['', ''];
  switch (local) {
    case "en_US":
      localLang[0] = "English";
      localLang[1] = "assets/images/usa_circular.png";
      break;
    case "ar_IQ":
      localLang[0] = "العربية";
      localLang[1] = "assets/images/iraq_circular.png";
      break;
    default:
      localLang[0] = "اللغة";
      localLang[1] = "assets/images/iraq_circular.png";
  }
  return localLang;
}
