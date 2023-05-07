//jQuery(document).ready(function($) {
document.addEventListener("DOMContentLoaded", function(){
	var dtype = document.getElementById('rqre_question_dtype');
	var input = document.getElementById('rqre_question_option');
	var btn = document.getElementById('rqre_btn');

    //display none except checkbox, select
	function css_display(){
		if (dtype.value == "checkbox" || dtype.value == "select") {
			input.parentNode.classList.remove("non-display");
		}else{
			input.parentNode.classList.add("non-display");
		}
	};

    //return boolean value : true means error
	//call set css
	function err_check_option_field() {
		console.log(input.value);  //debug output
		var result = false;

		//checbox, select
		if (dtype.value == "checkbox" || dtype.value == "select") {
			//error check
			var input_text_arr = input.value.split('\n');
			input_text_arr.forEach(function(elm,i){
			// find ":" in each element 
			var count = ( elm.match( new RegExp(":", "g" )) || [] ).length;
			if (count != 1){
				result = true;
			}	  
			});
		}

		css_set(input, result);  //set css
		return result;
	};

	//set error css
	function css_set(elm, err) {
      if (err){
		elm.classList.add("err");
	  }else{
        elm.classList.remove("err");
	  }
	};
    

    //set non-display css
	dtype.onchange = function(){
	    css_display();
	};


	//check option field input error
	input.onblur = function(){
	    var err = err_check_option_field();
		console.log("check option field error - " + err);
	};


	//check option field input error and prevent event
	btn.onclick = function(event){
        var err = err_check_option_field();
		console.log("check option field error - " + err);

		if (err){
			event.preventDefault();
		}
	};

    //initialization
	css_display();
}); 