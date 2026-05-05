<?php
$prod = new ProduitDAO($cnx);
$categories = new CategorieDAO($cnx);
$cats = $categories->getAllCategories();

if(isset($_POST['submit'])){
    extract($_POST,EXTR_OVERWRITE);
    $erreur = '';
    if($nom_produit == '' || $prix_produit == '' || $stock_online == '' || $type_produit == '' || $description_produit == '' || $image == '') {
        $erreur = "Tous les champs sont obligatoires, y compris l'URL de l'image.";
    }
    if(empty($erreur)) {
        $retour = $prod->addProduit($nom_produit,$stock_online,$prix_produit,
                $description_produit,$type_produit,$image,$id_categorie);
        if($retour == null){
            $erreur = "Echec de l'insertion (doublon ou autre erreur).";
        } else {
            header('Location: index_.php?page=gestion_produits.php');
            exit;
        }
    }
    if(!empty($erreur)) {
        print "<br><span class='txtGras'>$erreur</span>";
    }
}

$produits = $prod->getAllProduits();
?>

<div class="container mt-4">
    <button class="btn btn-primary mb-3" id="inserer">Insérer un nouveau produit</button>
    <form action="index_.php?page=gestion_produits.php" method="post" id="ajout_nouveau">
        <table class="table table-responsive">
            <tr>
                <td class="td">
                    <input type="text" class="form-control" name="nom_produit" id="nom_produit"
                           placeholder="Nom du produit" required>
                </td>
                <td class="td">
                    <input type="number" class="form-control" name="stock_online" id="stock_online"
                           placeholder="Stock en ligne" required>
                </td>
                <td class="td">
                    <input type="number" step="0.01" class="form-control" name="prix_produit" id="prix_produit"
                           placeholder="Prix du produit" required>
                </td>
                <td class="td">
                    <textarea cols="40" rows="2" class="form-control" name="description_produit" id="description"
                              placeholder="Description du produit" required></textarea>
                </td>
                <td class="td">
                    <select class="custom-select" id="type_produit" name="type_produit" required>
                        <option value="">Choisissez le type</option>
                        <option value="livre">Livre</option>
                        <option value="dvd">DVD</option>
                    </select>
                </td>
                <td class="td">
                    <select class="custom-select" id="id_categorie" name="id_categorie" required>
                        <option value="">Choisissez la catégorie</option>
                        <?php foreach ($cats as $cat) { ?>
                            <option value="<?= $cat->id_categorie ?>"><?= $cat->nom_categorie ?></option>
                        <?php } ?>
                    </select>
                </td>
                <td class="td">
                    <input type="text" class="form-control" name="image" id="image"
                           placeholder="Image du produit" required>
                </td>
                <td class="no-border">
                    <input type="submit" name="submit" id="submit" class="btn btn-primary mb-3" value="+">
                </td>
            </tr>
        </table>
    </form>

    <?php if ($produits != null) { ?>
        <table class="table table-responsive">
            <tr>
                <th>Id</th>
                <th>Produit</th>
                <th>Stock</th>
                <th>Prix</th>
                <th>Description</th>
                <th>Type</th>
                <th>Catégorie</th>
                <th>Image</th>
            </tr>
            <?php foreach ($produits as $row) { ?>
                <tr>
                    <td contenteditable="false" data-champ="id_produit"
                        id="<?= $row->id_produit ?>"><?= $row->id_produit ?></td>
                    <td contenteditable="true" data-champ="nom_produit"
                        id="<?= $row->id_produit ?>"><?= $row->nom_produit ?></td>
                    <td contenteditable="true" data-champ="stock"
                        id="<?= $row->id_produit ?>"><?= $row->stock ?></td>
                    <td contenteditable="true" data-champ="prix"
                        id="<?= $row->id_produit ?>"><?= $row->prix ?></td>
                    <td contenteditable="true" data-champ="description"
                        id="<?= $row->id_produit ?>"><?= $row->description ?></td>
                    <td data-champ="type_produit" id="<?= $row->id_produit ?>">
                        <select class="custom-select" name="type_produit">
                            <option value="<?= $row->type_produit ?>" selected><?= $row->type_produit ?></option>
                            <option value="livre">Livre</option>
                            <option value="dvd">DVD</option>
                        </select>
                    </td>
                    <td data-champ="id_categorie" id="<?= $row->id_produit ?>">
                        <select class="custom-select" name="id_categorie">
                            <option value="<?= $row->id_categorie ?>" selected>
                                <?php
                                foreach($cats as $cat){
                                    if($cat->id_categorie == $row->id_categorie) echo $cat->nom_categorie;
                                }
                                ?>
                            </option>
                            <?php foreach ($cats as $cat) { ?>
                                <option value="<?= $cat->id_categorie ?>"><?= $cat->nom_categorie ?></option>
                            <?php } ?>
                        </select>
                    </td>
                    <td contenteditable="true" data-champ="image_url"
                        id="<?= $row->id_produit ?>"><?= $row->image_url ?></td>
                    <td class="delete" data-id="<?= $row->id_produit ?>">
                        <a href="#"><i class="fa-solid fa-trash"></i></a>
                    </td>
                </tr>
            <?php } ?>
        </table>
    <?php } else { ?>
        <p class='txtGras'>Pas encore de données</p>
    <?php } ?>
</div>