-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mar. 16 déc. 2025 à 23:30
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Création de la base de données si elle n'existe pas
--
CREATE DATABASE IF NOT EXISTS `restaurant` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

--
-- Sélection de la base de données
--
USE `restaurant`;

-- --------------------------------------------------------

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ranger_clients_non_payes` ()   BEGIN
    DELETE FROM CLIENTS_NON_PAYES;
    
    INSERT INTO CLIENTS_NON_PAYES (id_client, nom_client, prenom_client, adresse_client)
    SELECT id_client, nom_client, prenom_client, adresse_client
    FROM CLIENT
    WHERE a_paye = FALSE;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `client`
--

CREATE TABLE `client` (
  `id_client` int(11) NOT NULL,
  `nom_client` varchar(50) NOT NULL,
  `prenom_client` varchar(50) NOT NULL,
  `adresse_client` varchar(100) NOT NULL,
  `a_paye` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `client`
--

INSERT INTO `client` (`id_client`, `nom_client`, `prenom_client`, `adresse_client`, `a_paye`) VALUES
(1, 'Ligan', 'Corneille', '24 av A', 1),
(2, 'Moussa', 'Atié', '13 rue B', 0),
(3, 'Rajaotiana', 'Rinoh', '27 rue B', 1);

-- --------------------------------------------------------

--
-- Structure de la table `clients_non_payes`
--

CREATE TABLE `clients_non_payes` (
  `id_client` int(11) NOT NULL,
  `nom_client` varchar(50) DEFAULT NULL,
  `prenom_client` varchar(50) DEFAULT NULL,
  `adresse_client` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `compose`
--

CREATE TABLE `compose` (
  `nom_ingredient` varchar(50) NOT NULL,
  `id_plat` int(11) NOT NULL,
  `quantite_ingredient` int(11) NOT NULL CHECK (`quantite_ingredient` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `compose`
--

INSERT INTO `compose` (`nom_ingredient`, `id_plat`, `quantite_ingredient`) VALUES
('Fromage', 1, 1),
('Pate', 2, 2),
('Tomate', 1, 2),
('Tomate', 3, 1);

-- --------------------------------------------------------

--
-- Structure de la table `consomme`
--

CREATE TABLE `consomme` (
  `id_repas` int(11) NOT NULL,
  `id_plat` int(11) NOT NULL,
  `quantite_plat` int(11) NOT NULL CHECK (`quantite_plat` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `consomme`
--

INSERT INTO `consomme` (`id_repas`, `id_plat`, `quantite_plat`) VALUES
(1, 1, 1),
(2, 1, 1),
(3, 2, 1),
(4, 3, 1),
(5, 1, 2),
(5, 3, 1),
(6, 2, 3);

--
-- Déclencheurs `consomme`
--
DELIMITER $$
CREATE TRIGGER `verif_disponibilite_plat` BEFORE INSERT ON `consomme` FOR EACH ROW BEGIN
    IF EXISTS (
        SELECT *
        FROM COMPOSE
        JOIN INGREDIENT USING (nom_ingredient)
        WHERE COMPOSE.id_plat = NEW.id_plat
          AND INGREDIENT.quantite_stock < COMPOSE.quantite_ingredient * NEW.quantite_plat
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ingredients insuffisants pour preparer ce plat';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `ingredient`
--

CREATE TABLE `ingredient` (
  `nom_ingredient` varchar(30) NOT NULL,
  `unite_mesure` varchar(20) NOT NULL,
  `quantite_stock` int(11) NOT NULL CHECK (`quantite_stock` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `ingredient`
--

INSERT INTO `ingredient` (`nom_ingredient`, `unite_mesure`, `quantite_stock`) VALUES
('Fromage', 'kg', 20),
('Pate', 'kg', 30),
('Tomate', 'kg', 50);

-- --------------------------------------------------------

--
-- Structure de la table `plat`
--

CREATE TABLE `plat` (
  `id_plat` int(11) NOT NULL,
  `nom_plat` varchar(50) NOT NULL,
  `prix` decimal(8,2) NOT NULL CHECK (`prix` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `plat`
--

INSERT INTO `plat` (`id_plat`, `nom_plat`, `prix`) VALUES
(1, 'pizza', 12.50),
(2, 'lotte au beurre ', 10.00),
(3, 'salade', 8.00);

-- --------------------------------------------------------

--
-- Structure de la table `repas`
--

CREATE TABLE `repas` (
  `id_repas` int(11) NOT NULL,
  `date_repas` date NOT NULL,
  `heure_debut` time NOT NULL,
  `heure_fin` time NOT NULL,
  `id_table` int(11) NOT NULL,
  `id_client` int(11) DEFAULT NULL,
  `id_serveur` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `repas`
--

INSERT INTO `repas` (`id_repas`, `date_repas`, `heure_debut`, `heure_fin`, `id_table`, `id_client`, `id_serveur`) VALUES
(1, '2025-05-11', '19:00:00', '20:45:00', 1, 1, 1),
(2, '2025-12-15', '13:00:00', '13:45:00', 2, 2, 2),
(3, '2025-05-11', '19:30:00', '20:15:00', 1, 1, 1),
(4, '2025-12-16', '13:00:00', '13:45:00', 2, 2, 2),
(5, '2025-11-05', '19:15:00', '21:00:00', 23, 3, 1),
(6, '2025-11-05', '20:00:00', '21:30:00', 23, 2, 2);

-- --------------------------------------------------------

--
-- Structure de la table `serveur`
--

CREATE TABLE `serveur` (
  `id_serveur` int(11) NOT NULL,
  `nom_serveur` varchar(50) NOT NULL,
  `adresse_serveur` varchar(100) NOT NULL,
  `telephone` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `serveur`
--

INSERT INTO `serveur` (`id_serveur`, `nom_serveur`, `adresse_serveur`, `telephone`) VALUES
(1, 'Dupond', '10 rue X', '0612345678'),
(2, 'Durand', '20 rue Y', '0611223344'),
(3, 'Martin', '7 rue Z', '0698765432');

-- --------------------------------------------------------

--
-- Structure de la table `table_restaurant`
--

CREATE TABLE `table_restaurant` (
  `id_table` int(11) NOT NULL,
  `nb_places` int(11) NOT NULL CHECK (`nb_places` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `table_restaurant`
--

INSERT INTO `table_restaurant` (`id_table`, `nb_places`) VALUES
(1, 4),
(2, 6),
(23, 5);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`id_client`);

--
-- Index pour la table `clients_non_payes`
--
ALTER TABLE `clients_non_payes`
  ADD PRIMARY KEY (`id_client`);

--
-- Index pour la table `compose`
--
ALTER TABLE `compose`
  ADD PRIMARY KEY (`nom_ingredient`,`id_plat`),
  ADD KEY `id_plat` (`id_plat`);

--
-- Index pour la table `consomme`
--
ALTER TABLE `consomme`
  ADD PRIMARY KEY (`id_repas`,`id_plat`),
  ADD KEY `id_plat` (`id_plat`);

--
-- Index pour la table `ingredient`
--
ALTER TABLE `ingredient`
  ADD PRIMARY KEY (`nom_ingredient`);

--
-- Index pour la table `plat`
--
ALTER TABLE `plat`
  ADD PRIMARY KEY (`id_plat`),
  ADD UNIQUE KEY `nom_plat` (`nom_plat`);

--
-- Index pour la table `repas`
--
ALTER TABLE `repas`
  ADD PRIMARY KEY (`id_repas`),
  ADD KEY `id_table` (`id_table`),
  ADD KEY `id_serveur` (`id_serveur`),
  ADD KEY `id_client` (`id_client`);

--
-- Index pour la table `serveur`
--
ALTER TABLE `serveur`
  ADD PRIMARY KEY (`id_serveur`);

--
-- Index pour la table `table_restaurant`
--
ALTER TABLE `table_restaurant`
  ADD PRIMARY KEY (`id_table`);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `compose`
--
ALTER TABLE `compose`
  ADD CONSTRAINT `compose_ibfk_1` FOREIGN KEY (`nom_ingredient`) REFERENCES `ingredient` (`nom_ingredient`),
  ADD CONSTRAINT `compose_ibfk_2` FOREIGN KEY (`id_plat`) REFERENCES `plat` (`id_plat`);

--
-- Contraintes pour la table `consomme`
--
ALTER TABLE `consomme`
  ADD CONSTRAINT `consomme_ibfk_1` FOREIGN KEY (`id_repas`) REFERENCES `repas` (`id_repas`),
  ADD CONSTRAINT `consomme_ibfk_2` FOREIGN KEY (`id_plat`) REFERENCES `plat` (`id_plat`);

--
-- Contraintes pour la table `repas`
--
ALTER TABLE `repas`
  ADD CONSTRAINT `repas_ibfk_1` FOREIGN KEY (`id_table`) REFERENCES `table_restaurant` (`id_table`),
  ADD CONSTRAINT `repas_ibfk_2` FOREIGN KEY (`id_serveur`) REFERENCES `serveur` (`id_serveur`),
  ADD CONSTRAINT `repas_ibfk_3` FOREIGN KEY (`id_client`) REFERENCES `client` (`id_client`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
