(function($) {

  var webconsole = {
    history:[],
    pointer:0,
    query:$('#webconsole_query')
  };

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

    // enter
    if (event.which == 13) {
      webconsole.history.push(webconsole.query.val());
      webconsole.pointer = webconsole.history.length - 1;
      $.ajax({
        url: '/webconsole',
        type: 'POST',
        dataType: 'json',
        data: ({query: webconsole.query.val(), token: "$TOKEN"}),
        complete: function (jqXHR, textStatus) {
          $("#rack-webconsole .results_wrapper").scrollTop(
            $("#rack-webconsole .results").height()
          );
          webconsole.query.val('');
        },
        error: function (jqXHR, textStatus, errorThrown) {
          var q = "<div class='query'>" + escapeHTML(">> " + webconsole.query.val()) + "</div>";
          var r = "<div class='error-result result'>" + escapeHTML("=> " + jQuery.parseJSON(jqXHR.response).result) + "</div>";
          $("#rack-webconsole .results").append(q + r);
        },
        success: function (data, textStatus, jqXHR) {
          var q = "<div class='query'>" + escapeHTML(">> " + webconsole.query.val()) + "</div>";
          var r = "<div class='result'>" + escapeHTML("=> " + data.result) + "</div>";
          $("#rack-webconsole .results").append(q + r);
        }
      });
    }

    // up
    if (event.which == 38) {
      if (webconsole.pointer < 0) {
        webconsole.query.val('');
      } else {
        if (webconsole.pointer == webconsole.history.length) {
          webconsole.pointer = webconsole.history.length - 1;
        }
        webconsole.query.val(webconsole.history[webconsole.pointer]);
        webconsole.pointer--;
      }
    }

    // down
    if (event.which == 40) {
      if (webconsole.pointer == webconsole.history.length) {
        webconsole.query.val('');
      } else {
        if (webconsole.pointer < 0) {
          webconsole.pointer = 0;
        }
        webconsole.query.val(webconsole.history[webconsole.pointer]);
        webconsole.pointer++;
      }
    }

  });

  $(document).ready(function() {
    $(this).keypress(function(event) {
      if (event.which == $KEY_CODE) {
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
