//*********************************************************************************************************************/
// Projects.js - Everything must be wrapped in the onLoad function to handle Turbolinks
//*********************************************************************************************************************/

onLoad(function () {

//*********************************************************************************************************************/
// Projects New/Edit Page
//*********************************************************************************************************************/
    
    // Show/hide the comment area for archiving projects
    $('.hidden').hide();
    
    $('#project_is_active_0').change(
    
    function show_comment_div() {
    	if ($('#project_is_active_0').is(':checked'))
    	   $('#finalComments').removeClass('hidden').show();
    	else
    	   $('#finalComments').addClass('hidden').hide();
    });
    
    $('#project_is_active_1').change(
    
    function show_comment_div() {
    	if ($('#project_is_active_0').is(':checked'))
    	   $('#finalComments').removeClass('hidden').show();
    	else
    	   $('#finalComments').addClass('hidden').hide();
    });

    // Code for the ticket start and end times datepickers
    $('#project_tickets_open_time').datetimepicker({ dateFormat: "yy/mm/dd", timeFormat: "hh:mm TT"});
    $('#project_tickets_close_time').datetimepicker({ dateFormat: "yy/mm/dd", timeFormat: "hh:mm TT" });


    // These three code blocks make the priorities choices logical
    $('#project_max_clients').change(function (s) {
        var high = $('#project_max_high_priority_clients')[0];
        var medium = $('#project_max_medium_priority_clients')[0];
        var low = $('#project_max_low_priority_clients')[0];
        var selected_index = s.target.selectedIndex;
        if (selected_index > 0) {
            high.selectedIndex = Math.min(high.selectedIndex, selected_index);
            medium.selectedIndex = Math.min(medium.selectedIndex, selected_index);
            low.selectedIndex = Math.min(low.selectedIndex, selected_index);
        }
    });

    function update_project_max_clients(s) {
        var clients = $('#project_max_clients')[0];
        var selected_index = clients.selectedIndex;
        if (selected_index > 0) {
            clients.selectedIndex = Math.max(selected_index, s.target.selectedIndex);
        }
    }
    $('#project_max_high_priority_clients').change(update_project_max_clients);

    $('#project_max_medium_priority_clients').change(update_project_max_clients);
    $('#project_max_low_priority_clients').change(update_project_max_clients);
    
    // Hide the loading icon at first, but show it when submit is clicked
    $('#loading').hide();
    
    $('#submitButton').click(function(){
      $('#loading').show();
      $(this).hide();
    });

//*********************************************************************************************************************/
// Projects New/Edit Page Front-Side Validation
//*********************************************************************************************************************/

	// Custom validation to make sure the datetime format matches what we need
    jQuery.validator.addMethod('valid_date_format', function (value, element) {
        return this.optional(element) ||
            /^(\d{4}[/]\d{2}[/]\d{2}\s\d{2}[:]\d{2}\s(([aA]|[pP])[mM]))$/i.test(value);
    });

    // Custom validation to make sure the year format matches what we need
    jQuery.validator.addMethod('valid_year', function (value, element) {
        return this.optional(element) ||
            /^([2-9]\d{3}[/]\d{2}[/]\d{2}\s\d{2}[:]\d{2}\s(([aA]|[pP])[mM]))$/i.test(value);
    });

    // Custom validation to make sure the month format matches what we need
    jQuery.validator.addMethod('valid_month', function (value, element) {
        return this.optional(element) ||
            /^(\d{4}[/]((1[0-2])|([0][1-9]))[/]\d{2}\s\d{2}[:]\d{2}\s(([aA]|[pP])[mM]))$/i.test(value);
    });

    // Custom validation to make sure the day format matches what we need
    jQuery.validator.addMethod('valid_day', function (value, element) {
        return this.optional(element) ||
            /^(\d{4}[/]\d{2}[/](([0][1-9])|([1-2][0-9])|(3[0-1]))\s\d{2}[:]\d{2}\s(([aA]|[pP])[mM]))$/i.test(value);
    });

	// Custom validation to make sure the month entered matches the fall semester
    jQuery.validator.addMethod('fall', function (value, element) {
        return this.optional(element) ||
            /^(\d{4}[/](([0][9]|1[0-2]))[/]\d{2}\s\d{2}[:]\d{2}\s(([aA]|[pP])[mM]))$/i.test(value);
    });
    
    // Custom validation to make sure the month entered matches the spring semester
    jQuery.validator.addMethod('spring', function (value, element) {
        return this.optional(element) ||
            /^(\d{4}[/][0][1-5][/]\d{2}\s\d{2}[:]\d{2}\s(([aA]|[pP])[mM]))$/i.test(value);
    });
    
	// Validation for a project
	$("#projects").validate({
		rules:{
			"project[tickets_open_time]": {required: true, date: true, valid_date_format: true, valid_year: true, valid_month: true, valid_day: true, fall: {
				depends: function(element) {
					return $('[name="project[semester]"]').val() == "Fall";
				}
			}, spring: {
				depends: function(element) {
					return $('[name="project[semester]"]').val() == "Spring";
				}
			}},
			"project[tickets_close_time]": {required: true, date: true, valid_date_format: true, valid_year: true, valid_month: true, valid_day: true, fall: {
		    	depends: function(element) {
					return $('[name="project[semester]"]').val() == "Fall";
				}
			}, spring: {
				depends: function(element) {
					return $('[name="project[semester]"]').val() == "Spring";
				}
			}}
		},
		messages:{
			"project[tickets_open_time]": {
				required: "Please enter in the date and time when you did this.",
                date: "The date is incorrect.",
                valid_date_format: "Should match format YYYY/MM/DD HH:MM AM/PM.",
                valid_year: "Please select a year after 2000.",
                valid_month: "Please select a valid month.",
                valid_day: "Please select a valid day.",
                fall: "Month needs to be in the Fall (09 - 12).",
                spring: "Month needs to be in the Spring (01 - 05)."
			},
			"project[tickets_close_time]": {
				required: "Please enter in the date and time when you did this.",
                date: "The date is incorrect.",
                valid_date_format: "Should match format YYYY/MM/DD HH:MM AM/PM.",
                valid_year: "Please select a year after 2000.",
                valid_month: "Please select a valid month.",
                valid_day: "Please select a valid day.",
                fall: "Month needs to be in the Fall (09 - 12).",
                spring: "Month needs to be in the Spring (01 - 05)."
			}
		}
	});
});
