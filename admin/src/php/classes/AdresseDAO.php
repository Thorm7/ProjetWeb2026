public function addAdresse($numero, $rue, $cp, $ville, $idUser): int
{
$query = "SELECT ajout_adresse(:numero, :rue, :cp, :ville, :idUser) AS id";
try {
$stmt = $this->_cnx->prepare($query);
$stmt->bindValue(':numero', $numero);
$stmt->bindValue(':rue', $rue);
$stmt->bindValue(':cp', $cp, PDO::PARAM_INT);
$stmt->bindValue(':ville', $ville);
$stmt->bindValue(':idUser', $idUser, PDO::PARAM_INT);
$stmt->execute();
return (int)$stmt->fetchColumn(0);
} catch (PDOException $e) {
print $e->getMessage();
return 0;
}
}