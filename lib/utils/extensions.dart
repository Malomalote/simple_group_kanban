extension Accents on String {
  String removeAccents() {
    const withAccents =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüŠšŸÿýŽž';
    const withoutAccents =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuSsYyyZz';
    String toReturn = this;
    for (int i = 0; i < withAccents.length; i++) {
      toReturn = toReturn.replaceAll(withAccents[i], withoutAccents[i]);
    }
    return toReturn;
  }
}
