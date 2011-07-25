$(document).ready(function() {
  $("#rack-webconsole").hide();
  $(this).keypress(function(event) {
    if (event.which == 96) {
      $("#rack-webconsole").slideToggle('fast', function() {
        if ($(this).is(':visible')) {
          $("#rack-webconsole form input").focus();
          $("#rack-webconsole .results_wrapper").scrollTop(
            $("#rack-webconsole .results").height()
            );
        } else {
          $("#rack-webconsole form input").blur();
        }
      });
      event.preventDefault();
    }
  });
});
$('#rack-webconsole form').submit(function(e){
    e.preventDefault();
});
String.prototype.escapeHTML = function () {
    return(
        this.replace(/&/g,'&amp;').
            replace(/>/g,'&gt;').
            replace(/</g,'&lt;').
            replace(/"/g,'&quot;')
    );
};

$("#rack-webconsole form input").keyup(function(event) {
  if(event.which == 13) {
    /*$.post('/webconsole', $("#rack-webconsole form").serialize());*/
    var query = $("#query").val();
    $.ajax({
      url: '/webconsole',
      type: 'POST',
      dataType: 'json',
      data: ({query: query, token: "TOKEN"}),
      success: function (data) {
        var q = "<div class='query'>>> " + query.escapeHTML() + "</div>";
        var r = "<div class='result'>=> " + data.result.escapeHTML() + "</div>";
        $("#rack-webconsole .results").append(q + r);
        $("#rack-webconsole .results_wrapper").scrollTop(
          $("#rack-webconsole .results").height()
          );
        $("#query").val('');
      }
    });
  }
});
