<?php
declare(strict_types=1);

class Produit implements JsonSerializable
{
    public function __construct(
        public readonly int $id_produit,
        public readonly string $nom_produit,
        public readonly string $description,
        public readonly float $prix,
        public readonly int $stock,
        public readonly string $image_url,
        public readonly string $type_produit,
        public readonly int $id_categorie
    ) {
    }

    public function jsonSerialize(): mixed
    {
        return get_object_vars($this);
    }
}