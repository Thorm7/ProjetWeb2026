<?php
class Commande {
    public function __construct(
        public readonly int $id_panier,
        public readonly ?int $id_user,
        public readonly string $statut
    ) {}
}