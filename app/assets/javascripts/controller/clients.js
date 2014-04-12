onLoad(function() {
  /* Functions */
  function dState(){ if ($("#assignClient").is(":enabled")) $("#assignClient").prop("disabled", true); }

  function eState(enable){
      enable = typeof enable !== 'undefined' ? enable : -1;
      if ($("#assignClient").is(":disabled") && enable != 0)
          $("#assignClient").prop("disabled", false);
  }
  
  function populate(section){
  	if (section != null) {
      $.getJSON("../users/in_section.json?sn=" + section,
          function(json) {
            $("#students").empty();
            if (json.length > 0)
              for (i = 0; i<json.length; i++)
                $("#students").append("<li class='clickable ui-widget-content clicker' value='" + json[i][0]+"'>"+json[i][2]+", "+json[i][1]+" ("+json[i][0]+")</li>");
            else
              $("#students").append("<li id='noAssign' class='clickable ui-widget-content'>"+"There are no students in this section"+"</li>");
          });
      }    	
  }

  var $rows = $('#businessNames tr');
  $('#client_business_name').keyup(function() {
    var val = '^(?=.*\\b' + $.trim($(this).val()).split(/\s+/).join('\\b)(?=.*\\b') + ').*$',
        reg = RegExp(val, 'i'),
        text;

    $rows.show().filter(function() {
        text = $(this).text().replace(/\s+/g, ' ');
        return !reg.test(text);
    }).hide();
  });

  $('#toggleRow').hide();
  $('#client_business_name').focus(function(){ $('#toggleRow').show(); });
  $('.hideClients').focus(function(){ $('#toggleRow').hide(); });   
  
  $(".sectionNum").click( function() {    	
      dState();
      populate($(this).text());
  });

  $("#assignClient").click(function() {
      $("#studentID").val($('#students .ui-selected').attr('value'));
  });

  $(".ui-widget-content").change(function() {
      $("#assignClient").prop("disabled", false);
  });
  
  var priorities = ['high', 'medium', 'low'];
  var index      = 0; 
  var ascFlag    = true;
  var descFlag   = true;  
  
  var priorityArray = {};
  priorityArray['High']   =-1;
  priorityArray['Medium'] = 0;
  priorityArray['Low']    = 1;
  
  function updatePriorityArray(){
    priorityArray['High']   = ((priorityArray['High']   + 2) % 3) - 1;
    priorityArray['Medium'] = ((priorityArray['Medium'] + 2) % 3) - 1;
    priorityArray['Low']    = ((priorityArray['Low']    + 2) % 3) - 1;
  }
  
  overridePrioritySort();
      
  var table =  $('.assign_table').dataTable({
      "aoColumns" : [{ "bSortable": true }, {"sType": "priority" }, null, null, null, null, null, null, null, null, null, null, null],
      "bPaginate" : false,
      "iCookieDuration": 60,
      "bStateSave": false,
      "bAutoWidth": false,
      "bScrollAutoCss": true,
      "bProcessing": true,
      "bRetrieve": true,
      "bJQueryUI": true,
      "sDom": '<"H"CTrf>t<"F"lip>',
      "sScrollXInner": "110%",
      "fnInitComplete": function() {
          this.css("visibility", "visible");
      },
      "fnPreDrawCallback": $(".autoHide").hide()
  }, $(".defaultTooltip").tooltip({
      'selector': '',
      'placement': 'left',
      'container': 'body'
  }));

  $('table.assign_table').each(function(i,table) {
      $('<div style="width: 100%; overflow: auto"></div>').append($(table)).insertAfter($('#' + $(table).attr('id') + '_wrapper div').first());
  });

  /* Actions done on page load */
  table.fnSort( [ [1,'asc'] ] );
	populate($('#currentSection').html());

  //table.fnSort( [ [2,'asc'] ] );
    
  // Creates the list populated by the students as a selectable list.
  $('#students').selectable({
    stop:function(event, ui){
      $(event.target).children('.ui-selected').not(':first').removeClass('ui-selected'); // thanks to http://stackoverflow.com/questions/861668/how-to-prevent-multiple-selection-in-jquery-ui-selectable-plugin
    },
    unselected:function(event, ui){
      dState();
    },
    selected:function(event, ui){
      $.get( "more_allowed?school_id=" + ui["selected"].value + "&priority=" + $('#clientPriority').html(),
        function(data) {
          if (data === "true") {
            $("#studentID").val($('#students .ui-selected').attr('value'));
            eState(ui["selected"].value);
            $('#warnTeacher').empty();
          }
          else {
            dState();
            $('#warnTeacher').html(ui["selected"].innerHTML + " has the maximum number of clients.");
          }
        });
    }
  });

  return table;  
});