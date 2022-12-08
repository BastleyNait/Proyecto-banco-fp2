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
				<input type="submit" value="ingresar"/>  
			  <!-- Aqui termina  validacion de datos-->
			</form>	
		</div>
	  </div>
	  <br><br><br><br><h2>El usuario y/o contraseña estan equivocadas</h2>';
my $info;
if($nombres eq ""){$info=$error;}
elsif($contra eq $contra1){$info='
<center><form method=POST action="./operaciones.pl">
			<input type=text style="display:none" name=nombre value='.$nombres.'>
			<input type=text style="display:none" name=contra value='.$contra.'>
			<input type=text style="display:none" name=id value='.$id.'>
			<input type=text style="display:none" name=saldo value='.$saldo.'>
			<h4> Cantidad
			<input type=number name=cantidad step=0.1 min=0 size=42 maxlength=45 value="" 
			style="height: 30px;" required></h4> 
			<br>
			<select name="operacion" size="1">
			<option>Deposito</option>
			<option>Retiro</option>
			</select>
			<input type=submit value="ejecutar" style="height: 30px;"><br><br>
			</form>
			<h4>Su saldo es de '.$saldo.'</h4>
			<form method=POST action="./transferencia.pl">
			<h4>nombre a quien transfira
			<input type=text name=nombreRecibir size=42 maxlength=45 value="" 
			style="height: 30px;" required></h4>
			<h4>cantidad <input type=number name=cantidad step=0.1 min=0 size=42 maxlength=45 value="" 
			style="height: 30px;" required>
			<input type=submit value="transferir" style="height: 30px;"></h4>
			<input type=text style="display:none" name=nombre value='.$nombres.'>
			<input type=text style="display:none" name=contra value='.$contra.'>
			<input type=text style="display:none" name=id value='.$id.'>
			<input type=text style="display:none" name=saldo value='.$saldo.'>
			</form>
	</center>';}
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
    <link rel="stylesheet" type="text/css" href="index.css" />
	<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin><link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300&family=Open+Sans:wght@300&display=swap" rel="stylesheet">
  </head>
  <body>
    <header class="barra_navegacion">
		<div class="logo"><h4>LOGO</h4></div>
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