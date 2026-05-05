BEGIN;

DELETE FROM produit;


ALTER SEQUENCE produit_id_produit_seq RESTART WITH 1;


SELECT ajout_produit('Dune - Tome 1', 'Frank Herbert - Épopée de science-fiction.', 14.99, 25, 'https://m.media-amazon.com/images/I/61HLU-TCZ8L._SL1311_.jpg', 'livre', 1);
SELECT ajout_produit('Le Seigneur des Anneaux', 'J.R.R. Tolkien - Édition intégrale.', 24.99, 12, 'https://cdn1.booknode.com/book_cover/1/full/le-seigneur-des-anneaux-tome-1-la-communaute-de-lanneau-746.jpg', 'livre', 1);
SELECT ajout_produit('1984', 'George Orwell - Roman dystopique.', 9.99, 40, 'https://miro.medium.com/v2/resize:fit:1200/1*LTr-PoAlBaNBYcVODU_1IQ.jpeg', 'livre', 1);
SELECT ajout_produit('Matrix - DVD', 'Film culte de science-fiction.', 7.99, 30, 'https://i.ebayimg.com/images/g/igkAAOSw3YNlv1q~/s-l1600.jpg', 'dvd', 6);
SELECT ajout_produit('Inception - DVD', 'Christopher Nolan - Thriller onirique.', 8.99, 20, 'https://images-na.ssl-images-amazon.com/images/I/71%2BG91CVpvL._SL1345_.jpg', 'dvd', 6);
SELECT ajout_produit('Harry Potter à l''école des sorciers', 'J.K. Rowling - Premier tome.', 11.99, 35, 'https://the-wizards-shop.com/5135-thickbox_default/harry-potter-a-l-ecole-des-sorciers-tome-1.jpg', 'livre', 3);
SELECT ajout_produit('Le Petit Prince', 'Antoine de Saint-Exupéry.', 6.99, 50, 'https://www.lepetitprince.com/wp-content/uploads/2023/01/COVER-Le-Petit-Prince-FR.jpg', 'livre', 2);
SELECT ajout_produit('Fast & Furious 7 - DVD', 'Film d''action.', 10.99, 15, 'https://cdn.hmv.com/r/w-640/hmv/files/b6/b6389e57-3332-467f-b448-3613f54441e0.jpg', 'dvd', 5);

COMMIT;