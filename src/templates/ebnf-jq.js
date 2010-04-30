/* Template for wrapping the generated ebnf parser code into a web-operational context assuming jQuery usage.*/
/* 
@@@BuildStamp@@@
*/

;
(function($){

@@@EbnfParser@@@

$.extend({
	"ebnfParse": function(str, fn, errfn) {

		parseComplete = fn || function(syn) { 
		    alert(syn.toString()); 
		};
		
	    var parseErrors = errfn || function(err) { 
	        alert("errors#" + err.length);
        };

	    
		var error_cnt 	= 0;
		var error_off	= new Array();
		var error_la	= new Array();

		var errors;
		if( ( error_cnt = __parse( str, error_off, error_la ) ) > 0 )
		{
			errors=new Array();
			for( var i = 0; i < error_cnt; i++ ) {
				var msg = "Parse error near >" + str.substr( error_off[i], 30 ) + 
					"<, expecting \"" + error_la[i].join() + "\"" ;
				errors.push(msg);
		    }
			parseErrors(errors);
		}
	}
});

})(jQuery);
