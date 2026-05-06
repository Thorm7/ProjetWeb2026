<?php

class UtilisateurDAO
{
    private PDO $_cnx;

    public function __construct(PDO $cnx)
    {
        $this->_cnx = $cnx;
    }

    public function getUtilisateur($email, $password){
        $query = "select * from utilisateur where email = :email and mot_de_passe = :password";
        try {
            $this->_cnx->beginTransaction();
            $stmt = $this->_cnx->prepare($query);
            $stmt->bindParam(":email", $email);
            $stmt->bindParam(":password", $password);
            $stmt->execute();
            $data = $stmt->fetch(PDO::FETCH_ASSOC);
            $this->_cnx->commit();
            if(!$data){
                return null;
            }
            return new Utilisateur(
                id_user: (int)$data['id_user'],
                nom: $data['nom'],
                prenom: $data['prenom'],
                email: $data['email'],
                mot_de_passe: $data['mot_de_passe'],
                date_naissance: $data['date_naissance'],
                role: $data['role']
            );
        } catch (PDOException $e) {
            $this->_cnx->rollback();
            print $e->getMessage();
            return null;
        }
    }

    public function addUtilisateur($nom, $prenom, $email, $password, $date_naissance)
    {
        $query="select ajout_utilisateur(:nom,:prenom,:email,:password,:date_naissance) as retour";
        try {
            $this->_cnx->beginTransaction();
            $stmt = $this->_cnx->prepare($query);
            $stmt->bindValue(':nom',$nom);
            $stmt->bindValue(':prenom',$prenom);
            $stmt->bindValue(':email',$email);
            $stmt->bindValue(':password',$password);
            $stmt->bindValue(':date_naissance',$date_naissance);
            $stmt->execute();
            $retour = $stmt->fetchColumn(0);
            $this->_cnx->commit();

            if (!$retour) {
                return null;
            }
            return $retour;
        } catch(PDOException $e){
            $this->_cnx->rollback();
            print $e->getMessage();
        }
    }
    public function getAllUtilisateurs(): array
    {
        $query = "SELECT * FROM utilisateur ORDER BY id_user ASC";
        try {
            $stmt = $this->_cnx->prepare($query);
            $stmt->execute();
            $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
            return array_map(function($d) {
                return new Utilisateur(
                    id_user: (int)$d['id_user'],
                    nom: $d['nom'],
                    prenom: $d['prenom'],
                    email: $d['email'],
                    mot_de_passe: $d['mot_de_passe'],
                    date_naissance: $d['date_naissance'],
                    role: $d['role']
                );
            }, $data);
        } catch (PDOException $e) {
            print $e->getMessage();
            return [];
        }
    }

    public function deleteUtilisateur($id_user): int
    {
        $query = "SELECT effacer_utilisateur(:id) AS retour";
        try {
            $this->_cnx->beginTransaction();
            $stmt = $this->_cnx->prepare($query);
            $stmt->bindValue(':id', $id_user, PDO::PARAM_INT);
            $stmt->execute();
            $retour = (int)$stmt->fetchColumn(0);
            $this->_cnx->commit();
            return $retour;
        } catch (PDOException $e) {
            $this->_cnx->rollBack();
            print $e->getMessage();
            return 0;
        }
    }

    public function updateUtilisateurRole(int $id_user, string $role): int
    {
        $query = "UPDATE utilisateur SET role = :role WHERE id_user = :id";
        try {
            $stmt = $this->_cnx->prepare($query);
            $stmt->bindValue(':role', $role);
            $stmt->bindValue(':id', $id_user, PDO::PARAM_INT);
            $stmt->execute();
            return $stmt->rowCount();
        } catch (PDOException $e) {
            print $e->getMessage();
            return 0;
        }
    }
}