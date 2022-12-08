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
      <div class="caja">
      <div class="contenedor">
        <h2> Registrarse </h2>
      <form method="POST" action="./crear.pl">
        <div class="input_box">
          <input type="text" autocomplete="off" name="nombre" required />
          <span> Nombre del Usuario </span>
          <i></i>
        </div>
        <div class="input_box">
          <input type="password" autocomplete="off" name="contra" required />
          <span> Contraseña Nueva </span>
          <i></i>
        </div>
        <div class="input_box">
          <input type="password" name="contra2" required />
          <span> Confirmar Contraseña </span>
					<i></i>
        </div>  
          
        <br/>
        <input class="boton"
          type="submit"
          value="Registrarse"
          style="height: 30px"
        />
      </form>
      </div>
      </div>';
my $nombres;
my $sth = $dbh->prepare("SELECT * FROM cuentas WHERE (nombre=?)");
$sth->execute($nombre);
while( my @row = $sth->fetchrow_array ) {
$nombres=$row[1];
}
$sth->finish;
my $info;
my $largoContra=length($contra);
if($nombre eq $nombres){$info=$error."<br><br><h2>el usuario ya existe</h2>";}
elsif($largoContra<8){$info=$error."<br><br><h2>la contraseña es muy corta minimo 8</h2>";}
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
    <!-- La cabecera del html-->
    <meta charset="utf-8" />
    <title> Banco </title>
    <!-- El css-->
    <link rel="stylesheet" type="text/css" href="registrarse.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin><link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300&family=Open+Sans:wght@300&display=swap" rel="stylesheet">
  </head>
  <body>
    <header class="barra_navegacion">
      <div class="logo">
        <h4>  LOGO  </h4>
      </div>
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