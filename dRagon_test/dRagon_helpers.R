dRagonBox <- function(content, content_dropdown, w = 2, h = 2) {
  paste0(
    div(
      div(
        a(icon(name = "cog"), class = "trigger_popup_fricc"),
        div(content_dropdown, class = "dR_popup"),
        class = "dropdown"
      ),
      div("Title"),
      a(icon(name = "times"), style = "float:right;padding-right: 3px;", onclick = "deleteGridStackItem(this)")
    ),

    content
  )
}


