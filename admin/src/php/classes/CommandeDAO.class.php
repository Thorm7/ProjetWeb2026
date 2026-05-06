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
    public function getCommandesByUser(int $idUser): array
    {
        $query = "SELECT p.id_panier, p.statut, c.id_produit, c.quantite, c.prix_achat_u, pr.nom_produit, pr.image_url
              FROM panier p
              JOIN contient c ON p.id_panier = c.id_panier
              JOIN produit pr ON c.id_produit = pr.id_produit
              WHERE p.id_user = :idUser AND p.statut = 'commandé'
              ORDER BY p.id_panier DESC, c.id_produit";
        try {
            $stmt = $this->_cnx->prepare($query);
            $stmt->bindValue(':idUser', $idUser, PDO::PARAM_INT);
            $stmt->execute();
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            print $e->getMessage();
            return [];
        }
    }
}