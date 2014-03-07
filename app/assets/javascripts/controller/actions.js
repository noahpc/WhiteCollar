onLoad(function() {
    $(".hidden").hide();


    $("#presentation").click(function () {
        if ($("#presentation").is(':checked'))
        {
            $("#checkers2").removeClass("hidden").show();
        }
        else
        {
            $("#checkers2").addClass("hidden").hide();
            $("#saleMade").hide();
            $("#sale").attr('checked', false);
        }
    });

    $("#sale").click(function () {
        if ($("#sale").is(':checked'))
        {
            $("#saleMade").removeClass("hidden").show();
        }
        else
        {
            $("#saleMade").addClass("hidden").hide();
        }
    });

    $("#comments").click(function () {
        if ($("#comments").is(':checked'))
        {
            $("#justComment").removeClass("hidden").show();
        }
        else
        {
            $("#justComment").addClass("hidden").hide();
        }
    });

    jQuery.validator.addMethod("floating_number", function(value, element) {
        return this.optional(element) || /^(?:\d+|\d{1,3}(?:,\d{3})+)?(?:\.\d+)?$/i.test(value);
    });

    $("#new_foo").validate({
        rules: {
            "price": {min: 1, required: true, floating_number: true },
            "page": {min: .01, required: true },
            "foo[comment]": {required: true},
            "foo[user_action_time]": {required: true, date: true }
            //"action[user_action_time]": {date: true, less_than: Time.now}
        },
        messages: {
            "price": "Please enter a valid price.",
            "page": "Please enter a valid page size.",
            "foo[comment]": "If you have a comment, please enter it.",
            "foo[user_action_time]": "Please enter in when you did this."
        }
    });
});