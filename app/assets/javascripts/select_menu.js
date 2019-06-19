$(document).ready(function() {
  select_menu              = $(".select-menu");
  select_menu_modal        = $(".select-menu-modal-holder");
  select_menu_list         = $(".select-menu-list");
  select_menu_list_items   = $(".select-menu-item");
  select_menu_button       = $(".select-menu-button");
  select_menu_close_button = $(".select-menu-close-button");
  selected_option          = $(".select-menu .selected-option");

  select_menu_button.click(function() {
    if (select_menu_button.attr("aria-expanded") === "true") {
      closeSelectMenu();
    } else {
      openSelectMenu();
    }
  });

  select_menu_list_items.click(function(e) {
    let clicked_item = $(e.target).closest(select_menu_list_items);

    selectItem(clicked_item);
    closeSelectMenu();
  });

  select_menu_close_button.click(function(e) {
    closeSelectMenu();
  });

  select_menu.on('ajax:success', function(e, data, status, xhr) {
    return $('#js-menu-container').html(xhr.responseText);
  });

  function selectItem(item) {
    selected_item = select_menu_list.find(".selected");
    if(item === selected_item) return;

    selected_option.text(item.text());
    selected_item.find(".octicon").addClass("v-hidden");
    selected_item.removeClass("selected");

    item.find(".octicon").removeClass("v-hidden");
    item.addClass("selected");
  }

  function openSelectMenu() {
    select_menu_modal.addClass("active");
    select_menu_button.addClass("active");
    select_menu_button.attr("aria-expanded", "true");
  }

  function closeSelectMenu() {
    select_menu_modal.removeClass("active");
    select_menu_button.removeClass("active");
    select_menu_button.attr("aria-expanded", "false");
  }

  $(document).click(function(event) {
    if(select_menu.find(event.target).length < 1) {
      closeSelectMenu();
    }
  });
});
