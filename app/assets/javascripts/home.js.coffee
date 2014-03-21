$ ->
  #auto complete plugin for IMDB
  $("#k").autocomplete(
    minLength: 0
    delay: 5
    source: "suggest.json"
    focus: (event, ui) ->
      $(this).val ui.item.label
      false
    select: (event, ui) ->
      $(this).val ui.item.label
      false
  ).data("uiAutocomplete")
    ._renderItem = (ul, item) ->
      $("<li></li>")
        .data("item.autocomplete", item)
        .append("<a>" + ((if item.img then "<img class='imdbImage' src='/proxy_img?url=" +
          item.img + "' />" else "")) +
          "<span class='imdbTitle'>" + item.label + "</span>" +
          ((if item.cast then "<br /><sp   ↪an class='imdbCast'>" +
          item.cast + "</span>" else "")) +
          "<div class='clear'></div></a>").appendTo ul
