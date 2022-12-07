#!"E:\Desarrollador\perl\bin\perl.exe"
use strict;
use CGI ':standard';
use DBI;
my $nombre = param('nombre');
my $contra = param('contra');
my $contra2 = param('contra2');
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
my $error='
<!-- El formulario para registrarse -->
	<form method=POST action="./crear.pl">
			<h4> Nombre del usuario
			<input type=text name=nombre size=42 maxlength=45 value="" style="height: 30px;" required></h4> 
			<h4> Contraseña nueva
			<input type=password name=contra size=40 maxlength=40 value="" style="height: 30px;" required></h4>
			<h4> Confirmar contraseña 
			<input type=password name=contra2 size=40 maxlength=40 value="" style="height: 30px;" required></h4> 			
			<br>
			<input type=submit value="registrarse" style="height: 30px;"><br><br>
			</form>';
my $nombres;
my $sth = $dbh->prepare("SELECT * FROM cuentas WHERE (nombre=?)");
$sth->execute($nombre);
while( my @row = $sth->fetchrow_array ) {
$nombres=$row[1];
}
$sth->finish;
my $info;
my $largoContra=length($contra);
if($nombre eq $nombres){$info=$error."el usuario ya existe";}
elsif($largoContra<8){$info=$error."la contraseña es muy corta minimo 8";}
elsif($contra eq $contra2){
	my $sth1 = $dbh->prepare("INSERT INTO cuentas(nombre, contra, Saldo) VALUES (?,?,?)");
	$sth1->execute($nombre, $contra, 0);
	$sth1->finish;
	$info="Se creo la cuenta ".$nombre;
}
else{$info=$error."las contraseñas no conciden";}
##Nos desconectamos de la BD. Mostramos un mensaje en caso de error
$dbh-> disconnect ||
warn "nFallo al desconectar.nError: $DBI::errstrn";
##imprimir html
print "Content-type: text/html\n\n";
print <<ENDHTML;
<html>
<head>
 	<!-- La cabecera -->
	<meta charset="utf-8"> 	
	<title>Banco</title>
	<!-- El css -->
	<link rel="stylesheet" type="text/css" href="index.css">
</head>
<body>
<center>
$info
<h5><a href="index.html">regresar al principal</a> </h5>
</center>
</body>
</html>
ENDHTML