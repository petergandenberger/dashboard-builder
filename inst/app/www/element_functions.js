function openModal(id) {
  Shiny.setInputValue('open_modal', id, {priority: 'event'});
}
  
function deleteElement(id) {
  Shiny.setInputValue('deleteElement', id, {priority: 'event'});
}
