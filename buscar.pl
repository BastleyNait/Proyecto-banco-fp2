#!"E:\Desarrollador\perl\bin\perl.exe"
use strict;
use CGI ':standard';
use DBI;
my $nombre = param('nombre');
my $contra = param('contra');
##abrimos el mariadb
my $host="servidor"; 
my $base_datos="cuentas";  
my $usuario="alumno";  
my $clave="pweb1";  
my $driver="mysql";  
##Conectamos con la BD. Si no podemos, mostramos un mensaje de error
my $dbh = DBI-> connect ("dbi:$driver:database=$base_datos;
host=$host", $usuario, $clave)
|| die "nError al abrir la base datos: $DBI::errstrn";
##operaciones
my $id;
my $nombres;
my $contra1;
my $saldo;
my $sth = $dbh->prepare("SELECT * FROM cuentas WHERE (nombre=?)");
$sth->execute($nombre);
while( my @row = $sth->fetchrow_array ) {
$id=$row[0];
$nombres=$row[1];
$contra1=$row[2];
$saldo=$row[3];
}
$sth->finish;
##Nos desconectamos de la BD. Mostramos un mensaje en caso de error
$dbh-> disconnect ||
warn "nFallo al desconectar.nError: $DBI::errstrn";
##confirma usuario
my $error='
<div class="caja">
		<!-- El formulario para mandar la validacion de datos -->
		<div class="contenedor">
			<img id="logo" src="./imagenes/logo.png" alt="logo">
			<h2>Iniciar Sesión</h2>
			<form method="POST" action="./buscar.pl">
				<div class="input_box">
					<input type="text" autocomplete="off" name="nombre"required/>
					<span>Usuario</span>
					<i></i>
				</div>
				<div class="input_box">
					<input type="password" name="contra" required/>
					<span>Contraseña</span>
					<i></i>
				</div>
				<input type="submit" value="Ingresar" id="ingresar"/>  
			  <!-- Aqui termina  validacion de datos-->
			</form>	
		</div>
	  </div>
	  <br><br><br><br><h2>El usuario y/o contraseña estan equivocadas</h2>';
my $info;
if($nombres eq ""){$info=$error;}
elsif($contra eq $contra1){$info='
<div class="caja" id="inicio_sesion">
		<!-- El formulario para mandar la validacion de datos -->
		<div class="contenedor">
			<img id="logo" src="./imagenes/logo.png" alt="logo">
			<h2>Operaciones Saldo '.$saldo.'</h2>
			<form method="POST" action="./operaciones.pl">
					<input type=text style="display:none" name=nombre value='.$nombres.'>
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
				<div class="input_box">
					<button type="button" onclick="document.getElementById('."'demo'".').style.display='."'block'".'">Transferir</button>
					<i></i>
				</div>
				<input type="submit" value="Ejecutar" id="ingresar"/>  
			  <!-- Aqui termina  validacion de datos-->
			</form>	
		</div>
		<!-- Transferencia-->
		<div class="contenedor" id="demo">
			<img id="logo" src="./imagenes/logo.png" alt="logo">
			<h2>Transferencia Saldo '.$saldo.'</h2>
			<form method="POST" action="./transferencia.pl">
					<input type=text style="display:none" name=nombre value='.$nombres.'>
					<input type=text style="display:none" name=contra value='.$contra.'>
					<input type=text style="display:none" name=id value='.$id.'>
					<input type=text style="display:none" name=saldo value='.$saldo.'>
				<div class="input_box">
					<input type=text autocomplete="off" name="nombreRecibir" required/>
					<span>Usuario a quien tranferir</span>
					<i></i>
				</div>	
				<div class="input_box">
					<input type=number autocomplete="off" step=0.1 min=0 name="cantidad" required/>
					<span>Cantidad</span>
					<i></i>
				</div>
				<div class="input_box" >
					<button type="button" onclick="document.getElementById('."'demo'".').style.display='."'none'".'">operaciones</button>
					<i></i>
				</div>
				<input type="submit" value="Transferir" id="ingresar"/>  
			  <!-- Aqui termina  validacion de datos-->
			</form>	
		</div>
	  </div>';}
else{$info=$error;}
##imprimir html
print "Content-type: text/html\n\n";
print <<ENDHTML;
<!DOCTYPE html>
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
		<div class="logo"><a href="./index.html"><h4>SECURITAS <br>FINANCIAL</h4></a></div>
		<img src="./imagenes/logo.png" alt="logo">
		<nav >
			<a class="logo" href="iniciar_sesion.html"> Iniciar sesión </a>
			<a class="logo" href="registrarse.html"> Registrarse </a>
		  </nav>
	</header>
    <center>
$info
</center>
</body>
</html>
ENDHTML