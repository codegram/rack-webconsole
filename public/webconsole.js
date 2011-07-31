(function($) {
  $('#rack-webconsole form').submit(function(e){
    e.preventDefault();
  });

  $("#rack-webconsole form input").keyup(function(event) {
    function escapeHTML(string) {
      return(string.replace(/&/g,'&amp;').
        replace(/>/g,'&gt;').
        replace(/</g,'&lt;').
        replace(/"/g,'&quot;')
      );
    };

    if (event.which == 13) {
      /*$.post('/webconsole', $("#rack-webconsole form").serialize());*/
      var query = $("#webconsole_query").val();
      $.ajax({
        url: '/webconsole',
        type: 'POST',
        dataType: 'json',
        data: ({query: query, token: "TOKEN"}),
        success: function (data) {
          var q = "<div class='query'>" + escapeHTML(">> " + query) + "</div>";
          var r = "<div class='result'>" + escapeHTML("=> " + data.result) + "</div>";
          $("#rack-webconsole .results").append(q + r);
          $("#rack-webconsole .results_wrapper").scrollTop(
            $("#rack-webconsole .results").height()
          );
          $("#webconsole_query").val('');
        }
      });
    }
  });

  $(document).ready(function() {
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
})(jQuery);
