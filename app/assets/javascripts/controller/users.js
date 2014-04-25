//*********************************************************************************************************************/
// User.js - everything needs to be wrapped in the onLoad function due to Turbolinks
//*********************************************************************************************************************/
onLoad(function() {

//*********************************************************************************************************************/
// Students - /users
//*********************************************************************************************************************/
    
    // Choose Action dropdown
    $( "#show_managers" ).hide();
    $("#parse_box").hide();
    $( "#assign_bonus_points" ).hide();
    $( "#option" ).click(
        function( event) {
            event.preventDefault();
            var e = document.getElementById("selected_option");  
            var strUser = e.options[e.selectedIndex].text;
            if (strUser=="Promote Student")
            {
                $( "#show_managers" ).hide();
                $( "#assign_bonus_points" ).hide();
                $('.student_managers').attr('checked', false);
                $('.student_managers').attr('disabled', true);
                $('.students_with_manager').attr('disabled', false);
                $('.students_without_manager').attr('disabled', false);
            }            
            else if (strUser=="Demote Student")
            {
                $( "#show_managers" ).hide();
                $( "#assign_bonus_points" ).hide();
                $('.student_managers').attr('disabled', false);
                $('.students_without_manager').attr('checked', false);
                $('.students_with_manager').attr('checked', false);
                $('.students_with_manager').attr('disabled', true);
                $('.students_without_manager').attr('disabled', true);
            }
            else if (strUser=="Add to Team")
            {
                $( "#show_managers" ).show();
                $( "#assign_bonus_points" ).hide();
                $('.student_managers').attr('checked', false);
                $('.student_managers').attr('disabled', true);
                $('.students_with_manager').attr('checked', false);
                $('.students_with_manager').attr('disabled', true);
                $('.students_without_manager').attr('disabled', false);
            }
            else if (strUser=="Remove from Team")
            {
                $( "#show_managers" ).hide();
                $( "#assign_bonus_points" ).hide();
                $('.student_managers').attr('checked', false);
                $('.student_managers').attr('disabled', true);
                $('.students_without_manager').attr('checked', false);
                $('.students_with_manager').attr('disabled', false);
                $('.students_without_manager').attr('disabled', true);
            }
            else if (strUser=="Assign Bonus Points")
            {
                $( "#show_managers" ).hide();
                $( "#assign_bonus_points" ).show();
                $('.student_managers').attr('disabled', false);
                $('.students_with_manager').attr('disabled', false);
                $('.students_without_manager').attr('disabled', false);
            }
            else
            {
                $( "#show_managers" ).hide();
                $( "#assign_bonus_points" ).hide();
                $('.student_managers').attr('disabled', false);
                $('.students_with_manager').attr('disabled', false);
                $('.students_without_manager').attr('disabled', false);
            }
        }
    );

//*********************************************************************************************************************/
// Teachers Page - teachers.html.erb
//*********************************************************************************************************************/
    
    $("#Change_Teacher").hide();
    $("#New_Teacher").hide();

    $(".Change_Teacher_Link").click(
        function(caller) {

            if ($("#Change_Teacher").is(":hidden") ){
                $("#New_Teacher").hide();
                $("#Change_Teacher").show();
            }

            console.log(
                $("#" + caller.target.id).attr("name")
            );

            $("#oldTeacher").html( $("#" + caller.target.id).attr("name") );
            $("#memberId").val( $("#" + caller.target.id).attr("value") );
        });


    $(".New_Teacher_Link").click(
        function(caller) {

            if ($("#New_Teacher").is(":hidden") ){
                $("#Change_Teacher").hide();
                $("#New_Teacher").show();
            }

            console.log(
                $("#" + caller.target.id).attr("name")
            );

            $("#sectionNumber").html( $("#" + caller.target.id).attr("name") );
            $("#section").val( $("#" + caller.target.id).attr("name") );
        });

    // Stripped-down version of the datatables for the teacher tables
	onLoad(function () {
        var table = $('.teacher_table').dataTable({
            "bPaginate": false,
            "bFilter": false,
            "iCookieDuration": 60,
            "bStateSave": false,
            "bAutoWidth": false,
            "bInfo": false,
            "bProcessing": true,
            "bRetrieve": true,
            "bJQueryUI": true,
        });
    });
//*********************************************************************************************************************/
// User Help Page - users/need_help
//*********************************************************************************************************************/
  	
  	$( "div.help_accordion" ).accordion({
  		header: "> h3:not(.item)",
   		collapsible: true,
   		autoHeight: false,
		heightStyle: "content",
		active: false
   	});

//*********************************************************************************************************************/
// New Student - users/new
//*********************************************************************************************************************/
    
    // Shows and hides the box for the input from excel
    $(function() {
        $("#paste").click(
            function() {
                $("#parse_box").toggle();
            });
    });
    
    // Inform teacher that the student already exists in the database
    	$("#user_school_id").blur(function() {
    		var student_id = $("#user_school_id").val();
    	 	$.ajax({
    	 		url: "duplicate_student",
    	 		data: {student: student_id},
    	 		type:"POST"
    	 	});
    	});   		
    
    
//*********************************************************************************************************************/
// New Student Validation - users/new
//*********************************************************************************************************************/
    
    // Custom method to make sure only letters are entered
    jQuery.validator.addMethod("letters_only", function(value, element) {
        return this.optional(element) || /^[-a-zA-Z\s ?()'\/&-\.;:]+$/i.test(value);
    });

	// Custom method to make sure the email is a valid PCC email address
    jQuery.validator.addMethod("valid_email", function(value, element) {
        return this.optional(element) || /^(([0-9a-zA-Z]+)@(students.pcci.edu|faculty.pcci.edu|STUDENTS.PCCI.EDU|FACULTY.PCCI.EDU))$/i.test(value);
    });
    
    // Custom method to make sure the school ID is not all zeros
    jQuery.validator.addMethod('valid_id', function (value, element) {
        return this.optional(element) || /^([-a-zA-Z0-9]+)$/i.test(value);
    });
    
    // Custom method to make sure a number does not start with a zero
    jQuery.validator.addMethod("leading_zero", function(value, element) {
        return this.optional(element) || /^([1-9]+(\d)*|[-a-zA-Z1-9]+)$/.test(value);
    });

    // Custom method to make sure the telephone is valid
    jQuery.validator.addMethod("valid_telephone", function(value, element) {
        return this.optional(element) || /^(([tT][oO][wW][nN])|(((17)\s*[-]\s*)?(\d{4})\s*[-]\s*([1-4]{1}))*|(((([(])?[1-9][0-9][0-9]([)])?)?\s*([-])?\s*)?([1-9][0-9][0-9])\s*([-])?\s*(\d{4})\s*))$/.test(value);
    });
    
    $("#users").validate({
        rules: {
            "user[first_name]": {required:     true, letters_only:    true,  maxlength:    30},
            "user[last_name]":  {required:     true, letters_only:    true,  maxlength:    30},
            "user[email]":      {required:     true, valid_email:     true,  email:        true, maxlength: 35},
            "user[school_id]":  {required:     true, valid_id:        true,  leading_zero: true, maxlength: 30},
            "user[box]":        {digits:       true, rangelength:     [3,4], min:          1},
            "user[phone]":      {required:     true, valid_telephone: true},
            "user[major]":      {letters_only: true, maxlength:       75},
            "user[minor]":      {letters_only: true, maxlength:       75}
        },
        messages: {
            "user[first_name]": {
            	required: 	  	 "Please enter the user's first name.",
            	letters_only: 	 "Will only accept letters and punctuation.",
              	maxlength:    	 "The maximum length for a first name is 30 characters."
            },
            "user[last_name]": {
            	required: 	  	 "Please enter the user's last name.",
            	letters_only: 	 "Will only accept letters and punctuation.",
			    maxlength:    	 "The maximum length for a last name is 30 characters."
            },
            "user[school_id]": {
            	required: 	 	 "Please enter the user's school ID.",
            	valid_id:        "Please enter a valid school ID (123456 or jsmith).",
            	leading_zero:    "School ID cannot start with a zero.",
            	maxlength:       "The maximum length for a school ID is 30 characters."
            },
            "user[email]": {
            	required: 	 	 "Please enter the user's PCC email address.",
            	valid_email: 	 "Email must be a valid PCC email address (@students.pcci.edu or @faculty.pcci.edu).",
              	maxlength:   	 "The maximum length for an email is 35 characters."
            },
            "user[phone]": {
            	required: 		 "Please enter the student's PCC phone.",
            	valid_telephone: "Can either be 17-####-# (with last # of numbers 1-4), Town, or standard phone number."
            },
            "user[box]": {
            	digits: 	 	 "Can only be digits (numbers 0-9).",
            	min: 		 	 "Cannot be all zeros.",
            	rangelength: 	 "Can only be a range of 3-4 digits long."
            },
            "user[major]": {
      			letters_only: 	 "Will only accept letters and punctuation.",
      			maxlength:    	 "The maximum length for a major is 75 characters."
		    },
            "user[minor]": {
      			letters_only: 	 "Will only accept letters and punctuation.",
      			maxlength:    	 "The maximum length for a minor is 75 characters."
		    }
        }
    });
    
//*********************************************************************************************************************/
// Bonuses Front-Side Validation
//*********************************************************************************************************************/
	
	// Custom validation to make sure the bonus points number is in a valid format
	jQuery.validator.addMethod("valid_bonus", function(value, element) {
        return this.optional(element) || /^(\d{0,3})$/.test(value);
    });
	
	$("#student_options").validate({
		rules: {
			"bonus_points":  {required:  true, min: 1, max: 100, valid_bonus: true, leading_zero: true},
			"bonus_comment": {maxlength: 250}
		},
		messages: {
			"bonus_points": {
				required:     "Please enter the amount of bonus points.",
				min:          "Cannot be less than 1.",
				max:          "The maximum amount of bonus points is 100.",
				valid_bonus:  "Can only be a number from 1-100 (no decimal values).",
				leading_zero: "Cannot begin with zero."
			}
		}
	});
});
