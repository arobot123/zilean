/* 一键复制按钮 */
function copyText(text) {
    var textArea = document.createElement("input");
    var currentFocus = document.activeElement; 
    document.body.appendChild(textArea);
    textArea.value = text;
    textArea.focus();

    if (textArea.setSelectionRange)
        textArea.setSelectionRange(0, textArea.value.length);
    else
        textArea.select();
    try {
        var flag = document.execCommand("copy");
    }
    catch(eo) {
        var flag = false;
    }
    document.body.removeChild(textArea);
    currentFocus.focus();
    return flag;
}
