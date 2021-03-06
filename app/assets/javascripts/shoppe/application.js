//= require jquery
//= require jquery_ujs
//= require shoppe/mousetrap
//= require shoppe/jquery_ui
//= require bootstrap/dist/js/bootstrap.min
//= require shoppe/chosen.jquery
//= require nifty/dialog
//= require_tree .

$(function() {
  $('input.focus').focus();
  $('a[rel=searchOrders]').on('click', function() {
    return $('div.orderSearch').toggle();
  });
  $('a[rel=searchCustomers]').on('click', function() {
    return $('div.customerSearch').toggle();
  });
  $('a[data-behavior=addAttributeToAttributesTable]').on('click', function() {
    var table, template;
    table = $('table.productAttributes');
    if ($('tbody tr', table).length === 1 || $('tbody tr:last td:first input', table).val().length > 0) {
      template = $('tr.template', table).html();
      table.append("<tr>" + template + "</tr>");
    }
    return false;
  });
  $('table.productAttributes tbody').on('click', 'tr td.remove a', function() {
    $(this).parents('tr').remove();
    return false;
  });
  $('table.productAttributes tbody').sortable({
    axis: 'y',
    handle: '.handle',
    cursor: 'move',
    helper: function(e, tr) {
      var helper, originals;
      originals = tr.children();
      helper = tr.clone();
      helper.children().each(function(index) {
        return $(this).width(originals.eq(index).width());
      });
      return helper;
    }
  });
  $('a[data-behavior=addAttachmentToExtraAttachments]').on('click', function(event) {
    event.preventDefault();
    $('div.extraAttachments').show();
    return $(this).hide();
  });
  $('select.chosen').chosen();
  $('select.chosen-with-deselect').chosen({
    allow_single_deselect: true
  });
  $('select.chosen-basic').chosen({
    disable_search_threshold: 100
  });
  $('a[rel=print]').on('click', function() {
    window.open($(this).attr('href'), 'despatchnote', 'width=700,height=800');
    return false;
  });
  $('body').on('click', 'a[rel=closeDialog]', Nifty.Dialog.closeTopDialog);
  $('a[rel=dialog]').on('click', function() {
    var element, options;
    element = $(this);
    options = {};
    if (element.data('dialog-width')) {
      options.width = element.data('dialog-width');
    }
    if (element.data('dialog-offset')) {
      options.offset = element.data('dialog-offset');
    }
    if (element.data('dialog-behavior')) {
      options.behavior = element.data('dialog-behavior');
    }
    options.id = 'ajax';
    options.url = element.attr('href');
    Nifty.Dialog.open(options);
    return false;
  });
  $('div.moneyInput input').each(formatMoneyField);
  return $('body').on('blur', 'div.moneyInput input', formatMoneyField);
});

window.formatMoneyField = function() {
  var value;
  value = $(this).val().replace(/,/, "");
  if (value.length) {
    return $(this).val(parseFloat(value).toFixed(2));
  }
};

Nifty.Dialog.addBehavior({
  name: 'stockLevelAdjustments',
  onLoad: function(dialog, options) {
    $('input[type=text]:first', dialog).focus();
    $(dialog).on('submit', 'form', function() {
      var form;
      form = $(this);
      $.ajax({
        url: form.attr('action'),
        method: 'POST',
        data: form.serialize(),
        dataType: 'text',
        success: function(data) {
          $('div.table', dialog).replaceWith(data);
          return $('input[type=text]:first', dialog).focus();
        },
        error: function(xhr) {
          if (xhr.status === 422) {
            return alert(xhr.responseText);
          } else {
            return alert('An error occurred while saving the stock level.');
          }
        }
      });
      return false;
    });
    return $(dialog).on('click', 'nav.pagination a', function() {
      $.ajax({
        url: $(this).attr('href'),
        success: function(data) {
          return $('div.table', dialog).replaceWith(data);
        }
      });
      return false;
    });
  }
});

Mousetrap.stopCallback = function() {
  return false;
};

Mousetrap.bind('escape', function() {
  Nifty.Dialog.closeTopDialog();
  return false;
});

// ---
// generated by coffee-script 1.9.2

