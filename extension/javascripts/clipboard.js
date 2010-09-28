function copyToClipboard(str) {
  var obj=document.getElementById("copy_holder");
  if( obj ){
    obj.value = str;
    obj.select();
    document.execCommand("copy", false, null);
  }
}