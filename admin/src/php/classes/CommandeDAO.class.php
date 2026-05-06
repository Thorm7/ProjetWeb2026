<?php
class CommandeDAO {
    private PDO $_cnx;
    public function __construct(PDO $cnx) { $this->_cnx = $cnx; }

    public function creerCommande(?int $idUser): int {
        $query = "SELECT ajout_panier(:id_user) AS id";
        $stmt = $this->_cnx->prepare($query);
        $stmt->bindValue(':id_user', $idUser, PDO::PARAM_INT);
        $stmt->execute();
        return (int)$stmt->fetchColumn(0);
    }

    public function ajouterLigne(int $idPanier, int $idProduit, int $quantite, float $prix): void {
        $query = "SELECT ajout_ligne_panier(:id_p, :id_prod, :qte, :prix)";
        $stmt = $this->_cnx->prepare($query);
        $stmt->bindValue(':id_p', $idPanier, PDO::PARAM_INT);
        $stmt->bindValue(':id_prod', $idProduit, PDO::PARAM_INT);
        $stmt->bindValue(':qte', $quantite, PDO::PARAM_INT);
        $stmt->bindValue(':prix', $prix);
        $stmt->execute();
    }
}