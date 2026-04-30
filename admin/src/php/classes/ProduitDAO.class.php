<?php

class ProduitDAO
{
    private PDO $_cnx;

    public function __construct(PDO $cnx)
    {
        $this->_cnx = $cnx;
    }

    public function getAllProduits(): array
    {
        $query = "SELECT * FROM produit ORDER BY id_produit DESC";
        try {
            $stmt = $this->_cnx->prepare($query);
            $stmt->execute();
            $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
            return array_map(function($d) {
                return new Produit(
                    id_produit: (int)$d['id_produit'],
                    nom_produit: $d['nom_produit'],
                    description: $d['description'],
                    prix: (float)$d['prix'],
                    stock: (int)$d['stock'],
                    image_url: $d['image_url'] ?? '',
                    type_produit: $d['type_produit'],
                    id_categorie: (int)$d['id_categorie']
                );
            }, $data);
        } catch (PDOException $e) {
            print $e->getMessage();
            return [];
        }
    }

    public function getProduitsByType(string $type): array
    {
        $query = "SELECT * FROM produit WHERE type_produit = :type ORDER BY id_produit DESC";
        try {
            $stmt = $this->_cnx->prepare($query);
            $stmt->bindValue(':type', $type, PDO::PARAM_STR);
            $stmt->execute();
            $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
            return array_map(function($d) {
                return new Produit(
                    id_produit: (int)$d['id_produit'],
                    nom_produit: $d['nom_produit'],
                    description: $d['description'],
                    prix: (float)$d['prix'],
                    stock: (int)$d['stock'],
                    image_url: $d['image_url'] ?? '',
                    type_produit: $d['type_produit'],
                    id_categorie: (int)$d['id_categorie']
                );
            }, $data);
        } catch (PDOException $e) {
            print $e->getMessage();
            return [];
        }
    }
}