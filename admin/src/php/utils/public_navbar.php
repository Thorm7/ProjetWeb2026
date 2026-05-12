<nav class="navbar">
    <div class="navbar__logo">
        <a href="index_.php">LivreDVD</a>
    </div>
    <div class="navbar__search">
        <input type="text" id="search-input" placeholder="Recherche un livre, DVD...">
        <div id="search-results" class="search-results" style="display:none;"></div>
    </div>
    <div class="navbar__icons">
        <?php if (isset($_SESSION['client'])): ?>
            <a href="index_.php?page=compte">Mon compte</a>
            <a href="index_.php?page=logout_client">Déconnexion</a>
        <?php else: ?>
            <a href="index_.php?page=login_client">Connexion</a>
        <?php endif; ?>
        <a class="nav-link" href="index_.php?page=panier">
            <i class="fa-solid fa-cart-shopping"></i> Panier
            <span id="cart-count" class="badge bg-danger"><?= $total_panier ?></span>
        </a>
    </div>
</nav>