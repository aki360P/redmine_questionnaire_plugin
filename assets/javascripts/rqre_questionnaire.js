jQuery(document).ready(function($) {
    // end_date
	var end_date = document.getElementById('rqre_end').innerHTML;
	    end_date = new Date(end_date);
	var today = new Date();
	if (end_date <= today ) {  
		var input_fields = document.getElementsByName('answer');
		input_fields.forEach(function(elm,i){
		elm.setAttribute("disabled", true);
		});
	}


	// send answer ajax
    $('input[name="answer"]').change(function() {
		var formData = $(this).parent().parent().serialize(); // get form data
  
		//merge answer data in check_box_tag
		if ($(this).attr('type') == 'checkbox') {
		  var vals = [];
		  $(this).parent().children("input:checkbox").each(function(index, elm){
			if (elm.checked == true){
			  vals.push(elm.value);
			}
		  });
  
		  //console.log(vals);
  
		  formData = formData.substring(0,formData.indexOf("&answer="))
		  formData = formData + "&answer=" + vals;
		}
  
		event.preventDefault(); // cancellation form POST
  
			  $.ajax({
				  type : "POST",
				  url  : location.href + "/vote",
				  data : formData,
				  dataType : "text"
			  })
	  });


	// open modal
    $('#rqre_confirm').click(function() {
		event.preventDefault();

	    $('.rqre_saveModal').dialog({
			title : "Vote Confirm",
			modal : true,
			resizable : false,
			draggable : true,
			width : 450,
			show : 'blind',
			hide : 'explode'
	    });
	    $('.rqre_saveModal').dialog('open');

        questionnaire_confirm();
    });

    var questionnaire_confirm = function(){
		var url = location.href + "/confirm";
		console.log("ajax url" + url);
		$.ajax({
			type : "GET",
			url  : url,
			dataType : "json"
		})
		.done(function(res) {
		  console.log("done");
		  console.log(res);

		  $('#rqre_saveModal_ajax').html("");
		  for (let i=0; i<res.length; i++) {
			var str = "<p>question_id=" + res[i].rqre_question_id + ", answer=" + res[i].answer +"</p>";			
			$('#rqre_saveModal_ajax').append(str);
			}

		})
		.fail(function() {
		  console.log("fail");
		});
	};

}); 
