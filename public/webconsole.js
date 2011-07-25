$(document).ready(function() {
  $("#console").hide();
  $(this).keypress(function(event) {
    if (event.which == 96) {
      $("#console").slideToggle('fast', function() {
        if ($(this).is(':visible')) {
          $("#console form input").focus();
        } else {
          $("#console form input").blur();
        }
      });
      event.preventDefault();
    }
  });
});
$('#console form').submit(function(e){
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

$("#console form input").keyup(function(event) {
  if(event.which == 13) {
    /*$.post('/webconsole', $("#console form").serialize());*/
    var query = $("#query").val();
    $.ajax({
      url: '/webconsole',
      type: 'POST',
      dataType: 'json',
      data: ({query: query}),
      success: function (data) {
        var q = "<div>>> " + query.escapeHTML() + "</div>";
        var o = "<div style='color:green'>" + data.stdout.escapeHTML().replace(/\n/g,"<br>") + "</div>";
        var r = "<div>=> " + data.result.escapeHTML() + "</div>";
        $("#console .results").append(q + o+ r);
        $("#query").val('');
      }
    });
  }
});
