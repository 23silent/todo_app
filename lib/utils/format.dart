String maybePluralize(int count, String noun, {String suffix = 's'}){
  return '${count.toString()} $noun${count != 1 ? suffix : ''}';
}