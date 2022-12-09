#!"E:\Desarrollador\perl\bin\perl.exe"
use strict;
use CGI ':standard';
use DBI;
my $nombre = param('nombre');
my $contra = param('contra');
my $id = param('id');
my $saldo = param('saldo');
my $cantidad =param('cantidad');
my $nombreR=param('nombreRecibir');
##abrimos el mariadb
my $host="servidor"; 
my $base_datos="cuentas";  
my $usuario="alumno";  
my $clave="pweb1";  
my $driver="mysql";  
my $info;
##Conectamos con la BD. Si no podemos, mostramos un mensaje de error
my $dbh = DBI-> connect ("dbi:$driver:database=$base_datos;
host=$host", $usuario, $clave)
|| die "nError al abrir la base datos: $DBI::errstrn";
##operaciones
my $sth = $dbh->prepare("SELECT * FROM cuentas WHERE (nombre=?)");
my $idR;
my $nombresR;
my $contra1R;
my $saldoR;
my $saldoReal;
my $info;
my $error=
'<div class="caja" id="inicio_sesion">
<!-- Transferencia-->
		<div class="contenedor" id="demo">
			<img id="logo" src="./imagenes/logo.png" alt="logo">
			<h2>Transferencia</h2>
			<form method="POST" action="./transferencia.pl">
					<input type=text style="display:none" name=nombre value='.$nombre.'>
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
				<input type="submit" value="Transferir" id="ingresar"/>  
			  <!-- Aqui termina  validacion de datos-->
			</form>	
		</div>
	  </div>';
$sth->execute($nombreR);
while( my @row = $sth->fetchrow_array ) {
$idR=$row[0];
$nombresR=$row[1];
$contra1R=$row[2];
$saldoR=$row[3];
}
$sth->execute($nombre);
while( my @row = $sth->fetchrow_array ) {
$saldoReal=$row[3];
}
$sth->finish;
my $diferencia=$saldoReal-$cantidad;
if($nombresR eq ""){$info=$error."<br><br><br><br><h2>usario no exite</h2>";}
elsif( $diferencia<0){$info=$error."<br><br><br><br><h2>no hay suficiente saldo <br> Su saldo es ".$saldoReal."</h2>";}
else{
	my $sth1 = $dbh->prepare("UPDATE cuentas SET Saldo=? where nombre=?");
	my $total = $saldoR + $cantidad;
	$sth1->execute($total,$nombresR);
	$sth1->execute($diferencia,$nombre);
	$sth1->finish;
	$info="<h2>Se completo la transferencia de ".$cantidad." a ".$nombresR."</h2>";
	}
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