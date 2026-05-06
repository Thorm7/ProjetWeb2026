<?php
class ProduitDAO
{
    private PDO $_cnx;

    public function __construct(PDO $_cnx)
    {
        $this->_cnx = $_cnx;
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

    public function effacerProduit($id_produit)
    {
        $query = "select effacer_produit(:id_produit) as retour";
        try {
            $this->_cnx->beginTransaction();
            $stmt = $this->_cnx->prepare($query);
            $stmt->bindValue(':id_produit', $id_produit);
            $stmt->execute();
            $data = $stmt->fetchColumn(0);
            $this->_cnx->commit();
            return $data;
        } catch (PDOException $e) {
            $this->_cnx->rollBack();
            print "<br>Echec de la suppression " . $e->getMessage();
        }
    }

    public function updateChampProduit($champ, $nouveau, $id_produit)
    {
        $query = "select update_champ_produit(:id, :champ, :nouveau) as retour";
        try {
            $this->_cnx->beginTransaction();
            $stmt = $this->_cnx->prepare($query);
            $stmt->bindValue(':id', $id_produit, PDO::PARAM_INT);
            $stmt->bindValue(':champ', $champ);
            $stmt->bindValue(':nouveau', $nouveau);
            $stmt->execute();
            $data = $stmt->fetchColumn(0);
            $this->_cnx->commit();
            if (!$data) {
                return null;
            }
            return $data;
        } catch (PDOException $e) {
            $this->_cnx->rollBack();
            print "<br>Echec de la mise à jour - " . $e->getMessage();
        }
    }

    public function addProduit($nom, $stock, $prix, $description, $type, $image, $id_categorie)
    {
        $query = "select ajout_produit(:nom, :description, :prix, :stock, :image, :type, :id_categorie) as retour";
        try {
            $this->_cnx->beginTransaction();
            $stmt = $this->_cnx->prepare($query);
            $stmt->bindValue(':nom', $nom);
            $stmt->bindValue(':description', $description);
            $stmt->bindValue(':prix', $prix);
            $stmt->bindValue(':stock', $stock, PDO::PARAM_INT);
            $stmt->bindValue(':image', $image);
            $stmt->bindValue(':type', $type);
            $stmt->bindValue(':id_categorie', $id_categorie, PDO::PARAM_INT);
            $stmt->execute();
            $data = $stmt->fetchColumn(0);
            $this->_cnx->commit();
            if(!$data){
                return null;
            }
            return $data;
        }catch(PDOException $e){
            $this->_cnx->rollBack();
            print "<br>Echec de l'insertion - ".$e->getMessage();
        }
    }
    public function getProduitById(int $id): ?Produit
    {
        $query = "SELECT * FROM produit WHERE id_produit = :id";
        try {
            $stmt = $this->_cnx->prepare($query);
            $stmt->bindValue(':id', $id, PDO::PARAM_INT);
            $stmt->execute();
            $data = $stmt->fetch(PDO::FETCH_ASSOC);
            if (!$data) return null;
            return new Produit(
                id_produit: (int)$data['id_produit'],
                nom_produit: $data['nom_produit'],
                description: $data['description'],
                prix: (float)$data['prix'],
                stock: (int)$data['stock'],
                image_url: $data['image_url'] ?? '',
                type_produit: $data['type_produit'],
                id_categorie: (int)$data['id_categorie']
            );
        } catch (PDOException $e) {
            print $e->getMessage();
            return null;
        }
    }
    public function getProduitsByCategorie(int $id_categorie): array
    {
        $query = "SELECT * FROM produit WHERE id_categorie = :id_categorie ORDER BY id_produit DESC";
        try {
            $stmt = $this->_cnx->prepare($query);
            $stmt->bindValue(':id_categorie', $id_categorie, PDO::PARAM_INT);
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
    public function searchProduits(string $q): array
    {
        $query = "SELECT * FROM produit WHERE nom_produit ILIKE :q ORDER BY id_produit DESC";
        try {
            $stmt = $this->_cnx->prepare($query);
            $stmt->bindValue(':q', '%' . $q . '%');
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