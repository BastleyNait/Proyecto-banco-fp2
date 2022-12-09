#!"E:\Desarrollador\perl\bin\perl.exe"
use strict;
use CGI ':standard';
use DBI;
my $nombre = param('nombre');
my $contra = param('contra');
my $id = param('id');
my $saldo = param('saldo');
my $operacion = param('operacion');
my $cantidad =param('cantidad');
##abrimos el mariadb
my $host="servidor"; 
my $base_datos="cuentas";  
my $usuario="alumno";  
my $clave="pweb1";  
my $driver="mysql";  
my $info='
<div class="caja" id="inicio_sesion">
		<!-- El formulario para mandar la validacion de datos -->
		<div class="contenedor">
			<img id="logo" src="./imagenes/logo.png" alt="logo">
			<h2>Operaciones</h2>
			<form method="POST" action="./operaciones.pl">
					<input type=text style="display:none" name=nombre value='.$nombre.'>
					<input type=text style="display:none" name=contra value='.$contra.'>
					<input type=text style="display:none" name=id value='.$id.'>
					<input type=text style="display:none" name=saldo value='.$saldo.'>
				<div class="input_box">
					<input type=number autocomplete="off" step=0.1 min=0 name="cantidad" required/>
					<span>Cantidad</span>
					<i></i>
				</div>
				<div class="input_box" >
						<select name="operacion" class="input_box">
						<option>Deposito</option>
						<option>Retiro</option>
						</select>
					<i></i>
				</div>
				<input type="submit" value="Ejecutar" id="ingresar"/>  
			  <!-- Aqui termina  validacion de datos-->
			</form>	
		</div></div>';
##Conectamos con la BD. Si no podemos, mostramos un mensaje de error
my $dbh = DBI-> connect ("dbi:$driver:database=$base_datos;
host=$host", $usuario, $clave)
|| die "nError al abrir la base datos: $DBI::errstrn";
##operaciones
my $retiro=$saldo-$cantidad;
if($operacion eq "Deposito"){
	$saldo=$saldo+$cantidad ;
	my $sth = $dbh->prepare("UPDATE cuentas SET Saldo=? where id=?");
	$sth->execute($saldo,$id);
	$sth->finish;
	$info="<h2>Se completo el deposito</h2>";
}
elsif(($operacion eq "Retiro") && ($retiro>=0) ) {
	$saldo=$retiro;
	my $sth = $dbh->prepare("UPDATE cuentas SET Saldo=? where id=?");
	$sth->execute($saldo,$id);
	$sth->finish;
	$info="<h2>Se completo el retiro</h2>";}
else {$info=$info."<br><br><br><br><h2>No se completo el retiro</h2>";}	
##Nos desconectamos de la BD. Mostramos un mensaje en caso de error
$dbh-> disconnect ||
warn "nFallo al desconectar.nError: $DBI::errstrn";
##imprimir html
print "Content-type: text/html\n\n";
print <<ENDHTML;
<html>
  <head>
    <!-- La cabecera del html-->
    <meta charset="utf-8" />
    <title>Banco</title>
    <!-- El css-->
    <link rel="stylesheet" type="text/css" href="style.css" />
	<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin><link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300&family=Open+Sans:wght@300&display=swap" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Exo+2:wght@100&display=swap" rel="stylesheet">
  </head>
  <body>
    <header class="barra_navegacion">
		<div class="logo"><h4>SECURITAS <br>FINANCIAL</h4></div>
		<img src="./imagenes/logo.png" alt="logo">
		<nav >
			<a class="logo" href="index.html"> Iniciar sesión </a>
			<a class="logo" href="registrarse.html"> Registrarse </a>
		  </nav>
	</header>
    <center>
$info
</center>
</body>
</html>
ENDHTML