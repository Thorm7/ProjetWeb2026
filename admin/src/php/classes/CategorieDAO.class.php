<?php

class CategorieDAO
{
    private PDO $_cnx;

    public function __construct(PDO $_cnx)
    {
        $this->_cnx = $_cnx;
    }

    public function getAllCategories(): array
    {
        $query = "SELECT * FROM categorie ORDER BY id_categorie ASC";
        try {
            $stmt = $this->_cnx->prepare($query);
            $stmt->execute();
            $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
            return array_map(function($d) {
                return new Categorie(
                    id_categorie: (int)$d['id_categorie'],
                    nom_categorie: $d['nom_categorie']
                );
            }, $data);
        } catch (PDOException $e) {
            print $e->getMessage();
            return [];
        }
    }
}