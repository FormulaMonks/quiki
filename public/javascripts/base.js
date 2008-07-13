$(function() {
	$('ul#notices li').each(function(i) {
		$.jGrowl($(this).html());
	});
	
	initialize_page_menu();	
	
	$("select#page_parser").change(function() {
		$.getJSON('/parsers/' + $(this).val(), function(json) {
			$("#parser_reference .reference").html(json.html);
			$("#parser_reference h3").html(json.parser);
		});
	});
});

function initialize_page_menu() {
	$('#page_menu ul.pages li.page').draggable({
		handle      : 'span.handle',
		opacity     : '.8',
		revert      : true,
		zIndex      : 100,
		start       : function() {},
		drag        : function() {},
		stop        : function() {}
	});
	
	$('#page_menu li.section a').droppable({
		accept      : '#page_menu ul.pages li.page',
		hoverClass  : 'hover',
		drop        : function(e, ui) {
			form = $('form', ui.draggable);
			$("input[@name='page[section_id]']", form).val(this.id);
			form.get(0).submit();
		}
	});
	
	// custom accordion functionality because the jQuery one was a bit quirky w/
	// the linking and drag/drop
	sections = $("#page_menu ul.sections li.section");
	$("ul.pages", sections).hide();
	$("ul.pages.current", sections).show();
	$("a.section", sections).click(function() {
		$('#page_menu ul.sections li.section ul.pages').hide();
		$('ul.pages', $(this).parents('li.section')).show();
		return false;
	});

	// page path search autocompleter
	pages = new Array();
	$('#page_menu li.page a').each(function(i) {
		pages[i] = $(this).html().replace(/^(.*?)<.*$/, "$1") + '|' + this.href.replace(/^.*:\/\/.*?\/(.+)$/, "$1");
	});
	
	$("#page_menu #page_search").autocomplete(pages, {
		formatItem : function(row, index, total, q) { return row[0].replace(/^(.*)\|.*$/, "$1"); }
	}).result(function(e, data, formatted) {
		location.href = '/' + data[0].replace(/^.*?\|(.*)$/, "$1");
	});
};
