document.write("<script type='text/javascript' src='js/libs/load.js'></script>")

/* 设置网页标题 */
var html_doc_title = "HTML Document Title";



document.getElementById("js-html-doc-title").innerHTML = html_doc_title;

/*根据textarea内容大小自动调整高度*/
function BodyOnLoad() {
    var textArea = document.getElementById("textarea");
    textArea.style.posHeight = textArea.scrollHeight;
    textArea.style.height = textArea.scrollHeight;
}


/* 弹窗提示helloWorld */
(function(){
  "use strict";
  /* Start of your code */
  function greetMe(yourName) {
    alert('Hello ' + yourName);
  }

  greetMe('World');
  /* End of your code */
})();
