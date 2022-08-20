function openModal(id, ns) {
  Shiny.setInputValue(ns + 'element_edit', id, {priority: 'event'});
}

function deleteElement(id, ns) {
  Shiny.setInputValue(ns + 'element_delete', id, {priority: 'event'});
}
