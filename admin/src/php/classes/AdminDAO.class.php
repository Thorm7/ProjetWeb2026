<?php

class AdminDAO
{
    private PDO $_cnx;

    public function __construct($cnx)
    {
        $this->_cnx = $cnx;
    }

    public function getAdmin($login, $password)
    {
         $query = "SELECT * FROM get_admin(:login, :password)";
        try {
            $this->_cnx->beginTransaction();
            $stmt = $this->_cnx->prepare($query);
            $stmt->bindValue(':login', $login);
            $stmt->bindValue(':password', $password);
            $stmt->execute();
            $data = $stmt->fetch(PDO::FETCH_ASSOC);
            $this->_cnx->commit();

            if (!$data) {
                return null;
            }


            if ((int)$data['id_user'] === -1) {
                return null;
            }


            return new Admin(
                id_admin: (int)$data['id_user'],
                nom_admin: $data['nom'] . ' ' . $data['prenom'],
                statut: ($data['role'] === 'admin') ? 1 : 0
            );
        } catch (PDOException $e) {
            $this->_cnx->rollBack();
            print $e->getMessage();
            return null;
        }
    }
}