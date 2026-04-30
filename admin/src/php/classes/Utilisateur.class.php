<?php
declare(strict_types=1);

class Utilisateur implements JsonSerializable
{
    public function __construct(
        public readonly int $id_user,
        public readonly string $nom,
        public readonly string $prenom,
        public readonly string $email,
        public readonly string $mot_de_passe,
        public readonly string $date_naissance,
        public readonly string $role
    ) {
    }

    public function jsonSerialize(): mixed
    {
        return get_object_vars($this);
    }
}