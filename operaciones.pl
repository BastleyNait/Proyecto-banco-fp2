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
my $info;
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
	$info="Se completo el deposito";
}
elsif(($operacion eq "Retiro") && ($retiro>=0) ) {
	$saldo=$retiro;
	my $sth = $dbh->prepare("UPDATE cuentas SET Saldo=? where id=?");
	$sth->execute($saldo,$id);
	$sth->finish;
	$info="Se completo el retiro";}
else {$info="No se completo el retiro";}	
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
$info <br>
su saldo es $saldo 
<br>
<h5><a href="index.html">regresar al principal</a> </h5>
</center>
</body>
</html>
ENDHTML