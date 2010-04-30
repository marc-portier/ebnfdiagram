/* Template for wrapping the generated ebnf parser code into a cli-operational context */
/* 
@@@BuildStamp@@@
*/

@@@EbnfParser@@@


function open_file( file )
{
	var fs = new ActiveXObject( 'Scripting.FileSystemObject' );	
	var src = new String();

	if( fs && fs.fileExists( file ) )
	{
		var f = fs.OpenTextFile( file, 1 );
		if( f )
		{
			src = f.ReadAll();
			f.Close();
		}
	}
	
	return src;
}

function read_string()
{
   var kbd = new java.io.BufferedReader(
   		new java.io.InputStreamReader( java.lang.System[ "in" ] ) );

   return kbd.readLine();
}

function read_file( file )
{
	var src = new String();
	
	if( ( new java.io.File( file ).exists() ) )
		src = readFile( file );
	else
	{
		print( "unable to open file '" + file + "'" );
		quit();
	}
	
	return src;
}

if( arguments.length > 0 )
{
    parseComplete = function(syn) {
            print(syn.toString());
            print("done");
    };

	var str		= read_file( arguments[0] );
	var error_cnt 	= 0;
	var error_off	= new Array();
	var error_la	= new Array();
	
	if( ( error_cnt = __parse( str, error_off, error_la ) ) > 0 )
	{
		var i;
		for( i = 0; i < error_cnt; i++ )
			print( "Parse error near >" 
				+ str.substr( error_off[i], 30 ) + "<, expecting \"" + error_la[i].join() + "\"" );
	}
}
else
{
	print( 'usage: ebnf-cli.js <filename>' );
}

