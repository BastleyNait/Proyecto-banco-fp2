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
'<form method=POST action="./transferencia.pl">
			<h4>nombre a quien transfira
			<input type=text name=nombreRecibir size=42 maxlength=45 value="" 
			style="height: 30px;" required></h4>
			<h4>cantidad <input type=number name=cantidad step=0.1 min=0 size=42 maxlength=45 value="" 
			style="height: 30px;" required>
			<input type=submit value="transferir" style="height: 30px;"></h4>
			<input type=text style="display:none" name=nombre value='.$nombre.'>
			<input type=text style="display:none" name=contra value='.$contra.'>
			<input type=text style="display:none" name=id value='.$id.'>
			<input type=text style="display:none" name=saldo value='.$saldo.'>
			</form>';
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
if($nombresR eq ""){$info=$error."usario no exite";}
elsif( $diferencia<0){$info=$error."no hay suficiente saldo <br> Su saldo es ".$saldoReal;}
else{
	my $sth1 = $dbh->prepare("UPDATE cuentas SET Saldo=? where nombre=?");
	my $total = $saldoR + $cantidad;
	$sth1->execute($total,$nombresR);
	$sth1->execute($diferencia,$nombre);
	$sth1->finish;
	$info="Se completo la transferncia de ".$cantidad." a ".$nombresR;
	}
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