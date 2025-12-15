-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 14-03-2025 a las 22:26:32
-- Versión del servidor: 8.0.41-0ubuntu0.20.04.1
-- Versión de PHP: 7.4.3-4ubuntu2.24

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sisacad`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`iweb`@`%` PROCEDURE `insert_course` (IN `p_area_code` VARCHAR(10), IN `p_name` VARCHAR(255), IN `p_code` VARCHAR(50), IN `p_theory_hours` INT, IN `p_practice_hours` INT, IN `p_lab_hours` INT, IN `p_credits` INT, IN `p_curriculum_tag` VARCHAR(255), IN `p_semester_name` VARCHAR(50))   BEGIN
    INSERT INTO courses (
        id, area_id, name, code, description, 
        theory_hours, practice_hours, lab_hours, 
        summary, credits, semi_hours, status, 
        created, modified, created_id, modified_id, 
        semester_id, theory_pracs_hours, prq_cred
    ) 
    VALUES (
        NULL, 
        (SELECT id FROM areas WHERE code = p_area_code), -- Obtiene el area_id con base en el code
        p_name, 
        p_code, 
        NULL, -- description es NULL
        p_theory_hours, 
        p_practice_hours, 
        p_lab_hours, 
        NULL, -- summary es NULL
        p_credits, 
        NULL, -- semi_hours es NULL
        1, -- status predeterminado
        CURRENT_TIMESTAMP, 
        NULL, -- modified es NULL
        1, -- created_id predeterminado
        NULL, -- modified_id es NULL
        (SELECT s.id 
         FROM curriculums c 
         INNER JOIN semesters s ON c.id = s.curriculum_id 
         WHERE c.tag = p_curriculum_tag AND s.name = p_semester_name), 
        0, -- theory_pracs_hours es NULL
        NULL  -- prq_cred es NULL
    );
END$$

CREATE DEFINER=`iweb`@`%` PROCEDURE `insert_prerequisite` (IN `course_code` VARCHAR(255), IN `prerequisite_code` VARCHAR(255))   begin
    declare course_id int;
    declare prerequisite_id int;

    -- Obtener el ID del curso
    select c.id 
    into course_id 
    from courses c 
    where c.code = course_code collate utf8mb4_general_ci
    limit 1;

    -- Obtener el ID del curso prerrequisito
    select c.id 
    into prerequisite_id 
    from courses c 
    where c.code = prerequisite_code collate utf8mb4_general_ci
    limit 1;

    -- Insertar en la tabla de prerrequisitos
    insert into course_prerequisites (
        id, course_id, prerequisite_id, status, created, modified, created_id, modified_id
    )
    values (
        null, course_id, prerequisite_id, '1', now(), null, '1', null
    );
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `academic_degrees`
--

CREATE TABLE `academic_degrees` (
  `id` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT NULL,
  `created_id` int NOT NULL,
  `modified_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `academic_semesters`
--

CREATE TABLE `academic_semesters` (
  `id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created` timestamp NULL DEFAULT NULL,
  `modified` timestamp NULL DEFAULT NULL,
  `created_id` int NOT NULL,
  `modified_id` int DEFAULT NULL,
  `academic_year` int NOT NULL,
  `period` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `semester_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `weeks_count` int NOT NULL,
  `description` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `areas`
--

CREATE TABLE `areas` (
  `id` int NOT NULL,
  `code` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT NULL,
  `created_id` int NOT NULL DEFAULT '1',
  `modified_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `areas`
--

INSERT INTO `areas` (`id`, `code`, `name`, `status`, `created`, `modified`, `created_id`, `modified_id`) VALUES
(1, 'A', 'Formación Básica', 1, '2024-09-17 04:28:07', NULL, 1, NULL),
(2, 'B', 'Formación Especializada', 1, '2024-09-17 04:28:07', NULL, 1, NULL),
(3, 'C', 'Formación Profesional y Otros', 1, '2024-09-17 04:28:07', NULL, 1, NULL),
(4, 'D', 'Est.Gen.: Capacidades de Aprendizaje', 1, '2024-09-17 04:28:07', NULL, 1, NULL),
(5, 'E', 'Est.Gen.: Form.Humanist.Ident. y Ciudadania', 1, '2024-09-17 04:28:07', NULL, 1, NULL),
(6, 'F', 'Estudios Específicos', 1, '2024-09-17 04:28:07', NULL, 1, NULL),
(7, 'G', 'Estudios de Especialidad', 1, '2024-09-17 04:28:07', NULL, 1, NULL),
(19, '2434', 'Ingenieria Web', 1, '2024-10-30 22:33:30', NULL, 1, NULL),
(28, 'IS', 'Ingeniería de software', 1, '2024-09-17 04:31:39', NULL, 1, NULL),
(29, 'CC', 'Ciencias de la Computación', 1, '2024-09-17 04:31:39', NULL, 1, NULL),
(30, 'CB', 'Ciencias Básicas', 1, '2024-09-17 04:31:39', NULL, 1, NULL),
(31, 'EG', 'Estudios Generales', 1, '2024-09-17 04:31:39', NULL, 1, NULL),
(32, 'FB', '--', 1, '2024-09-17 04:31:39', NULL, 1, NULL),
(33, 'FH', '--', 1, '2024-09-17 04:31:39', NULL, 1, NULL),
(34, 'FE', '--', 1, '2024-09-17 04:31:39', NULL, 1, NULL),
(35, 'PP', '--', 1, '2024-09-17 04:31:39', NULL, 1, NULL),
(36, 'EF', '--', 1, '2024-09-17 04:31:39', NULL, 1, NULL),
(37, 'E_1', '--ULS', 1, '2024-09-17 04:31:39', NULL, 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `careers`
--

CREATE TABLE `careers` (
  `id` int UNSIGNED NOT NULL,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT NULL,
  `created_id` int NOT NULL,
  `modified_id` int DEFAULT NULL,
  `department_id` int UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `careers`
--

INSERT INTO `careers` (`id`, `name`, `status`, `created`, `modified`, `created_id`, `modified_id`, `department_id`) VALUES
(1, 'Ingeniería de Sistemas', 1, '2024-09-12 00:00:00', NULL, 1, NULL, 2),
(2, 'Ingeniería de Software', 1, '2024-09-12 00:00:00', NULL, 1, NULL, 1),
(3, 'Arquitectura', 1, '2024-10-31 15:53:54', NULL, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `courses`
--

CREATE TABLE `courses` (
  `id` int NOT NULL,
  `area_id` int DEFAULT NULL,
  `name` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `theory_hours` int NOT NULL,
  `practice_hours` int NOT NULL,
  `lab_hours` int NOT NULL,
  `total_hours` int GENERATED ALWAYS AS ((((`theory_hours` + `practice_hours`) + `lab_hours`) + `theory_pracs_hours`)) STORED,
  `summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `credits` int NOT NULL,
  `semi_hours` int DEFAULT '0',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT NULL,
  `created_id` int NOT NULL DEFAULT '1',
  `modified_id` int DEFAULT NULL,
  `semester_id` int DEFAULT NULL,
  `theory_pracs_hours` int DEFAULT '0',
  `prq_cred` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `courses`
--

INSERT INTO `courses` (`id`, `area_id`, `name`, `code`, `description`, `theory_hours`, `practice_hours`, `lab_hours`, `summary`, `credits`, `semi_hours`, `status`, `created`, `modified`, `created_id`, `modified_id`, `semester_id`, `theory_pracs_hours`, `prq_cred`) VALUES
(1, 28, 'Introducción a la Computación', '3.1.1.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 04:57:57', NULL, 1, NULL, 1, 0, NULL),
(2, 29, 'Introducción a la Programación', '3.1.2.21', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 05:12:17', NULL, 1, NULL, 1, 0, NULL),
(4, 1, 'CALCULO EN UNA VARIABLE', '1301101', NULL, 2, 0, 0, NULL, 4, NULL, 1, '2024-09-17 05:29:02', NULL, 1, NULL, 39, 0, NULL),
(6, 30, 'Algebra y Geometría', '3.1.3.21', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-17 05:33:41', NULL, 1, NULL, 1, 0, NULL),
(7, 1, 'ESTRUCTURAS DISCRETAS 1', '1301102', NULL, 2, 0, 0, NULL, 3, NULL, 1, '2024-09-17 05:34:17', NULL, 1, NULL, 39, 0, NULL),
(8, 1, 'CALCULO I', '9501101', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-17 05:46:05', NULL, 1, NULL, 29, 2, NULL),
(9, 2, 'ESTRUCTURAS DISCRETAS I', '9501102', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-17 05:46:05', NULL, 1, NULL, 29, 2, NULL),
(10, 2, 'INTRODUCCION A LA INGENIERIA DE SISTEMAS', '9501103', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 05:46:05', NULL, 1, NULL, 29, 0, NULL),
(11, 1, 'ECONOMIA DE EMPRESA', '9501104', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 05:46:05', NULL, 1, NULL, 29, 2, NULL),
(12, 1, 'DIBUJO EN INGENIERIA', '9501105', NULL, 1, 4, 0, NULL, 3, NULL, 1, '2024-09-17 05:46:05', NULL, 1, NULL, 29, 4, NULL),
(13, 3, 'INTERPRETACION TEXTUAL', '9501106', NULL, 0, 2, 0, NULL, 2, NULL, 1, '2024-09-17 05:46:05', NULL, 1, NULL, 29, 2, NULL),
(14, 1, 'CALCULO 2', '9501207', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-17 05:55:25', NULL, 1, NULL, 30, 0, NULL),
(15, 2, 'ESTRUCTURAS DISCRETAS 2', '9501208', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-17 05:55:25', NULL, 1, NULL, 30, 0, NULL),
(16, 1, 'FISICA 1', '9501209', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-17 05:55:25', NULL, 1, NULL, 30, 0, NULL),
(17, 2, 'TALLER DE PROGRAMACION', '9501210', NULL, 1, 0, 0, NULL, 4, NULL, 1, '2024-09-17 05:55:25', NULL, 1, NULL, 30, 0, NULL),
(18, 3, 'COMUNICACION ORAL Y ESCRITA', '9501211', NULL, 0, 2, 0, NULL, 2, NULL, 1, '2024-09-17 05:55:25', NULL, 1, NULL, 30, 0, NULL),
(19, 1, 'ECONOMIA NACIONAL', '9501212', NULL, 0, 2, 0, NULL, 2, NULL, 1, '2024-09-17 05:55:25', NULL, 1, NULL, 30, 0, NULL),
(20, 1, 'CALCULO 3', '9502113', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-17 05:59:31', NULL, 1, NULL, 31, 0, NULL),
(21, 1, 'ALGEBRA LINEAL', '9502114', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-17 05:59:31', NULL, 1, NULL, 31, 0, NULL),
(22, 1, 'FISICA 2', '9502115', NULL, 1, 2, 0, NULL, 3, NULL, 1, '2024-09-17 05:59:31', NULL, 1, NULL, 31, 0, NULL),
(23, 2, 'TEORIA DE SISTEMAS', '9502116', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-17 05:59:31', NULL, 1, NULL, 31, 0, NULL),
(24, 2, 'FUNDAMENTOS DE LENGUAJES DE PROGRAMACION', '9502117', NULL, 3, 0, 0, NULL, 5, NULL, 1, '2024-09-17 05:59:31', NULL, 1, NULL, 31, 0, NULL),
(25, 3, 'FILOSOFIA Y ETICA (E)', '9502118', NULL, 2, 0, 0, NULL, 2, NULL, 1, '2024-09-17 05:59:31', NULL, 1, NULL, 31, 0, NULL),
(26, 1, 'ECUACIONES DIFERENCIALES', '9502219', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-17 06:04:29', NULL, 1, NULL, 32, 0, NULL),
(27, 2, 'SISTEMAS ELECTRONICOS', '9502220', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-17 06:04:29', NULL, 1, NULL, 32, 0, NULL),
(28, 1, 'CONTABILIDAD Y FINANZAS', '9502221', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-17 06:04:29', NULL, 1, NULL, 32, 0, NULL),
(29, 1, 'ECUACIONES DIFERENCIALES', '9502119', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-17 06:05:42', NULL, 1, NULL, 32, 0, NULL),
(30, 2, 'SISTEMAS ELECTRONICOS', '9502220', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-17 06:05:42', NULL, 1, NULL, 32, 0, NULL),
(31, 1, 'CONTABILIDAD Y FINANZAS', '9502221', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-17 06:05:42', NULL, 1, NULL, 32, 0, NULL),
(32, 1, 'ECUACIONES DIFERENCIALES', '9502119', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-17 06:06:59', NULL, 1, NULL, 32, 0, NULL),
(33, 2, 'SISTEMAS ELECTRONICOS', '9502220', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-17 06:06:59', NULL, 1, NULL, 32, 0, NULL),
(34, 1, 'CONTABILIDAD Y FINANZAS', '9502221', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-17 06:06:59', NULL, 1, NULL, 32, 0, NULL),
(35, 2, 'SISTEMAS ORGANIZACIONALES', '9502222', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-17 06:06:59', NULL, 1, NULL, 32, 0, NULL),
(36, 2, 'ESTRUCTURA DE DATOS', '9502223', NULL, 3, 4, 0, NULL, 5, NULL, 1, '2024-09-17 06:06:59', NULL, 1, NULL, 32, 0, NULL),
(37, 35, 'Inteligencia Artificial', '30801', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 13:41:31', NULL, 1, NULL, 77, 0, NULL),
(38, 32, 'Metodología de la Investigación', '30802', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 13:41:31', NULL, 1, NULL, 77, 0, NULL),
(39, 32, 'Pensamiento Crítico', '30803', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 13:41:31', NULL, 1, NULL, 77, 0, NULL),
(40, 35, 'Proyecto de Ingeniería de Software', '30804', NULL, 4, 2, 0, NULL, 5, NULL, 1, '2024-09-17 13:41:31', NULL, 1, NULL, 77, 0, NULL),
(41, 34, 'Fundamentos de Tecnologías de la Información', '30805', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 13:41:31', NULL, 1, NULL, 77, 0, NULL),
(42, 35, 'Métodos Formales en Ingeniería de Software', '30806', NULL, 4, 2, 0, NULL, 5, NULL, 1, '2024-09-17 13:41:31', NULL, 1, NULL, 77, 0, NULL),
(43, 35, 'Administración de Proyectos de Software', '30901', NULL, 4, 0, 0, NULL, 4, NULL, 1, '2024-09-17 13:44:31', NULL, 1, NULL, 78, 0, NULL),
(44, 35, 'Data Warehouse y Data Mining', '30902', NULL, 2, 2, 2, NULL, 5, NULL, 1, '2024-09-17 13:44:31', NULL, 1, NULL, 78, 0, NULL),
(45, 32, 'Proyecto de Tesis I', '30904', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 13:44:31', NULL, 1, NULL, 78, 0, NULL),
(46, 34, 'Tecnologías Emergentes', '30905', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 13:44:31', NULL, 1, NULL, 78, 0, NULL),
(47, 35, 'Inteligencia de Negocios', '30906', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 13:44:31', NULL, 1, NULL, 78, 0, NULL),
(48, 34, 'Tópicos de Tecnologías de Información', '30907', NULL, 4, 0, 0, NULL, 4, NULL, 1, '2024-09-17 13:44:31', NULL, 1, NULL, 78, 0, NULL),
(49, 37, 'Antropología', '30001', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 13:44:31', NULL, 1, NULL, 79, 0, NULL),
(50, 32, 'Ética Profesional', '30002', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 13:44:31', NULL, 1, NULL, 79, 0, NULL),
(51, 35, 'Formulación y Evaluación de Proyectos de Software', '30003', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 13:44:31', NULL, 1, NULL, 79, 0, NULL),
(52, 35, 'Auditoría', '30004', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 13:44:31', NULL, 1, NULL, 79, 0, NULL),
(53, 35, 'Tópicos Avanzados de Ingeniería de Software', '30005', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 13:44:31', NULL, 1, NULL, 79, 0, NULL),
(54, 32, 'Proyecto de Tesis II', '30006', NULL, 4, 2, 0, NULL, 5, NULL, 1, '2024-09-17 13:44:31', NULL, 1, NULL, 79, 0, NULL),
(55, 30, 'Algebra Lineal', '3.1.4.21', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 1, 0, NULL),
(56, 31, 'Expresión Artística', '3.1.5.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 1, 0, NULL),
(57, 31, 'Comunicación I', '3.1.6.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 1, 0, NULL),
(58, 31, 'Metodología del Estudio', '3.1.7.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 1, 0, NULL),
(59, 29, 'Lenguaje de Programación I', '3.2.1.21', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 2, 0, NULL),
(60, 28, 'Introducción a la Ingeniería de Software', '3.2.2.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 2, 0, NULL),
(61, 30, 'Matemática Discreta', '3.2.3.21', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 2, 0, NULL),
(62, 30, 'Cálculo I', '3.2.4.21', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 2, 0, NULL),
(63, 31, 'Comunicación II', '3.2.5.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 2, 0, NULL),
(64, 31, 'Economía Política', '3.2.6.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 2, 0, NULL),
(65, 31, 'Realidad Nacional', '3.2.7.21', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 2, 0, NULL),
(66, 29, 'Lenguaje de Programación II', '3.3.1.21', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 3, 0, NULL),
(67, 28, 'Requisitos de Software', '3.3.2.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 3, 0, NULL),
(68, 31, 'Liderazgo y Trabajo en Equipo', '3.3.3.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 3, 0, NULL),
(69, 30, 'Álgebra Abstracta', '3.3.4.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 3, 0, NULL),
(70, 30, 'Estadística y Probabilidades', '3.3.5.21', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 3, 0, NULL),
(71, 28, 'Inglés Aplicado', '3.3.6.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 3, 0, NULL),
(72, 30, 'Cálculo II', '3.3.7.21', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 3, 0, NULL),
(73, 29, 'Lenguaje de Programación III', '3.4.1.21', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 4, 0, NULL),
(74, 29, 'Estructura de Datos', '3.4.2.21', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 4, 0, NULL),
(75, 28, 'Fundamentos de Diseño de Software', '3.4.3.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 4, 0, NULL),
(76, 30, 'Lógica Computacional', '3.4.4.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 4, 0, NULL),
(77, 31, 'Formación Cristiana', '3.4.5.21', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 4, 0, NULL),
(78, 29, 'Teoría de la Computación', '3.4.6.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 4, 0, NULL),
(79, 30, 'Ecuaciones Diferenciales', '3.4.7.21', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 4, 0, NULL),
(80, 29, 'Lenguaje de Programación III', '3.4.1.21', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 4, 0, NULL),
(81, 29, 'Estructura de Datos', '3.4.2.21', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 4, 0, NULL),
(82, 28, 'Fundamentos de Diseño de Software', '3.4.3.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 4, 0, NULL),
(83, 30, 'Lógica Computacional', '3.4.4.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 4, 0, NULL),
(84, 31, 'Formación Cristiana', '3.4.5.21', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 4, 0, NULL),
(85, 29, 'Teoría de la Computación', '3.4.6.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 4, 0, NULL),
(86, 30, 'Ecuaciones Diferenciales', '3.4.7.21', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 4, 0, NULL),
(87, 28, 'Arquitectura de Software', '3.5.1.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 5, 0, NULL),
(88, 29, 'Análisis y Diseño de Algoritmos', '3.5.2.21', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 5, 0, NULL),
(89, 29, 'Base de Datos I', '3.5.3.21', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 5, 0, NULL),
(90, 28, 'Métodos de Software', '3.5.4.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 5, 0, NULL),
(91, 29, 'Sistemas Operativos', '3.5.5.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 5, 0, NULL),
(92, 29, 'Compiladores', '3.5.6.21', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 5, 0, NULL),
(93, 30, 'Métodos Numéricos', '3.5.7.21', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 5, 0, NULL),
(94, 28, 'Procesos de Software', '3.6.1.21', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 6, 0, NULL),
(95, 28, 'Interacción Humano-Computador', '3.6.2.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 6, 0, NULL),
(96, 29, 'Base de Datos II', '3.6.3.21', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 6, 0, NULL),
(97, 29, 'Redes y Comunicación de Datos', '3.6.4.21', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 6, 0, NULL),
(98, 28, 'Métodos Formales en Ingeniería de Software', '3.6.5.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 6, 0, NULL),
(99, 29, 'Programación para Dispositivos Móviles', '3.6.6.21', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 6, 0, NULL),
(100, 31, 'Doctrina Social de la Iglesia', '3.6.7.21', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 6, 0, NULL),
(101, 28, 'Evaluación y Mejora de Procesos de Software', '3.7.1.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 7, 0, NULL),
(102, 29, 'Computación Distribuida y Paralela', '3.7.2.21', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 7, 0, NULL),
(103, 28, 'Construcción de Software', '3.7.3.21', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 7, 0, NULL),
(104, 28, 'Ingeniería Web', '3.7.4.21', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 7, 0, NULL),
(105, 28, 'Inteligencia de Negocios y Minería de Datos', '3.7.5.21', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 7, 0, NULL),
(106, 28, 'Auditoría de Sistemas de Información', '3.7.6.21', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 7, 0, NULL),
(107, 31, 'Epistemología', '3.7.7.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 7, 0, NULL),
(108, 29, 'Desarrollo de Videojuegos', '3.8.1.21', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 8, 0, NULL),
(109, 28, 'Calidad de Software', '3.8.2.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 8, 0, NULL),
(110, 28, 'Tecnologías de Construcción de Software', '3.8.3.21', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 8, 0, NULL),
(111, 28, 'Gestión de la Configuración y el Cambio', '3.8.4.21', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 8, 0, NULL),
(112, 28, 'Metodología de la Investigación Científica', '3.8.5.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 8, 0, NULL),
(113, 31, 'Deontología', '3.8.6.21', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 8, 0, NULL),
(114, 28, 'Electivo I', '3.8.7.21', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 8, 0, NULL),
(115, 28, 'Evolución y Mantenimiento de Software', '3.9.1.21', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 9, 0, NULL),
(116, 29, 'Internet de las Cosas y Robótica', '3.9.2.21', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 9, 0, NULL),
(117, 28, 'Gestión de Proyectos de Software', '3.9.3.21', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 9, 0, NULL),
(118, 28, 'Pruebas de Software', '3.9.4.21', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 9, 0, NULL),
(119, 28, 'Seminario de Tesis I', '3.9.5.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 9, 0, NULL),
(120, 29, 'Inteligencia Artificial', '3.9.6.21', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 9, 0, NULL),
(121, 28, 'Electivo II', '3.9.7.21', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 9, 0, NULL),
(122, 29, 'Ciberseguridad', '3.10.1.21', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 10, 0, NULL),
(123, 28, 'Tópicos Avanzados en Ingeniería de Software', '3.10.2.21', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 10, 0, NULL),
(124, 29, 'Cloud Computing', '3.10.3.21', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 10, 0, NULL),
(125, 28, 'Seminario de Tesis II', '3.10.4.21', NULL, 4, 0, 0, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 10, 0, NULL),
(126, 29, 'Tópicos Avanzados en Inteligencia Artificial', '3.10.5.21', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 10, 0, NULL),
(127, 31, 'Derechos Humanos', '3.10.6.21', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 10, 0, NULL),
(128, 28, 'Electivo III', '3.10.7.21', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 14:09:41', NULL, 1, NULL, 10, 0, NULL),
(129, 1, 'CALCULO EN UNA VARIABLE', '0201101', NULL, 4, 4, 0, NULL, 6, NULL, 1, '2024-09-17 18:10:36', NULL, 1, NULL, 11, 0, NULL),
(130, 1, 'MECANICA', '0201102', NULL, 4, 4, 0, NULL, 6, NULL, 1, '2024-09-17 18:10:36', NULL, 1, NULL, 11, 0, NULL),
(131, 2, 'ESTRUCTURAS DISCRETAS 1', '0201103', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 18:10:36', NULL, 1, NULL, 11, 0, NULL),
(132, 2, 'RELACIONES HUMANAS', '0201104', NULL, 2, 0, 0, NULL, 2, NULL, 1, '2024-09-17 18:10:36', NULL, 1, NULL, 11, 0, NULL),
(133, 1, 'INTRODUCCION A LAS CIENCIAS DE LA COMPUTACION', '0201105', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-17 18:10:36', NULL, 1, NULL, 11, 0, NULL),
(134, 1, 'METODOLOGIA DE LA PROGRAMACION', '0201106', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 18:10:36', NULL, 1, NULL, 11, 0, NULL),
(135, 1, 'CALCULO EN VARIAS VARIABLES', '0201207', NULL, 4, 4, 0, NULL, 6, NULL, 1, '2024-09-17 18:25:05', NULL, 1, NULL, 12, 0, NULL),
(136, 1, 'ELECTRICIDAD Y MAGNETISMO', '0201208', NULL, 3, 4, 0, NULL, 5, NULL, 1, '2024-09-17 18:25:05', NULL, 1, NULL, 12, 0, NULL),
(137, 2, 'COMUNICACION ORAL Y ESCRITA', '0201209', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 18:25:05', NULL, 1, NULL, 12, 0, NULL),
(138, 1, 'ESTRUCTURAS DISCRETAS 2', '0201210', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 18:25:05', NULL, 1, NULL, 12, 0, NULL),
(139, 1, 'LENGUAJE DE PROGRAMACION', '0201211', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 18:25:05', NULL, 1, NULL, 12, 0, NULL),
(140, 1, 'ALGEBRA LINEAL', '0202112', NULL, 3, 4, 0, NULL, 5, NULL, 1, '2024-09-17 18:40:34', NULL, 1, NULL, 13, 0, NULL),
(141, 2, 'GESTION EMPRESARIAL 1', '0202113', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 18:40:34', NULL, 1, NULL, 13, 0, NULL),
(142, 1, 'ESTRUCTURA DE DATOS 1', '0202114', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-17 18:40:34', NULL, 1, NULL, 13, 0, NULL),
(143, 1, 'FUNDAMENTOS DE LENGUAJE DE PROGRAMACION', '0202115', NULL, 2, 6, 0, NULL, 5, NULL, 1, '2024-09-17 18:40:34', NULL, 1, NULL, 13, 0, NULL),
(144, 3, 'TEORIA DE SISTEMAS', '0202116', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-17 18:40:34', NULL, 1, NULL, 13, 0, NULL),
(145, 29, 'Introducción a la Programación', '3.1.1.24', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 20:26:01', NULL, 1, NULL, 59, 0, NULL),
(146, 1, 'ECUACIONES DIFERENCIALES', '0202217', NULL, 3, 4, 0, NULL, 5, NULL, 1, '2024-09-17 20:30:00', NULL, 1, NULL, 14, 0, NULL),
(147, 2, 'SISTEMAS ELECTRONICOS', '0202218', NULL, 1, 4, 0, NULL, 3, NULL, 1, '2024-09-17 20:30:00', NULL, 1, NULL, 14, 0, NULL),
(148, 3, 'ESTRUCTURA DE DATOS 2', '0202219', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 20:30:00', NULL, 1, NULL, 14, 0, NULL),
(149, 2, 'GESTION EMPRESARIAL 2', '0202220', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-17 20:30:00', NULL, 1, NULL, 14, 0, NULL),
(150, 3, 'SISTEMAS DE ORGANIZACION Y METODOS', '0202221', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-17 20:30:00', NULL, 1, NULL, 14, 0, NULL),
(151, 1, 'ESTADISTICA MATEMATICA', '0203122', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 20:41:15', NULL, 1, NULL, 15, 0, NULL),
(152, 3, 'TEORIA DE LA COMPUTACION', '0203123', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 20:41:15', NULL, 1, NULL, 15, 0, NULL),
(153, 1, 'METODOS NUMERICOS', '0203124', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 20:41:15', NULL, 1, NULL, 15, 0, NULL),
(154, 3, 'SISTEMAS DIGITALES', '0203125', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 20:41:15', NULL, 1, NULL, 15, 0, NULL),
(155, 3, 'ANALISIS Y DISENO DE ALGORITMOS', '0203126', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 20:41:15', NULL, 1, NULL, 15, 0, NULL),
(156, 3, 'SISTEMAS DE INFORMACION', '0203127', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 20:41:15', NULL, 1, NULL, 15, 0, NULL),
(157, 28, 'Introducción a la Computación', '3.1.2.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 20:45:08', NULL, 1, NULL, 59, 0, NULL),
(158, 30, 'Algebra y Geometría', '3.1.3.24', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-17 20:45:08', NULL, 1, NULL, 59, 0, NULL),
(159, 31, 'Comunicación I', '3.1.4.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 20:45:08', NULL, 1, NULL, 59, 0, NULL),
(160, 31, 'Metodología del Estudio', '3.1.5.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 20:45:08', NULL, 1, NULL, 59, 0, NULL),
(161, 31, 'Expresión Artística', '3.1.6.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 20:45:08', NULL, 1, NULL, 59, 0, NULL),
(162, 2, 'PROCESOS ESTOCASTICOS', '0204133', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 20:50:14', NULL, 1, NULL, 17, 0, NULL),
(163, 3, 'COMUNICACION DE DATOS', '0204134', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 20:50:14', NULL, 1, NULL, 17, 0, NULL),
(164, 3, 'INGENIERIA DE SOFTWARE 1', '0204135', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 20:50:14', NULL, 1, NULL, 17, 0, NULL),
(165, 3, 'BASES DE DATOS 1', '0204136', NULL, 3, 4, 0, NULL, 5, NULL, 1, '2024-09-17 20:50:14', NULL, 1, NULL, 17, 0, NULL),
(166, 3, 'COMPILADORES', '0204137', NULL, 2, 6, 0, NULL, 5, NULL, 1, '2024-09-17 20:50:14', NULL, 1, NULL, 17, 0, NULL),
(167, 3, 'SISTEMAS DISTRIBUIDOS', '0204238', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 20:54:24', NULL, 1, NULL, 18, 0, NULL),
(168, 3, 'INGENIERIA DE SOFTWARE 2', '0204239', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 20:54:25', NULL, 1, NULL, 18, 0, NULL),
(169, 3, 'DESARROLLO DE SOFTWARE', '0204240', NULL, 1, 6, 0, NULL, 4, NULL, 1, '2024-09-17 20:54:25', NULL, 1, NULL, 18, 0, NULL),
(170, 3, 'INTELIGENCIA ARTIFICIAL 1', '0204241', NULL, 2, 6, 0, NULL, 5, NULL, 1, '2024-09-17 20:54:25', NULL, 1, NULL, 18, 0, NULL),
(171, 3, 'BASES DE DATOS 2', '0204242', NULL, 2, 6, 0, NULL, 5, NULL, 1, '2024-09-17 20:54:25', NULL, 1, NULL, 18, 0, NULL),
(172, 3, 'PROYECTO INFORMATICO', '0205143', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 20:57:39', NULL, 1, NULL, 19, 0, NULL),
(173, 3, 'REDES Y TELEPROCESO', '0205144', NULL, 2, 6, 0, NULL, 5, NULL, 1, '2024-09-17 20:57:39', NULL, 1, NULL, 19, 0, NULL),
(174, 3, 'AUDITORIA DE SISTEMAS', '0205145', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 20:57:39', NULL, 1, NULL, 19, 0, NULL),
(175, 3, 'INTELIGENCIA ARTIFICIAL 2', '0205146', NULL, 2, 6, 0, NULL, 5, NULL, 1, '2024-09-17 20:57:39', NULL, 1, NULL, 19, 0, NULL),
(176, 3, 'PROCESAMIENTO DIGITAL DE SENALES', '0205147', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 20:57:39', NULL, 1, NULL, 19, 0, NULL),
(177, 29, 'Lenguaje de Programación I', '3.2.1.24', NULL, 3, 0, 2, NULL, 4, NULL, 1, '2024-09-17 21:05:27', NULL, 1, NULL, 60, 0, NULL),
(178, 28, 'Introducción a la Ingeniería de Software', '3.2.2.24', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-17 21:05:27', NULL, 1, NULL, 60, 0, NULL),
(179, 30, 'Cálculo I', '3.2.3.24', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 21:05:27', NULL, 1, NULL, 60, 0, NULL),
(180, 30, 'Álgebra Lineal', '3.2.4.24', NULL, 3, 0, 2, NULL, 4, NULL, 1, '2024-09-17 21:05:27', NULL, 1, NULL, 60, 0, NULL),
(181, 31, 'Economía Política', '3.2.5.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:05:27', NULL, 1, NULL, 60, 0, NULL),
(182, 31, 'Comunicación II', '3.2.6.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:05:27', NULL, 1, NULL, 60, 0, NULL),
(183, 31, 'Doctrina Social de la Iglesia', '3.2.7.24', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-17 21:05:27', NULL, 1, NULL, 60, 0, NULL),
(184, 29, 'Lenguaje de Programación II', '3.3.1.24', NULL, 3, 0, 2, NULL, 4, NULL, 1, '2024-09-17 21:07:53', NULL, 1, NULL, 61, 0, NULL),
(185, 28, 'Fundamentos de Diseño de Software', '3.3.2.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:07:53', NULL, 1, NULL, 61, 0, NULL),
(186, 30, 'Cálculo II', '3.3.3.24', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 21:07:53', NULL, 1, NULL, 61, 0, NULL),
(187, 30, 'Matemática Discreta y Lógica Computacional', '3.3.4.24', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-17 21:07:53', NULL, 1, NULL, 61, 0, NULL),
(188, 31, 'Humanidades', '3.3.5.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:07:53', NULL, 1, NULL, 61, 0, NULL),
(189, 31, 'Formación Cristiana', '3.3.6.24', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-17 21:07:53', NULL, 1, NULL, 61, 0, NULL),
(190, 31, 'Epistemología', '3.3.7.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:07:53', NULL, 1, NULL, 61, 0, NULL),
(191, 29, 'Análisis y Diseño de Algoritmos', '3.4.1.24', NULL, 4, 0, 0, NULL, 4, NULL, 1, '2024-09-17 21:09:50', NULL, 1, NULL, 62, 0, NULL),
(192, 29, 'Estructura de Datos', '3.4.2.24', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-17 21:09:50', NULL, 1, NULL, 62, 0, NULL),
(193, 30, 'Ecuaciones Diferenciales', '3.4.3.24', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 21:09:50', NULL, 1, NULL, 62, 0, NULL),
(194, 29, 'Teoría de la Computación', '3.4.4.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:09:50', NULL, 1, NULL, 62, 0, NULL),
(195, 30, 'Álgebra Abstracta', '3.4.5.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:09:50', NULL, 1, NULL, 62, 0, NULL),
(196, 31, 'Liderazgo y Trabajo en Equipo', '3.4.6.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:09:50', NULL, 1, NULL, 62, 0, NULL),
(197, 31, 'Derechos Humanos', '3.4.7.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:09:50', NULL, 1, NULL, 62, 0, NULL),
(198, 3, 'TOPICOS AVANZADOS EN INGENIERIA DE SISTEMAS', '0205248', NULL, 4, 2, 0, NULL, 5, NULL, 1, '2024-09-17 21:09:54', NULL, 1, NULL, 20, 0, NULL),
(199, 3, 'PROYECTO DE TESIS', '0205249', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:09:54', NULL, 1, NULL, 20, 0, NULL),
(200, 3, 'TECNOLOGIAS DE LA INFORMACION', '0205250', NULL, 2, 6, 0, NULL, 5, NULL, 1, '2024-09-17 21:09:54', NULL, 1, NULL, 20, 0, NULL),
(201, 3, '0205251 TECNOLOGIAS DE OBJETOS', '0205251', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:09:54', NULL, 1, NULL, 20, 0, NULL),
(202, 3, 'COMPUTACION GRAFICA', '0205252', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 21:09:54', NULL, 1, NULL, 20, 0, NULL),
(203, 29, 'Sistemas Operativos', '3.5.1.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:11:42', NULL, 1, NULL, 63, 0, NULL),
(204, 28, 'Base de Datos I', '3.5.2.24', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-17 21:11:42', NULL, 1, NULL, 63, 0, NULL),
(205, 28, 'Métodos de Software', '3.5.3.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:11:42', NULL, 1, NULL, 63, 0, NULL),
(206, 30, 'Métodos Numéricos', '3.5.4.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:11:42', NULL, 1, NULL, 63, 0, NULL),
(207, 29, 'Compiladores', '3.5.5.24', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 21:11:42', NULL, 1, NULL, 63, 0, NULL),
(208, 28, 'Requisitos y Métodos Formales de Software', '3.5.6.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:11:42', NULL, 1, NULL, 63, 0, NULL),
(209, 28, 'Redes y Comunicación de Datos', '3.6.1.24', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 21:13:43', NULL, 1, NULL, 64, 0, NULL),
(210, 28, 'Base de Datos II', '3.6.2.24', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-17 21:13:43', NULL, 1, NULL, 64, 0, NULL),
(211, 28, 'Evaluación de Mejora y Procesos de Software', '3.6.3.24', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-17 21:13:43', NULL, 1, NULL, 64, 0, NULL),
(212, 30, 'Estadística y Probabilidades', '3.6.4.24', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 21:13:43', NULL, 1, NULL, 64, 0, NULL),
(213, 28, 'Arquitectura de Software', '3.6.5.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:13:43', NULL, 1, NULL, 64, 0, NULL),
(214, 28, 'Inglés Aplicado', '3.6.6.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:13:43', NULL, 1, NULL, 64, 0, NULL),
(215, 29, 'Computación Distribuida y Paralela', '3.7.1.24', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 21:15:22', NULL, 1, NULL, 65, 0, NULL),
(216, 28, 'Auditoría de Sistemas de Información', '3.7.2.24', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 21:15:22', NULL, 1, NULL, 65, 0, NULL),
(217, 28, 'Interacción Humano - Computador', '3.7.3.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:15:22', NULL, 1, NULL, 65, 0, NULL),
(218, 29, 'Inteligencia Artificial', '3.7.4.24', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 21:15:22', NULL, 1, NULL, 65, 0, NULL),
(219, 29, 'Programación para Dispositivos Móviles', '3.7.5.24', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-17 21:15:22', NULL, 1, NULL, 65, 0, NULL),
(220, 28, 'Electivo I', '3.7.6.24', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 21:15:22', NULL, 1, NULL, 65, 0, NULL),
(221, 28, 'Ingeniería Web', '3.8.1.24', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-17 21:16:43', NULL, 1, NULL, 66, 0, NULL),
(222, 28, 'Ciberseguridad', '3.8.2.24', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 21:16:43', NULL, 1, NULL, 66, 0, NULL),
(223, 28, 'Calidad y Pruebas de Software', '3.8.3.24', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 21:16:43', NULL, 1, NULL, 66, 0, NULL),
(224, 28, 'Inteligencia de Negocios y Minería de Datos', '3.8.4.24', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 21:16:43', NULL, 1, NULL, 66, 0, NULL),
(225, 28, 'Tecnologías de Construcción de Software', '3.8.5.24', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 21:16:43', NULL, 1, NULL, 66, 0, NULL),
(226, 28, 'Metodología de la Investigación Científica', '3.8.6.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:16:43', NULL, 1, NULL, 66, 0, NULL),
(227, 31, 'Ética General y Aplicada', '3.8.7.24', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-17 21:16:43', NULL, 1, NULL, 66, 0, NULL),
(228, 28, 'Electivo II', '3.9.1.24', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 21:18:45', NULL, 1, NULL, 67, 0, NULL),
(229, 29, 'Internet de las Cosas y Robótica', '3.9.2.24', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 21:18:46', NULL, 1, NULL, 67, 0, NULL),
(230, 28, 'Construcción de Software', '3.9.3.24', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-17 21:18:46', NULL, 1, NULL, 67, 0, NULL),
(231, 28, 'Tópicos Avanzados en Inteligencia Artificial', '3.9.4.24', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 21:18:46', NULL, 1, NULL, 67, 0, NULL),
(232, 28, 'Evolución y Mantenimiento de Software', '3.9.5.24', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 21:18:46', NULL, 1, NULL, 67, 0, NULL),
(233, 28, 'Seminario de Tesis I', '3.9.6.24', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:18:46', NULL, 1, NULL, 67, 0, NULL),
(234, 28, 'Desarrollo de Videojuegos', '3.10.1.24', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-17 21:19:30', NULL, 1, NULL, 68, 0, NULL),
(235, 28, 'Electivo III', '3.10.2.24', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 21:19:30', NULL, 1, NULL, 68, 0, NULL),
(236, 28, 'Gestión de Proyectos de Software', '3.10.3.24', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-17 21:19:30', NULL, 1, NULL, 68, 0, NULL),
(237, 29, 'Cloud Computing', '3.10.4.24', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 21:19:30', NULL, 1, NULL, 68, 0, NULL),
(238, 28, 'Tópicos Avanzados en Ingeniería de Software', '3.10.5.24', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 21:19:30', NULL, 1, NULL, 68, 0, NULL),
(239, 28, 'Seminario de Tesis II', '3.10.6.24', NULL, 4, 0, 0, NULL, 4, NULL, 1, '2024-09-17 21:19:30', NULL, 1, NULL, 68, 0, NULL),
(240, 31, 'Doctrina social de la iglesia', '3.7.1.16', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-17 21:29:09', NULL, 1, NULL, 26, 0, NULL),
(241, 28, 'Interacción humano - computador', '3.7.2.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:29:09', NULL, 1, NULL, 26, 0, NULL),
(242, 28, 'Métodos de software', '3.7.3.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:29:09', NULL, 1, NULL, 26, 0, NULL),
(243, 28, 'Construcción de software', '3.7.4.16', NULL, 4, 0, 4, NULL, 4, NULL, 1, '2024-09-17 21:29:09', NULL, 1, NULL, 26, 0, NULL),
(244, 29, 'Computación distribuida y paralela', '3.7.5.16', NULL, 2, 0, 2, NULL, 5, NULL, 1, '2024-09-17 21:29:09', NULL, 1, NULL, 26, 0, NULL),
(245, 28, 'Modelos de software', '3.7.6.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:29:09', NULL, 1, NULL, 26, 0, NULL),
(246, 31, 'Historia del Perú', '3.7.7.16', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-17 21:29:09', NULL, 1, NULL, 26, 0, NULL),
(247, 31, 'Doctrina social de la iglesia', '3.8.1.16', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-17 21:36:32', NULL, 1, NULL, 27, 0, NULL),
(248, 28, 'Calidad de software', '3.8.2.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:36:32', NULL, 1, NULL, 27, 0, NULL),
(249, 28, 'Mantenimiento de software', '3.8.3.16', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 21:36:32', NULL, 1, NULL, 27, 0, NULL),
(250, 28, 'Tecnologías de construcción de software', '3.8.4.16', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 21:36:32', NULL, 1, NULL, 27, 0, NULL),
(251, 28, 'Seminario en tecnología I', '3.8.5.16', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-17 21:36:32', NULL, 1, NULL, 27, 0, NULL),
(252, 28, 'Ingeniería web', '3.8.6.16', NULL, 4, 0, 2, NULL, 5, NULL, 1, '2024-09-17 21:36:32', NULL, 1, NULL, 27, 0, NULL),
(253, 31, 'Deontología aplicada', '3.8.7.16', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-17 21:36:32', NULL, 1, NULL, 27, 0, NULL),
(254, 28, 'Gestión de la configuración y del cambio', '3.9.1.16', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-17 21:50:00', NULL, 1, NULL, 28, 0, NULL),
(255, 28, 'Pruebas de software', '3.9.2.16', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-17 21:50:00', NULL, 1, NULL, 28, 0, NULL),
(256, 28, 'Auditoría de sistemas de información', '3.9.3.16', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-17 21:50:00', NULL, 1, NULL, 28, 0, NULL),
(257, 28, 'Gestión de proyectos de software', '3.9.4.16', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-17 21:50:00', NULL, 1, NULL, 28, 0, NULL),
(258, 28, 'Seminario de tesis I', '3.9.5.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:50:00', NULL, 1, NULL, 28, 0, NULL),
(259, 28, 'Tópicos avanzados en ingeniería de software', '3.9.6.16', NULL, 4, 0, 0, NULL, 4, NULL, 1, '2024-09-17 21:50:00', NULL, 1, NULL, 28, 0, NULL),
(260, 31, 'Epistemología', '3.9.7.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-17 21:50:00', NULL, 1, NULL, 28, 0, NULL),
(261, 2, 'METODOS NUMERICOS', '9503124', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 02:13:22', NULL, 1, NULL, 33, 0, NULL),
(262, 1, 'ESTADISTICA MATEMATICA', '9503125', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 02:13:22', NULL, 1, NULL, 33, 0, NULL),
(263, 2, 'SISTEMAS DIGITALES', '9503126', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-18 02:13:22', NULL, 1, NULL, 33, 0, NULL),
(264, 2, 'ANALISIS Y DISENO DE ALGORITMOS', '9503127', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 02:13:22', NULL, 1, NULL, 33, 0, NULL),
(265, 2, 'SISTEMAS DE PRODUCCION', '9503128', NULL, 2, 0, 0, NULL, 3, NULL, 1, '2024-09-18 02:13:22', NULL, 1, NULL, 33, 0, NULL),
(266, 3, 'METODOLOGIA DE LA INVESTIGACION (E)', '9503129', NULL, 2, 0, 0, NULL, 2, NULL, 1, '2024-09-18 02:13:22', NULL, 1, NULL, 33, 0, NULL),
(267, 3, 'LEGISLACION (E)', '9503130', NULL, 2, 0, 0, NULL, 2, NULL, 1, '2024-09-18 02:13:22', NULL, 1, NULL, 33, 0, NULL),
(268, 2, 'PROGRAMACION MATEMATICA', '9503231', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 02:17:45', NULL, 1, NULL, 34, 0, NULL),
(269, 2, 'ARQUITECTURA DE COMPUTADORAS 1', '9503232', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-18 02:17:45', NULL, 1, NULL, 34, 0, NULL),
(270, 2, 'LENGUAJES DE MAQUINA', '9503233', NULL, 1, 4, 2, NULL, 4, NULL, 1, '2024-09-18 02:17:45', NULL, 1, NULL, 34, 0, NULL),
(271, 2, 'PROGRAMACION MATEMATICA', '9503231', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 02:18:26', NULL, 1, NULL, 34, 0, NULL),
(272, 2, 'ARQUITECTURA DE COMPUTADORAS 1', '9503232', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-18 02:18:26', NULL, 1, NULL, 34, 0, NULL),
(273, 2, 'LENGUAJES DE MAQUINA', '9503233', NULL, 1, 4, 2, NULL, 4, NULL, 1, '2024-09-18 02:18:26', NULL, 1, NULL, 34, 0, NULL),
(274, 1, 'ORGANIZACION Y METODOS', '9503234', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-18 02:18:26', NULL, 1, NULL, 34, 0, NULL),
(275, 2, 'TEORIA DE COMPUTACION', '9503235', NULL, 4, 2, 0, NULL, 5, NULL, 1, '2024-09-18 02:18:26', NULL, 1, NULL, 34, 0, NULL),
(276, 2, 'PROCESOS ESTOCASTICOS', '9504136', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 02:24:56', NULL, 1, NULL, 35, 0, NULL),
(277, 2, 'ARQUITECTURA DE COMPUTADORAS 2', '9504137', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-18 02:24:56', NULL, 1, NULL, 35, 0, NULL),
(278, 2, 'SISTEMAS DE INFORMACION', '9504138', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 02:24:56', NULL, 1, NULL, 35, 0, NULL),
(279, 2, 'SISTEMAS OPERATIVOS', '9504139', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 02:24:56', NULL, 1, NULL, 35, 0, NULL),
(280, 2, 'EVALUACION DE PROYECTOS', '9504140', NULL, 1, 2, 0, NULL, 3, NULL, 1, '2024-09-18 02:24:56', NULL, 1, NULL, 35, 0, NULL),
(281, 2, 'DINAMICA DE SISTEMAS (E)', '9504141', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 02:24:56', NULL, 1, NULL, 35, 0, NULL),
(282, 3, 'ERGONOMIA (E)', '9504142', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 02:24:56', NULL, 1, NULL, 35, 0, NULL),
(283, 2, 'COMUNICACION DE DATOS', '9504243', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-18 02:34:31', NULL, 1, NULL, 36, 0, NULL),
(284, 2, 'COMPILADORES', '9504244', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 02:34:31', NULL, 1, NULL, 36, 0, NULL),
(285, 2, 'SOFTWARE DE APLICACION 1', '9504245', NULL, 1, 6, 2, NULL, 5, NULL, 1, '2024-09-18 02:34:31', NULL, 1, NULL, 36, 0, NULL),
(286, 2, 'SISTEMAS EXPERTOS', '9504246', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-18 02:34:31', NULL, 1, NULL, 36, 0, NULL),
(287, 2, 'ANALISIS Y DISENO DE SISTEMAS', '9504247', NULL, 4, 0, 0, NULL, 4, NULL, 1, '2024-09-18 02:34:31', NULL, 1, NULL, 36, 0, NULL),
(288, 2, 'TECNICAS ASISTIDAS POR COMPUTADOR (E)', '9504248', NULL, 1, 4, 0, NULL, 3, NULL, 1, '2024-09-18 02:34:31', NULL, 1, NULL, 36, 0, NULL),
(289, 2, 'SEMINARIO DE ESTRUCTURAS AVANZADAS (E)', '9504249', NULL, 0, 3, 0, NULL, 3, NULL, 1, '2024-09-18 02:34:31', NULL, 1, NULL, 36, 0, NULL),
(290, 2, 'SISTEMA DISTRIBUIDOS (E)', '9504250', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 02:34:31', NULL, 1, NULL, 36, 0, NULL),
(291, 2, 'REDES DE COMPUTADORAS', '9505151', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 02:39:52', NULL, 1, NULL, 37, 0, NULL),
(292, 2, 'SISTEMAS DE INFORMACION GERENCIAL', '9505152', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 02:39:52', NULL, 1, NULL, 37, 0, NULL),
(293, 2, 'GERENCIA DE SISTEMAS', '9505153', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-18 02:39:52', NULL, 1, NULL, 37, 0, NULL),
(294, 2, 'DISENO Y GESTION DE BASES DE DATOS', '9505154', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 02:39:52', NULL, 1, NULL, 37, 0, NULL),
(295, 2, 'INTELIGENCIA ARTIFICIAL', '9505155', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 02:39:52', NULL, 1, NULL, 37, 0, NULL),
(296, 2, 'SOFTWARE DE APLICACION 2 (E)', '9505156', NULL, 1, 4, 0, NULL, 3, NULL, 1, '2024-09-18 02:39:52', NULL, 1, NULL, 37, 0, NULL),
(297, 2, 'COMPUTACION GRAFICA (E)', '9505157', NULL, 1, 4, 0, NULL, 3, NULL, 1, '2024-09-18 02:39:52', NULL, 1, NULL, 37, 0, NULL),
(298, 2, 'PROGRAMACION PARALELA (E)', '9505158', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 02:39:52', NULL, 1, NULL, 37, 0, NULL),
(299, 2, 'GESTION DE PROYECTOS DE SOPORTE LOGICO', '9505259', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 02:43:30', NULL, 1, NULL, 38, 0, NULL),
(300, 2, 'INGENIERIA DE SOFTWARE', '9505260', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 02:43:30', NULL, 1, NULL, 38, 0, NULL),
(301, 3, 'PROYECTO DE TESIS', '9505261', NULL, 1, 6, 2, NULL, 8, NULL, 1, '2024-09-18 02:43:30', NULL, 1, NULL, 38, 0, NULL),
(302, 2, 'AUDITORIA DE SISTEMAS', '9505262', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 02:43:30', NULL, 1, NULL, 38, 0, NULL),
(303, 3, 'REINGENIERIA (E)', '9505263', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 02:43:30', NULL, 1, NULL, 38, 0, NULL),
(304, 28, 'Economía en la\r\ningeniería de software', '3.0.1.16', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-18 02:52:33', NULL, 1, NULL, 69, 0, NULL),
(305, 28, 'Evaluación y mejora de\r\nprocesos de software', '3.0.2.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 02:52:33', NULL, 1, NULL, 69, 0, NULL),
(306, 28, 'Seguridad informática', '3.0.3.16', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-18 02:52:33', NULL, 1, NULL, 69, 0, NULL),
(307, 28, 'Seminario en\r\ntecnología II', '3.0.4.16', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-18 02:52:33', NULL, 1, NULL, 69, 0, NULL),
(308, 28, 'Seminario de tesis II', '3.0.5.16', NULL, 4, 0, 0, NULL, 4, NULL, 1, '2024-09-18 02:52:33', NULL, 1, NULL, 69, 0, NULL),
(309, 29, 'Inteligencia artificial', '3.0.6.16', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-18 02:52:33', NULL, 1, NULL, 69, 0, NULL),
(310, 31, 'Derechos humanos', '3.0.7.16', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-18 02:52:33', NULL, 1, NULL, 69, 0, NULL),
(311, 32, 'Fundamentos en\r\nCiencias de la\r\nComputación', '30101', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 02:57:18', NULL, 1, NULL, 70, 0, NULL),
(312, 32, 'Introducción a la\r\nprogramación', '30102', NULL, 2, 2, 4, NULL, 5, NULL, 1, '2024-09-18 02:57:18', NULL, 1, NULL, 70, 0, NULL),
(313, 33, 'Introducción a la\r\nfilosofía', '30103', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 02:57:18', NULL, 1, NULL, 70, 0, NULL),
(314, 32, 'Metodología del\r\nEstudio', '30104', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 02:57:18', NULL, 1, NULL, 70, 0, NULL),
(315, 33, 'Comunicación', '30105', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 02:57:18', NULL, 1, NULL, 70, 0, NULL),
(324, 4, 'Razonamiento Lógico Matemático', '1701102', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 03:47:04', NULL, 1, NULL, 92, 0, NULL),
(325, 4, 'Matemática Básica', '1701103', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-18 03:47:04', NULL, 1, NULL, 92, 0, NULL),
(326, 6, 'Estructuras Discretas 1', '1701104', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 03:47:04', NULL, 1, NULL, 92, 0, NULL),
(327, 6, 'Introducción a la Computación', '1701105', NULL, 1, 2, 0, NULL, 2, NULL, 1, '2024-09-18 03:47:04', NULL, 1, NULL, 92, 0, NULL),
(328, 6, 'Fundamentos de la Programación 1', '1701106', NULL, 2, 2, 4, NULL, 5, NULL, 1, '2024-09-18 03:47:04', NULL, 1, NULL, 92, 0, NULL),
(329, 4, 'Metodología del Trabajo Intelectual Universitario', '1701114', NULL, 0, 4, 0, NULL, 2, NULL, 1, '2024-09-18 03:47:04', NULL, 1, NULL, 92, 0, NULL),
(330, 5, 'Relaciones Humanas en Empresas de Desarrollo de Software y Base Tecnológica', '1701145', NULL, 1, 2, 0, NULL, 2, NULL, 1, '2024-09-18 03:47:04', NULL, 1, NULL, 92, 0, NULL),
(331, 4, 'CÁLCULO EN UNA VARIABLE', '1701210', NULL, 1, 6, 0, NULL, 4, NULL, 1, '2024-09-18 03:50:22', NULL, 1, NULL, 93, 0, NULL),
(332, 6, 'ESTRUCTURAS DISCRETAS 2', '1701211', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 03:50:22', NULL, 1, NULL, 93, 0, NULL),
(333, 6, 'PROGRAMACIÓN WEB 1', '1701212', NULL, 2, 0, 0, NULL, 4, NULL, 1, '2024-09-18 03:50:22', NULL, 1, NULL, 93, 0, NULL),
(334, 6, 'FUNDAMENTOS DE PROGRAMACIÓN 2', '1701213', NULL, 2, 2, 4, NULL, 5, NULL, 1, '2024-09-18 03:50:22', NULL, 1, NULL, 93, 0, NULL),
(335, 4, 'COMUNICACIÓN INTEGRAL', '1701216', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 03:50:22', NULL, 1, NULL, 93, 0, NULL),
(336, 5, 'REALIDAD NACIONAL', '1701217', NULL, 1, 2, 0, NULL, 2, NULL, 1, '2024-09-18 03:50:22', NULL, 1, NULL, 93, 0, NULL),
(361, 3, 'TALLER DE LIDERAZGO Y COLABORACION', '1301212', NULL, 2, 0, 0, NULL, 2, NULL, 1, '2024-09-18 04:02:48', NULL, 1, NULL, 40, 0, NULL),
(362, 6, 'BASE DE DATOS', '1703133', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 04:03:27', NULL, 1, NULL, 96, 0, NULL),
(363, 6, 'PROGRAMACION DE SISTEMAS', '1703134', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-18 04:03:27', NULL, 1, NULL, 96, 0, NULL),
(364, 6, 'INGENIERIA Y PROCESOS DE SOFTWARE', '1703135', NULL, 1, 4, 0, NULL, 3, NULL, 1, '2024-09-18 04:03:27', NULL, 1, NULL, 96, 0, NULL),
(365, 6, 'TEORIA DE LA COMPUTACION', '1703136', NULL, 1, 2, 2, NULL, 3, NULL, 1, '2024-09-18 04:03:27', NULL, 1, NULL, 96, 0, NULL),
(366, 6, 'ORGANIZACION Y METODOS', '1703137', NULL, 1, 2, 2, NULL, 3, NULL, 1, '2024-09-18 04:03:28', NULL, 1, NULL, 96, 0, NULL),
(367, 6, 'INVESTIGACION DE OPERACIONES', '1703138', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 04:03:28', NULL, 1, NULL, 96, 0, NULL),
(368, 1, 'ALGEBRA LINEAL', '1302113', NULL, 2, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:07:46', NULL, 1, NULL, 41, 0, NULL),
(369, 1, 'ESTADISTICA MATEMATICA PROBABILIDADES Y METODOS EMPIRICOS', '1302114', NULL, 2, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:07:46', NULL, 1, NULL, 41, 0, NULL),
(370, 3, 'TALLERES DE PSICOLOGIA', '1302115', NULL, 2, 0, 0, NULL, 2, NULL, 1, '2024-09-18 04:07:46', NULL, 1, NULL, 41, 0, NULL),
(371, 2, 'ESTRUCTURA DE DATOS Y ALGORITMOS', '1302116', NULL, 2, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:07:46', NULL, 1, NULL, 41, 0, NULL),
(372, 2, 'PROGRAMACION WEB 2', '1302117', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-18 04:07:46', NULL, 1, NULL, 41, 0, NULL),
(373, 2, 'ETICA PROFESIONAL Y ASPECTOS LEGALES', '1302118', NULL, 2, 0, 0, NULL, 2, NULL, 1, '2024-09-18 04:07:46', NULL, 1, NULL, 41, 0, NULL),
(374, 3, 'REDACCION DE ARTICULOS E INFORMES DE INVESTIGACION', '1302119', NULL, 2, 0, 0, NULL, 2, NULL, 1, '2024-09-18 04:07:46', NULL, 1, NULL, 41, 0, NULL),
(375, 5, 'TALLERES DE PSICOLOGIA', '1702118', NULL, 2, 0, 0, NULL, 2, NULL, 1, '2024-09-18 04:08:27', NULL, 1, NULL, 94, 0, NULL),
(376, 4, 'CALCULO EN VARIAS VARIABLES', '1702119', NULL, 1, 6, 0, NULL, 4, NULL, 1, '2024-09-18 04:08:27', NULL, 1, NULL, 94, 0, NULL),
(377, 5, 'TALLER DE LIDERAZGO Y COLABORACION', '1702120', NULL, 2, 0, 0, NULL, 2, NULL, 1, '2024-09-18 04:08:27', NULL, 1, NULL, 94, 0, NULL),
(378, 5, 'INNOVACION Y CREATIVIDAD', '1702121', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 04:08:27', NULL, 1, NULL, 94, 0, NULL),
(379, 6, 'PROGRAMACION WEB 2', '1702122', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-18 04:08:27', NULL, 1, NULL, 94, 0, NULL),
(380, 6, 'REDACCION DE ARTICULOS E INFORMES DE INVESTIGACION', '1702123', NULL, 2, 0, 0, NULL, 2, NULL, 1, '2024-09-18 04:08:27', NULL, 1, NULL, 94, 0, NULL),
(381, 6, 'ESTRUCTURA DE DATOS Y ALGORITMOS', '1702124', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 04:08:27', NULL, 1, NULL, 94, 0, NULL),
(382, 5, 'CIUDADANIA E INTERCULTURALIDAD', '1702125', NULL, 1, 2, 0, NULL, 2, NULL, 1, '2024-09-18 04:08:27', NULL, 1, NULL, 94, 0, NULL),
(383, 4, 'ESTADISTICA MATEMATICA, PROBABILIDADES Y METODOS EMPIRICOS', '1702226', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 04:10:40', NULL, 1, NULL, 95, 0, NULL),
(384, 6, 'ARQUITECTURA DE COMPUTADORAS', '1702227', NULL, 1, 2, 2, NULL, 3, NULL, 1, '2024-09-18 04:10:40', NULL, 1, NULL, 95, 0, NULL),
(385, 6, 'METODOS DE INVESTIGACION Y REDACCION', '1702228', NULL, 1, 2, 0, NULL, 2, NULL, 1, '2024-09-18 04:10:40', NULL, 1, NULL, 95, 0, NULL),
(386, 6, 'INTERACCION HUMANO COMPUTADOR', '1702229', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 04:10:40', NULL, 1, NULL, 95, 0, NULL),
(387, 6, 'ENFOQUE EMPRESARIAL', '1702230', NULL, 1, 4, 0, NULL, 3, NULL, 1, '2024-09-18 04:10:40', NULL, 1, NULL, 95, 0, NULL),
(388, 6, 'ANALISIS Y DISEÑO DE ALGORITMOS', '1702231', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 04:10:40', NULL, 1, NULL, 95, 0, NULL),
(389, 5, 'ECOLOGIA Y CONSERVACION AMBIENTAL', '1702278', NULL, 1, 2, 0, NULL, 2, NULL, 1, '2024-09-18 04:10:40', NULL, 1, NULL, 95, 0, NULL),
(390, 6, 'BASE DE DATOS', '1703133', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 04:12:50', NULL, 1, NULL, 96, 0, NULL),
(391, 6, 'PROGRAMACION DE SISTEMAS', '1703134', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-18 04:12:50', NULL, 1, NULL, 96, 0, NULL),
(392, 6, 'INGENIERIA Y PROCESOS DE SOFTWARE', '1703135', NULL, 1, 4, 0, NULL, 3, NULL, 1, '2024-09-18 04:12:50', NULL, 1, NULL, 96, 0, NULL),
(393, 6, 'TEORIA DE LA COMPUTACION', '1703136', NULL, 1, 2, 2, NULL, 3, NULL, 1, '2024-09-18 04:12:50', NULL, 1, NULL, 96, 0, NULL),
(394, 6, 'ORGANIZACION Y METODOS', '1703137', NULL, 1, 2, 2, NULL, 3, NULL, 1, '2024-09-18 04:12:50', NULL, 1, NULL, 96, 0, NULL),
(395, 6, 'INVESTIGACION DE OPERACIONES', '1703138', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 04:12:50', NULL, 1, NULL, 96, 0, NULL),
(396, 6, 'REDES Y COMUNICACION DE DATOS', '1703239', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 04:14:53', NULL, 1, NULL, 97, 0, NULL),
(397, 6, 'TECNOLOGIA DE OBJETOS', '1703240', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 04:14:53', NULL, 1, NULL, 97, 0, NULL),
(398, 6, 'SISTEMAS OPERATIVOS', '1703241', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 04:14:53', NULL, 1, NULL, 97, 0, NULL),
(399, 6, 'FUNDAMENTOS DE SISTEMAS DE INFORMACION', '1703242', NULL, 1, 4, 0, NULL, 3, NULL, 1, '2024-09-18 04:14:53', NULL, 1, NULL, 97, 0, NULL),
(400, 6, 'CONSTRUCCION DE SOFTWARE', '1703243', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-18 04:14:53', NULL, 1, NULL, 97, 0, NULL),
(401, 6, 'METODOS NUMERICOS', '1703244', NULL, 1, 2, 2, NULL, 3, NULL, 1, '2024-09-18 04:14:53', NULL, 1, NULL, 97, 0, NULL),
(402, 4, 'FISICA COMPUTACIONAL', '1704146', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:17:13', NULL, 1, NULL, 98, 0, NULL),
(403, 6, 'TECNOLOGIAS DE INFORMACION', '1704147', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 04:17:13', NULL, 1, NULL, 98, 0, NULL),
(404, 6, 'INTELIGENCIA ARTIFICIAL', '1704148', NULL, 1, 4, 0, NULL, 3, NULL, 1, '2024-09-18 04:17:13', NULL, 1, NULL, 98, 0, NULL),
(405, 6, 'INGENIERIA DE REQUERIMIENTOS', '1704149', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 04:17:13', NULL, 1, NULL, 98, 0, NULL),
(406, 6, 'SISTEMAS DISTRIBUIDOS', '1704150', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 04:17:13', NULL, 1, NULL, 98, 0, NULL),
(407, 6, 'PRUEBAS DE SOFTWARE', '1704151', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:17:13', NULL, 1, NULL, 98, 0, NULL),
(408, 4, 'INGLES', '1704153', NULL, 1, 2, 0, NULL, 2, NULL, 1, '2024-09-18 04:17:13', NULL, 1, NULL, 98, 0, NULL),
(409, 2, 'ARQUITECTURA DE COMPUTADORES', '1302220', NULL, 1, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:17:46', NULL, 1, NULL, 42, 0, NULL),
(410, 2, 'BASES DE DATOS', '1302221', NULL, 2, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:17:46', NULL, 1, NULL, 42, 0, NULL);
INSERT INTO `courses` (`id`, `area_id`, `name`, `code`, `description`, `theory_hours`, `practice_hours`, `lab_hours`, `summary`, `credits`, `semi_hours`, `status`, `created`, `modified`, `created_id`, `modified_id`, `semester_id`, `theory_pracs_hours`, `prq_cred`) VALUES
(411, 1, 'METODOS NUMERICOS', '1302222', NULL, 2, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:17:46', NULL, 1, NULL, 42, 0, NULL),
(412, 2, 'INTERACCION HUMANO COMPUTADOR', '1302223', NULL, 1, 0, 4, NULL, 4, NULL, 1, '2024-09-18 04:17:46', NULL, 1, NULL, 42, 0, NULL),
(413, 2, 'ENFOQUE EMPRESARIAL', '1302224', NULL, 1, 0, 0, NULL, 3, NULL, 1, '2024-09-18 04:17:47', NULL, 1, NULL, 42, 0, NULL),
(414, 2, 'ANALISIS Y DISENO DE ALGORITMOS', '1302225', NULL, 2, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:17:47', NULL, 1, NULL, 42, 0, NULL),
(415, 2, 'PROGRAMACION DE SISTEMAS', '1303126', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-18 04:18:15', NULL, 1, NULL, 43, 0, NULL),
(416, 2, 'INTRODUCCION A LA INGENIERIA DE SOFTWARE', '1303127', NULL, 3, 0, 0, NULL, 4, NULL, 1, '2024-09-18 04:18:15', NULL, 1, NULL, 43, 0, NULL),
(417, 1, 'FISICA COMPUTACIONAL', '1303128', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:18:15', NULL, 1, NULL, 43, 0, NULL),
(418, 2, 'TEORIA DE LA COMPUTACION', '1303129', NULL, 2, 0, 4, NULL, 5, NULL, 1, '2024-09-18 04:18:15', NULL, 1, NULL, 43, 0, NULL),
(419, 3, 'INNOVACION Y CREATIVIDAD', '1303130', NULL, 2, 0, 0, NULL, 3, NULL, 1, '2024-09-18 04:18:15', NULL, 1, NULL, 43, 0, NULL),
(420, 3, 'ORGANIZACION Y METODOS', '1303131', NULL, 2, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:18:15', NULL, 1, NULL, 43, 0, NULL),
(421, 2, 'CONSTRUCCION DE SOFTWARE', '1303232', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-18 04:18:50', NULL, 1, NULL, 44, 0, NULL),
(422, 2, 'REDES Y COMUNICACION DE DATOS', '1303233', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-18 04:18:50', NULL, 1, NULL, 44, 0, NULL),
(423, 2, 'TECNOLOGIAS DE OBJETOS', '1303234', NULL, 2, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:18:50', NULL, 1, NULL, 44, 0, NULL),
(424, 2, 'SISTEMAS OPERATIVOS', '1303235', NULL, 2, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:18:50', NULL, 1, NULL, 44, 0, NULL),
(425, 2, 'FUNDAMENTOS DE SISTEMAS DE INFORMACION', '1303236', NULL, 3, 0, 0, NULL, 4, NULL, 1, '2024-09-18 04:18:50', NULL, 1, NULL, 44, 0, NULL),
(426, 3, 'METODOS DE INVESTIGACION Y REDACCION', '1303237', NULL, 1, 0, 0, NULL, 2, NULL, 1, '2024-09-18 04:18:50', NULL, 1, NULL, 44, 0, NULL),
(427, 6, 'GESTION DE PROYECTOS DE SOFTWARE', '1704252', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:19:24', NULL, 1, NULL, 99, 0, NULL),
(428, 6, 'CALIDAD DE SOFTWARE', '1704254', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:19:24', NULL, 1, NULL, 99, 0, NULL),
(429, 6, 'AUDITORIA DE SISTEMAS', '1704255', NULL, 1, 4, 0, NULL, 3, NULL, 1, '2024-09-18 04:19:24', NULL, 1, NULL, 99, 0, NULL),
(430, 6, 'DISEÑO Y ARQUITECTURA DE SOFTWARE', '1704256', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 04:19:24', NULL, 1, NULL, 99, 0, NULL),
(431, 7, 'NEGOCIOS ELECTRONICOS', '1704257', NULL, 3, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:19:24', NULL, 1, NULL, 99, 0, NULL),
(432, 7, 'INTRODUCCION AL DESARROLLO DE SOFTWARE DE ENTRETENIMIENTO', '1704258', NULL, 3, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:19:24', NULL, 1, NULL, 99, 0, NULL),
(433, 7, 'INTRODUCCION AL DESARROLLO DE NUEVAS PLATAFORMAS', '1704259', NULL, 3, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:19:24', NULL, 1, NULL, 99, 0, NULL),
(434, 7, 'ASPECTOS FORMALES DE ESPECIFICACION Y VERIFICACION', '1704260', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:19:24', NULL, 1, NULL, 99, 0, NULL),
(435, 3, 'INVESTIGACION DE OPERACIONES', '1304138', NULL, 2, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:20:52', NULL, 1, NULL, 45, 0, NULL),
(436, 2, 'TECNOLOGIAS DE LA INFORMACION', '1304139', NULL, 2, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:20:52', NULL, 1, NULL, 45, 0, NULL),
(437, 2, 'INTELIGENCIA ARTIFICIAL', '1304140', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:20:52', NULL, 1, NULL, 45, 0, NULL),
(438, 2, 'DISENO Y ARQUITECTURA DE SOFTWARE', '1304141', NULL, 2, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:20:52', NULL, 1, NULL, 45, 0, NULL),
(439, 2, 'SISTEMAS DISTRIBUIDOS', '1304142', NULL, 2, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:20:52', NULL, 1, NULL, 45, 0, NULL),
(440, 3, 'AUDITORIA DE INGENIERIA DE SOFTWARE', '1304143', NULL, 1, 0, 0, NULL, 2, NULL, 1, '2024-09-18 04:20:52', NULL, 1, NULL, 45, 0, NULL),
(441, 7, 'PROYECTO DE INGENIERIA DE SOFTWARE 1', '1705161', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:21:26', NULL, 1, NULL, 100, 0, NULL),
(442, 6, 'SEMINARIO DE TESIS 1', '1705162', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 04:21:26', NULL, 1, NULL, 100, 0, NULL),
(443, 7, 'GESTION DE EMPRENDIMIENTO DE SOFTWARE', '1705163', NULL, 1, 2, 0, NULL, 2, NULL, 1, '2024-09-18 04:21:26', NULL, 1, NULL, 100, 0, NULL),
(444, 7, 'SEGURIDAD INFORMATICA', '1705164', NULL, 1, 2, 2, NULL, 3, NULL, 1, '2024-09-18 04:21:26', NULL, 1, NULL, 100, 0, NULL),
(445, 7, 'MANTENIMIENTO, CONFIGURACION Y EVOLUCION DE SOFTWARE', '1705165', NULL, 1, 2, 2, NULL, 3, NULL, 1, '2024-09-18 04:21:26', NULL, 1, NULL, 100, 0, NULL),
(446, 5, 'ETICA GENERAL Y PROFESIONAL', '1705166', NULL, 1, 2, 0, NULL, 2, NULL, 1, '2024-09-18 04:21:26', NULL, 1, NULL, 100, 0, NULL),
(447, 7, 'TOPICOS AVANZADOS EN BASES DE DATOS', '1705167', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-18 04:21:26', NULL, 1, NULL, 100, 0, NULL),
(448, 7, 'COMPUTACION GRAFICA, VISION COMPUTACIONAL Y MULTIMEDIA', '1705168', NULL, 3, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:21:26', NULL, 1, NULL, 100, 0, NULL),
(449, 7, 'DESARROLLO AVANZADO EN NUEVAS PLATAFORMAS', '1705169', NULL, 3, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:21:26', NULL, 1, NULL, 100, 0, NULL),
(450, 2, 'ASPECTOS FORMALES DE VERIFICACION Y ESPECIFICACION', '1304244', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:22:00', NULL, 1, NULL, 46, 0, NULL),
(451, 2, 'GESTION DE PROYECTOS DE SOFTWARE', '1304245', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:22:00', NULL, 1, NULL, 46, 0, NULL),
(452, 2, 'CALIDAD DE SOFTWARE', '1304246', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:22:00', NULL, 1, NULL, 46, 0, NULL),
(453, 2, 'PRUEBAS DE SOFTWARE', '1304247', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-18 04:22:00', NULL, 1, NULL, 46, 0, NULL),
(454, 2, 'INGENIERIA DE REQUERIMIENTOS', '1304248', NULL, 2, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:22:00', NULL, 1, NULL, 46, 0, NULL),
(455, 2, 'NEGOCIOS ELECTRONICOS (E)', '1304249', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:22:00', NULL, 1, NULL, 46, 0, NULL),
(456, 2, 'INTRODUCCION AL DESARROLLO DE SOFTWARE DE ENTRETENIMIENTO (E)', '1304250', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:22:00', NULL, 1, NULL, 46, 0, NULL),
(457, 2, 'INTRODUCCION AL DESARROLLO DE NUEVAS PLATAFORMAS (E)', '1304251', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:22:00', NULL, 1, NULL, 46, 0, NULL),
(458, 3, 'PROYECTO DE INGENIERIA DE SOFTWARE 1', '1305152', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-18 04:22:40', NULL, 1, NULL, 47, 0, NULL),
(459, 3, 'PROYECTO DE TESIS', '1305153', NULL, 2, 0, 0, NULL, 4, NULL, 1, '2024-09-18 04:22:40', NULL, 1, NULL, 47, 0, NULL),
(460, 3, 'GESTION DE EMPRENDIMIENTOS DE SOFTWARE 1', '1305154', NULL, 1, 0, 0, NULL, 2, NULL, 1, '2024-09-18 04:22:40', NULL, 1, NULL, 47, 0, NULL),
(461, 2, 'SISTEMAS DE SEGURIDAD CRITICA', '1305155', NULL, 2, 0, 2, NULL, 4, NULL, 1, '2024-09-18 04:22:40', NULL, 1, NULL, 47, 0, NULL),
(462, 2, 'MANTENIMIENTO, CONFIGURACION Y EVOLUCION DE SOFTWARE', '1305156', NULL, 1, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:22:40', NULL, 1, NULL, 47, 0, NULL),
(463, 2, 'GESTION DE SISTEMAS Y TECNOLOGIAS DE INFORMACION (E)', '1305157', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:22:40', NULL, 1, NULL, 47, 0, NULL),
(464, 2, 'MULTIMEDIA Y REALIDAD VIRTUAL (E)', '1305158', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:22:40', NULL, 1, NULL, 47, 0, NULL),
(465, 2, 'DESARROLLO EN NUEVAS PLATAFORMAS AVANZADO (E)', '1305159', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:22:40', NULL, 1, NULL, 47, 0, NULL),
(466, 7, 'TOPICOS AVANZADOS EN INGENIERIA DE SOFTWARE', '1705270', NULL, 1, 2, 2, NULL, 3, NULL, 1, '2024-09-18 04:23:00', NULL, 1, NULL, 101, 0, NULL),
(467, 7, 'PRACTICAS PRE PROFESIONALES', '1705271', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 04:23:00', NULL, 1, NULL, 101, 0, NULL),
(468, 6, 'SEMINARIO DE TESIS 2', '1705272', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-18 04:23:00', NULL, 1, NULL, 101, 0, NULL),
(469, 7, 'PROYECTO DE INGENIERIA DE SOFTWARE 2', '1705273', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:23:00', NULL, 1, NULL, 101, 0, NULL),
(470, 7, 'GESTION DE SISTEMAS Y TECNOLOGIAS DE INFORMACION', '1705274', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:23:00', NULL, 1, NULL, 101, 0, NULL),
(471, 7, 'DESARROLLO DE SOFTWARE PARA JUEGOS', '1705275', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:23:00', NULL, 1, NULL, 101, 0, NULL),
(472, 7, 'PLATAFORMAS EMERGENTES', '1705276', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:23:01', NULL, 1, NULL, 101, 0, NULL),
(473, 2, 'TOPICOS AVANZADOS EN INGENIERIA DE SOFTWARE', '1305260', NULL, 1, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:23:42', NULL, 1, NULL, 48, 0, NULL),
(474, 3, 'PRACTICAS PRE-PROFESIONALES', '1305261', NULL, 2, 0, 0, NULL, 4, NULL, 1, '2024-09-18 04:23:42', NULL, 1, NULL, 48, 0, NULL),
(475, 3, 'SEMINARIO DE TESIS', '1305262', NULL, 3, 0, 0, NULL, 4, NULL, 1, '2024-09-18 04:23:42', NULL, 1, NULL, 48, 0, NULL),
(476, 3, 'GESTION DE EMPRENDIMIENTOS DE SOFTWARE 2', '1305263', NULL, 1, 0, 0, NULL, 2, NULL, 1, '2024-09-18 04:23:42', NULL, 1, NULL, 48, 0, NULL),
(477, 2, 'PROYECTO DE INGENIERIA DE SOFTWARE 2', '1305264', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-18 04:23:42', NULL, 1, NULL, 48, 0, NULL),
(478, 2, 'INTELIGENCIA DE NEGOCIOS (E)', '1305265', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:23:42', NULL, 1, NULL, 48, 0, NULL),
(479, 2, 'DESARROLLO DE SOFTWARE PARA JUEGOS (E)', '1305266', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:23:42', NULL, 1, NULL, 48, 0, NULL),
(480, 2, 'PLATAFORMAS EMERGENTES (E)', '1305267', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 04:23:42', NULL, 1, NULL, 48, 0, NULL),
(500, 29, 'Introducción a la computación', '3.1.1.16', NULL, 4, 0, 0, NULL, 4, NULL, 1, '2024-09-18 04:34:33', NULL, 1, NULL, 80, 0, NULL),
(501, 29, 'Introducción a la programación', '3.1.2.16', NULL, 4, 0, 4, NULL, 6, NULL, 1, '2024-09-18 04:34:33', NULL, 1, NULL, 80, 0, NULL),
(502, 31, 'Comunicación I', '3.1.3.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 04:34:34', NULL, 1, NULL, 80, 0, NULL),
(503, 31, 'Economía política', '3.1.4.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 04:34:34', NULL, 1, NULL, 80, 0, NULL),
(504, 30, 'Álgebra y geometría', '3.1.5.16', NULL, 4, 2, 0, NULL, 5, NULL, 1, '2024-09-18 04:34:34', NULL, 1, NULL, 80, 0, NULL),
(505, 31, 'Metodología del estudio', '3.1.6.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 04:34:34', NULL, 1, NULL, 80, 0, NULL),
(506, 30, 'Matemática discreta I', '3.2.1.16', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-18 04:37:24', NULL, 1, NULL, 81, 0, NULL),
(507, 29, 'Lenguaje de programación I', '3.2.2.16', NULL, 1, 0, 4, NULL, 3, NULL, 1, '2024-09-18 04:37:24', NULL, 1, NULL, 81, 0, NULL),
(508, 30, 'Cálculo I', '3.2.3.16', NULL, 3, 2, 2, NULL, 5, NULL, 1, '2024-09-18 04:37:24', NULL, 1, NULL, 81, 0, NULL),
(509, 31, 'Comunicación II', '3.2.4.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 04:37:24', NULL, 1, NULL, 81, 0, NULL),
(510, 28, 'Introducción a la ingeniería de software', '3.2.5.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 04:37:24', NULL, 1, NULL, 81, 0, NULL),
(511, 30, 'Álgebra lineal', '3.2.6.16', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 04:37:24', NULL, 1, NULL, 81, 0, NULL),
(512, 31, 'Expresión artística', '3.2.7.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 04:37:24', NULL, 1, NULL, 81, 0, NULL),
(513, 30, 'Estadística inferencial', '3.3.1.16', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 04:39:41', NULL, 1, NULL, 82, 0, NULL),
(514, 30, 'Matemática discreta II', '3.3.2.16', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-18 04:39:41', NULL, 1, NULL, 82, 0, NULL),
(515, 29, 'Lenguaje de programación II', '3.3.3.16', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-18 04:39:41', NULL, 1, NULL, 82, 0, NULL),
(516, 28, 'Requisitos de software', '3.3.4.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 04:39:41', NULL, 1, NULL, 82, 0, NULL),
(517, 30, 'Cálculo II', '3.3.5.16', NULL, 3, 2, 2, NULL, 5, NULL, 1, '2024-09-18 04:39:41', NULL, 1, NULL, 82, 0, NULL),
(518, 30, 'Ecuaciones diferenciales ', '3.3.6.16', NULL, 3, 2, 2, NULL, 5, NULL, 1, '2024-09-18 04:39:41', NULL, 1, NULL, 82, 0, NULL),
(519, 30, 'Lógica computacional', '3.4.1.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 05:47:36', NULL, 1, NULL, 83, 0, NULL),
(520, 30, 'Métodos numéricos', '3.4.2.16', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 05:47:36', NULL, 1, NULL, 83, 0, NULL),
(521, 29, 'Teoría de la computación', '3.4.3.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 05:47:36', NULL, 1, NULL, 83, 0, NULL),
(522, 30, 'Cálculo de probabilidades', '3.4.4.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 05:47:36', NULL, 1, NULL, 83, 0, NULL),
(523, 29, 'Lenguaje de programación III', '3.4.5.16', NULL, 0, 0, 4, NULL, 4, NULL, 1, '2024-09-18 05:47:37', NULL, 1, NULL, 83, 0, NULL),
(524, 29, 'Estructura de datos', '3.4.6.16', NULL, 0, 0, 4, NULL, 4, NULL, 1, '2024-09-18 05:47:37', NULL, 1, NULL, 83, 0, NULL),
(525, 30, 'Álgebra abstracta', '3.4.7.16', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 05:47:37', NULL, 1, NULL, 83, 0, NULL),
(526, 28, 'Fundamentos de diseño de software', '3.5.1.16', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 05:48:05', NULL, 1, NULL, 84, 0, NULL),
(527, 29, 'Análisis y diseño de algoritmos', '3.5.2.16', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 05:48:05', NULL, 1, NULL, 84, 0, NULL),
(528, 28, 'Métodos formales en ingeniería de software', '3.5.3.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 05:48:05', NULL, 1, NULL, 84, 0, NULL),
(529, 29, 'Base de datos I', '3.5.4.16', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-18 05:48:05', NULL, 1, NULL, 84, 0, NULL),
(530, 29, 'Sistemas operativos', '3.5.5.16', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-18 05:48:05', NULL, 1, NULL, 84, 0, NULL),
(531, 29, 'Fundamentos de lenguajes de programación', '3.5.6.16', NULL, 2, 0, 2, NULL, 3, NULL, 1, '2024-09-18 05:48:05', NULL, 1, NULL, 84, 0, NULL),
(532, 28, 'Inglés aplicado', '3.5.7.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 05:48:05', NULL, 1, NULL, 84, 0, NULL),
(533, 28, 'Arquitectura de software', '3.6.1.16', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-18 05:48:41', NULL, 1, NULL, 85, 0, NULL),
(534, 28, 'Procesos de software', '3.6.2.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 05:48:41', NULL, 1, NULL, 85, 0, NULL),
(535, 29, 'Redes y comunicación de datos', '3.6.3.16', NULL, 3, 0, 2, NULL, 4, NULL, 1, '2024-09-18 05:48:41', NULL, 1, NULL, 85, 0, NULL),
(536, 29, 'Base de datos II', '3.6.4.16', NULL, 2, 0, 4, NULL, 4, NULL, 1, '2024-09-18 05:48:41', NULL, 1, NULL, 85, 0, NULL),
(537, 31, 'Metodología de la investigación científica', '3.6.5.16', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 05:48:41', NULL, 1, NULL, 85, 0, NULL),
(538, 29, 'Compiladores', '3.6.6.16', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 05:48:41', NULL, 1, NULL, 85, 0, NULL),
(539, 31, 'Formación cristiana', '3.6.7.16', NULL, 3, 0, 0, NULL, 3, NULL, 1, '2024-09-18 05:48:41', NULL, 1, NULL, 85, 0, NULL),
(540, 1, 'Cálculo en una variable', '9701101', NULL, 4, 2, 0, NULL, 6, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 49, 0, NULL),
(541, 1, 'Estructuras Discretas 1', '9701102', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 49, 0, NULL),
(542, 1, 'Mecánica', '9701103', NULL, 4, 2, 0, NULL, 6, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 49, 0, NULL),
(543, 1, 'Dibujo en Ingeniería', '9701104', NULL, 2, 0, 0, NULL, 3, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 49, 0, NULL),
(544, 1, 'Informática Básica', '9701144', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 49, 0, NULL),
(545, 1, 'Cálculo en varias variables', '9701206', NULL, 4, 2, 0, NULL, 6, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 50, 0, NULL),
(546, 1, 'Introducción a Ingeniería de Sistemas', '9701207', NULL, 4, 2, 0, NULL, 6, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 50, 0, NULL),
(547, 1, 'Estructuras Discretas 2', '9701208', NULL, 4, 2, 0, NULL, 6, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 50, 0, NULL),
(548, 2, 'Taller de Programación', '9701245', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 50, 0, NULL),
(549, 1, 'Álgebra Lineal', '9702110', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 51, 0, NULL),
(550, 1, 'Electricidad y Magnetismo', '9702111', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 51, 0, NULL),
(551, 1, 'Fundamentos de Lenguaje de Programación', '9702112', NULL, 2, 4, 0, NULL, 6, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 51, 0, NULL),
(552, 1, 'Economía', '9702113', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 51, 0, NULL),
(553, 1, 'Ecuaciones Diferenciales', '9702214', NULL, 4, 2, 0, NULL, 6, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 52, 0, NULL),
(554, 1, 'Estadística Matemática', '9702215', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 52, 0, NULL),
(555, 1, 'Contabilidad y Finanzas', '9702216', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 52, 0, NULL),
(556, 1, 'Estructura de Datos y Algoritmos', '9702217', NULL, 4, 2, 0, NULL, 6, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 52, 0, NULL),
(557, 1, 'Métodos Numéricos', '9703118', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 53, 0, NULL),
(558, 1, 'Sistemas Digitales', '9703119', NULL, 2, 4, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 53, 0, NULL),
(559, 1, 'Programación Matemática', '9703120', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 53, 0, NULL),
(560, 1, 'Sistemas de Organización y Métodos', '9703121', NULL, 3, 4, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 53, 0, NULL),
(561, 1, 'Metodología de la Investigación', '9703122', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 53, 0, NULL),
(562, 1, 'Procesos Estocásticos', '9703223', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 54, 0, NULL),
(563, 1, 'Teoría de Sistemas', '9703224', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 54, 0, NULL),
(564, 1, 'Lenguaje de Máquinas', '9703225', NULL, 1, 2, 0, NULL, 4, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 54, 0, NULL),
(565, 1, 'Sistemas de Información', '9703226', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:12', NULL, 1, NULL, 54, 0, NULL),
(566, 2, 'Análisis y Diseño de Algoritmos', '9703246', NULL, 2, 4, 0, NULL, 4, NULL, 1, '2024-09-18 16:25:13', NULL, 1, NULL, 54, 0, NULL),
(567, 1, 'Compiladores', '9704128', NULL, 4, 2, 0, NULL, 6, NULL, 1, '2024-09-18 16:25:13', NULL, 1, NULL, 55, 0, NULL),
(568, 1, 'Arquitectura de Multiprocesadores', '9704129', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:13', NULL, 1, NULL, 55, 0, NULL),
(569, 1, 'Sistemas Operativos', '9704130', NULL, 4, 2, 0, NULL, 6, NULL, 1, '2024-09-18 16:25:13', NULL, 1, NULL, 55, 0, NULL),
(570, 1, 'Análisis y Diseño de Sistemas', '9704131', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:13', NULL, 1, NULL, 55, 0, NULL),
(571, 1, 'Comunicación de Datos', '9704232', NULL, 4, 2, 0, NULL, 6, NULL, 1, '2024-09-18 16:25:13', NULL, 1, NULL, 56, 0, NULL),
(572, 1, 'Diseño y Gestión de Base de Datos', '9704233', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:13', NULL, 1, NULL, 56, 0, NULL),
(573, 1, 'Inteligencia Artificial', '9704234', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:13', NULL, 1, NULL, 56, 0, NULL),
(574, 1, 'Ingeniería de Software', '9704235', NULL, 4, 2, 0, NULL, 6, NULL, 1, '2024-09-18 16:25:13', NULL, 1, NULL, 56, 0, NULL),
(575, 1, 'Redes y Teleproceso', '9705136', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:13', NULL, 1, NULL, 57, 0, NULL),
(576, 1, 'Evaluación de Proyectos', '9705137', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:13', NULL, 1, NULL, 57, 0, NULL),
(577, 1, 'Tópicos de Inteligencia Artificial', '9705138', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:13', NULL, 1, NULL, 57, 0, NULL),
(578, 1, 'Software de Aplicación', '9705139', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:13', NULL, 1, NULL, 57, 0, NULL),
(579, 1, 'Gestión de Proyectos y Soporte Lógico', '9705240', NULL, 4, 4, 0, NULL, 7, NULL, 1, '2024-09-18 16:25:13', NULL, 1, NULL, 58, 0, NULL),
(580, 1, 'Auditoría de Sistemas', '9705241', NULL, 3, 4, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:13', NULL, 1, NULL, 58, 0, NULL),
(581, 1, 'Proyecto de Tesis', '9705242', NULL, 1, 4, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:13', NULL, 1, NULL, 58, 0, NULL),
(582, 1, 'Tópicos Avanzados de Ingeniería de Sistemas', '9705243', NULL, 2, 4, 0, NULL, 5, NULL, 1, '2024-09-18 16:25:13', NULL, 1, NULL, 58, 0, NULL),
(583, 34, 'Programación Orientada a Objetos', '30201', NULL, 4, 0, 4, NULL, 6, NULL, 1, '2024-09-18 16:29:55', NULL, 1, NULL, 71, 0, NULL),
(584, 32, 'Matemática Discreta I', '30202', NULL, 4, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:29:55', NULL, 1, NULL, 71, 0, NULL),
(585, 33, 'Psicología y Dinámica de Grupos', '30203', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 16:29:55', NULL, 1, NULL, 71, 0, NULL),
(586, 33, 'Expresión Artística', '30204', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 16:29:55', NULL, 1, NULL, 71, 0, NULL),
(587, 32, 'Cálculo', '30205', NULL, 4, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:29:55', NULL, 1, NULL, 71, 0, NULL),
(588, 30, 'Matemática Discreta II', '30301', NULL, 4, 2, 0, NULL, 5, NULL, 1, '2024-09-18 16:29:55', NULL, 1, NULL, 72, 0, NULL),
(589, 30, 'Estructura de Datos y Algoritmos', '30302', NULL, 2, 2, 2, NULL, 5, NULL, 1, '2024-09-18 16:29:55', NULL, 1, NULL, 72, 0, NULL),
(590, 29, 'Física', '30303', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 16:29:55', NULL, 1, NULL, 72, 0, NULL),
(591, 28, 'Tecnología de Objetos', '30304', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 16:29:55', NULL, 1, NULL, 72, 0, NULL),
(592, 30, 'Probabilidades y Estadística', '30305', NULL, 3, 2, 0, NULL, 4, NULL, 1, '2024-09-18 16:29:56', NULL, 1, NULL, 72, 0, NULL),
(593, 30, 'Sistemas Operativos', '30401', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 16:29:56', NULL, 1, NULL, 73, 0, NULL),
(594, 30, 'Teoría de la Computación', '30402', NULL, 4, 2, 2, NULL, 5, NULL, 1, '2024-09-18 16:29:56', NULL, 1, NULL, 73, 0, NULL),
(595, 29, 'Análisis y Diseño de Algoritmos', '30403', NULL, 2, 2, 2, NULL, 4, NULL, 1, '2024-09-18 16:29:56', NULL, 1, NULL, 73, 0, NULL),
(596, 30, 'Introducción a la Ingeniería de Software', '30404', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 16:29:56', NULL, 1, NULL, 73, 0, NULL),
(597, 29, 'Base de Datos I', '30405', NULL, 2, 0, 2, NULL, 4, NULL, 1, '2024-09-18 16:29:56', NULL, 1, NULL, 73, 0, NULL),
(598, 32, 'Algebra y Geometría', '30106', NULL, 2, 2, 0, NULL, 3, NULL, 1, '2024-09-18 17:50:59', NULL, 1, NULL, 70, 0, NULL),
(599, 34, 'Lógica Computacional', '30522', NULL, 3, 0, 2, NULL, 5, NULL, 1, '2024-09-18 21:27:36', NULL, 1, NULL, 74, 0, NULL),
(600, 33, 'Realidad Nacional y Regional', '30523', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-18 21:27:36', NULL, 1, NULL, 74, 0, NULL),
(601, 34, 'Base de Datos II', '30524', NULL, 2, 2, 2, NULL, 6, NULL, 1, '2024-09-18 21:27:36', NULL, 1, NULL, 74, 0, NULL),
(602, 34, 'Tecnologías y Sistemas WEB', '30525', NULL, 4, 0, 2, NULL, 6, NULL, 1, '2024-09-18 21:27:36', NULL, 1, NULL, 74, 0, NULL),
(603, 35, 'Diseño y Arquitectura de Software', '30526', NULL, 2, 2, 4, NULL, 8, NULL, 1, '2024-09-18 21:27:36', NULL, 1, NULL, 74, 0, NULL),
(604, 34, 'Redes y Comunicación de Datos', '30627', NULL, 2, 2, 2, NULL, 6, NULL, 1, '2024-09-18 21:28:51', NULL, 1, NULL, 75, 0, NULL),
(605, 34, 'Computación Paralela y Concurrente', '30628', NULL, 2, 2, 2, NULL, 6, NULL, 1, '2024-09-18 21:28:51', NULL, 1, NULL, 75, 0, NULL),
(606, 34, 'Compiladores', '30629', NULL, 4, 0, 2, NULL, 6, NULL, 1, '2024-09-18 21:28:51', NULL, 1, NULL, 75, 0, NULL),
(607, 33, 'Formación Cristiana', '30630', NULL, 2, 2, 0, NULL, 6, NULL, 1, '2024-09-18 21:28:51', NULL, 1, NULL, 75, 0, NULL),
(608, 36, 'Análisis de Requerimientos\r\nde Software', '30631', NULL, 3, 2, 0, NULL, 5, NULL, 1, '2024-09-18 21:28:51', NULL, 1, NULL, 75, 0, NULL),
(609, 34, 'Seguridad Informática', '30701', NULL, 2, 2, 2, NULL, 6, NULL, 1, '2024-09-18 21:32:14', NULL, 1, NULL, 76, 0, NULL),
(610, 33, 'Liderazgo y Trabajo en Equipo', '30702', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-18 21:32:14', NULL, 1, NULL, 76, 0, NULL),
(611, 33, 'Doctrina Social de la Iglesia', '30703', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-18 21:32:14', NULL, 1, NULL, 76, 0, NULL),
(612, 35, 'Pruebas y Calidad de Software', '30704', NULL, 2, 2, 2, NULL, 6, NULL, 1, '2024-09-18 21:32:14', NULL, 1, NULL, 76, 0, NULL),
(613, 34, 'Interacción Humano Computador', '30705', NULL, 2, 2, 0, NULL, 4, NULL, 1, '2024-09-18 21:32:14', NULL, 1, NULL, 76, 0, NULL),
(614, 34, 'Sistemas Distribuidos', '30706', NULL, 2, 2, 2, NULL, 6, NULL, 1, '2024-09-18 21:32:14', NULL, 1, NULL, 76, 0, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `course_loads`
--

CREATE TABLE `course_loads` (
  `id` int NOT NULL,
  `details` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT NULL,
  `created_id` int NOT NULL,
  `modified_id` int DEFAULT NULL,
  `professor_id` int DEFAULT NULL,
  `course_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `course_prerequisites`
--

CREATE TABLE `course_prerequisites` (
  `id` int NOT NULL,
  `course_id` int DEFAULT NULL,
  `prerequisite_id` int DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created` timestamp NOT NULL,
  `modified` timestamp NULL DEFAULT NULL,
  `created_id` int NOT NULL DEFAULT '1',
  `modified_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `course_prerequisites`
--

INSERT INTO `course_prerequisites` (`id`, `course_id`, `prerequisite_id`, `status`, `created`, `modified`, `created_id`, `modified_id`) VALUES
(1, 14, 8, 1, '2024-09-18 13:31:49', NULL, 1, NULL),
(2, 15, 9, 1, '2024-09-18 13:35:24', NULL, 1, NULL),
(3, 16, 8, 1, '2024-09-18 13:35:24', NULL, 1, NULL),
(4, 17, 10, 1, '2024-09-18 13:35:24', NULL, 1, NULL),
(5, 16, 8, 1, '2024-09-18 13:35:51', NULL, 1, NULL),
(6, 15, 9, 1, '2024-09-18 13:36:18', NULL, 1, NULL),
(7, 17, 10, 1, '2024-09-18 13:36:18', NULL, 1, NULL),
(8, 15, 9, 1, '2024-09-18 13:38:11', NULL, 1, NULL),
(9, 17, 10, 1, '2024-09-18 13:38:11', NULL, 1, NULL),
(10, 17, 12, 1, '2024-09-18 13:38:11', NULL, 1, NULL),
(11, 17, 10, 1, '2024-09-18 13:38:55', NULL, 1, NULL),
(12, 15, 9, 1, '2024-09-18 13:39:19', NULL, 1, NULL),
(13, 18, 13, 1, '2024-09-18 13:44:36', NULL, 1, NULL),
(14, 19, 11, 1, '2024-09-18 13:44:36', NULL, 1, NULL),
(15, 17, 12, 1, '2024-09-18 13:45:10', NULL, 1, NULL),
(16, 21, 14, 1, '2024-09-18 13:51:01', NULL, 1, NULL),
(17, 22, 16, 1, '2024-09-18 13:51:01', NULL, 1, NULL),
(18, 23, 17, 1, '2024-09-18 13:51:01', NULL, 1, NULL),
(19, 24, 17, 1, '2024-09-18 13:51:01', NULL, 1, NULL),
(20, 24, 15, 1, '2024-09-18 13:51:01', NULL, 1, NULL),
(21, 20, 14, 1, '2024-09-18 13:53:01', NULL, 1, NULL),
(22, 21, 14, 1, '2024-09-18 13:53:48', NULL, 1, NULL),
(23, 22, 16, 1, '2024-09-18 13:53:48', NULL, 1, NULL),
(24, 23, 17, 1, '2024-09-18 13:53:48', NULL, 1, NULL),
(25, 24, 17, 1, '2024-09-18 13:54:45', NULL, 1, NULL),
(26, 24, 15, 1, '2024-09-18 13:54:45', NULL, 1, NULL),
(27, 24, 17, 1, '2024-09-18 13:56:05', NULL, 1, NULL),
(28, 24, 15, 1, '2024-09-18 13:56:05', NULL, 1, NULL),
(29, 25, 18, 1, '2024-09-18 13:56:05', NULL, 1, NULL),
(30, 26, 21, 1, '2024-09-18 14:03:49', NULL, 1, NULL),
(31, 26, 20, 1, '2024-09-18 14:03:49', NULL, 1, NULL),
(32, 26, 21, 1, '2024-09-18 14:04:29', NULL, 1, NULL),
(33, 26, 20, 1, '2024-09-18 14:04:29', NULL, 1, NULL),
(34, 27, 22, 1, '2024-09-18 14:04:29', NULL, 1, NULL),
(35, 26, 21, 1, '2024-09-18 14:05:03', NULL, 1, NULL),
(36, 26, 20, 1, '2024-09-18 14:05:03', NULL, 1, NULL),
(37, 27, 22, 1, '2024-09-18 14:05:03', NULL, 1, NULL),
(38, 28, 19, 1, '2024-09-18 14:05:03', NULL, 1, NULL),
(39, 35, 23, 1, '2024-09-18 14:05:03', NULL, 1, NULL),
(40, 36, 24, 1, '2024-09-18 14:05:03', NULL, 1, NULL),
(41, 262, 20, 1, '2024-09-18 14:11:42', NULL, 1, NULL),
(42, 263, 27, 1, '2024-09-18 14:11:42', NULL, 1, NULL),
(43, 262, 20, 1, '2024-09-18 14:12:19', NULL, 1, NULL),
(44, 263, 27, 1, '2024-09-18 14:12:19', NULL, 1, NULL),
(45, 264, 36, 1, '2024-09-18 14:12:19', NULL, 1, NULL),
(46, 265, 28, 1, '2024-09-18 14:12:19', NULL, 1, NULL),
(47, 265, 35, 1, '2024-09-18 14:12:19', NULL, 1, NULL),
(48, 266, 18, 1, '2024-09-18 14:12:19', NULL, 1, NULL),
(49, 267, 35, 1, '2024-09-18 14:12:19', NULL, 1, NULL),
(50, 261, 26, 1, '2024-09-18 14:13:31', NULL, 1, NULL),
(51, 264, 26, 1, '2024-09-18 14:13:31', NULL, 1, NULL),
(52, 268, 21, 1, '2024-09-18 14:16:36', NULL, 1, NULL),
(53, 269, 263, 1, '2024-09-18 14:16:36', NULL, 1, NULL),
(54, 270, 263, 1, '2024-09-18 14:16:36', NULL, 1, NULL),
(55, 274, 265, 1, '2024-09-18 14:16:36', NULL, 1, NULL),
(56, 275, 264, 1, '2024-09-18 14:16:36', NULL, 1, NULL),
(57, 276, 268, 1, '2024-09-18 14:20:21', NULL, 1, NULL),
(58, 276, 262, 1, '2024-09-18 14:20:21', NULL, 1, NULL),
(59, 277, 269, 1, '2024-09-18 14:20:21', NULL, 1, NULL),
(60, 278, 274, 1, '2024-09-18 14:20:21', NULL, 1, NULL),
(61, 279, 264, 1, '2024-09-18 14:20:21', NULL, 1, NULL),
(62, 280, 268, 1, '2024-09-18 14:20:21', NULL, 1, NULL),
(63, 280, 265, 1, '2024-09-18 14:20:21', NULL, 1, NULL),
(64, 281, 274, 1, '2024-09-18 14:20:21', NULL, 1, NULL),
(65, 282, 274, 1, '2024-09-18 14:20:21', NULL, 1, NULL),
(66, 283, 277, 1, '2024-09-18 14:24:00', NULL, 1, NULL),
(67, 283, 276, 1, '2024-09-18 14:24:00', NULL, 1, NULL),
(68, 284, 275, 1, '2024-09-18 14:24:00', NULL, 1, NULL),
(69, 285, 277, 1, '2024-09-18 14:24:00', NULL, 1, NULL),
(70, 285, 278, 1, '2024-09-18 14:24:00', NULL, 1, NULL),
(71, 286, 279, 1, '2024-09-18 14:24:00', NULL, 1, NULL),
(72, 287, 278, 1, '2024-09-18 14:24:00', NULL, 1, NULL),
(73, 288, 277, 1, '2024-09-18 14:24:00', NULL, 1, NULL),
(74, 289, 278, 1, '2024-09-18 14:24:00', NULL, 1, NULL),
(75, 289, 279, 1, '2024-09-18 14:24:00', NULL, 1, NULL),
(76, 290, 279, 1, '2024-09-18 14:24:00', NULL, 1, NULL),
(77, 291, 283, 1, '2024-09-18 14:27:18', NULL, 1, NULL),
(78, 292, 287, 1, '2024-09-18 14:27:18', NULL, 1, NULL),
(79, 293, 287, 1, '2024-09-18 14:27:18', NULL, 1, NULL),
(80, 294, 287, 1, '2024-09-18 14:27:18', NULL, 1, NULL),
(81, 295, 286, 1, '2024-09-18 14:27:18', NULL, 1, NULL),
(82, 296, 285, 1, '2024-09-18 14:27:18', NULL, 1, NULL),
(83, 297, 285, 1, '2024-09-18 14:27:18', NULL, 1, NULL),
(84, 298, 277, 1, '2024-09-18 14:27:18', NULL, 1, NULL),
(85, 299, 294, 1, '2024-09-18 14:29:22', NULL, 1, NULL),
(86, 300, 294, 1, '2024-09-18 14:29:22', NULL, 1, NULL),
(87, 300, 291, 1, '2024-09-18 14:29:22', NULL, 1, NULL),
(88, 302, 292, 1, '2024-09-18 14:29:22', NULL, 1, NULL),
(89, 299, 294, 1, '2024-09-18 14:30:02', NULL, 1, NULL),
(90, 300, 294, 1, '2024-09-18 14:30:02', NULL, 1, NULL),
(91, 300, 291, 1, '2024-09-18 14:30:02', NULL, 1, NULL),
(92, 302, 292, 1, '2024-09-18 14:30:02', NULL, 1, NULL),
(93, 299, 294, 1, '2024-09-18 14:33:45', NULL, 1, NULL),
(94, 300, 294, 1, '2024-09-18 14:33:45', NULL, 1, NULL),
(95, 300, 291, 1, '2024-09-18 14:33:45', NULL, 1, NULL),
(96, 302, 292, 1, '2024-09-18 14:33:45', NULL, 1, NULL),
(97, 303, 292, 1, '2024-09-18 14:33:45', NULL, 1, NULL),
(98, 304, 257, 1, '2024-09-18 14:39:44', NULL, 1, NULL),
(99, 305, 255, 1, '2024-09-18 14:39:44', NULL, 1, NULL),
(100, 306, 256, 1, '2024-09-18 14:39:44', NULL, 1, NULL),
(101, 307, 259, 1, '2024-09-18 14:39:44', NULL, 1, NULL),
(102, 308, 259, 1, '2024-09-18 14:39:44', NULL, 1, NULL),
(103, 309, 258, 1, '2024-09-18 14:39:44', NULL, 1, NULL),
(104, 59, 2, 1, '2024-09-18 15:55:54', NULL, 1, NULL),
(105, 62, 6, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(106, 63, 57, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(107, 66, 59, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(108, 67, 60, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(109, 69, 61, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(110, 70, 62, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(111, 72, 62, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(112, 73, 66, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(113, 74, 66, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(114, 75, 67, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(115, 78, 69, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(116, 79, 72, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(117, 87, 75, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(118, 88, 74, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(119, 89, 73, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(120, 90, 76, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(121, 92, 78, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(122, 93, 79, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(123, 96, 89, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(124, 97, 91, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(125, 98, 90, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(126, 101, 94, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(127, 102, 97, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(128, 103, 88, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(129, 104, 96, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(130, 106, 98, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(131, 108, 104, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(132, 109, 101, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(133, 110, 103, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(134, 115, 111, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(135, 116, 110, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(136, 118, 109, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(137, 120, 105, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(138, 122, 106, 1, '2024-09-18 16:27:45', NULL, 1, NULL),
(139, 123, 115, 1, '2024-09-18 16:27:46', NULL, 1, NULL),
(140, 124, 102, 1, '2024-09-18 16:27:46', NULL, 1, NULL),
(141, 126, 120, 1, '2024-09-18 16:27:46', NULL, 1, NULL),
(142, 38, 314, 1, '2024-09-18 16:48:12', NULL, 1, NULL),
(143, 51, 40, 1, '2024-09-18 16:53:12', NULL, 1, NULL),
(144, 52, 41, 1, '2024-09-18 16:53:12', NULL, 1, NULL),
(145, 53, 44, 1, '2024-09-18 16:53:12', NULL, 1, NULL),
(146, 54, 45, 1, '2024-09-18 16:53:12', NULL, 1, NULL),
(147, 545, 540, 1, '2024-09-18 16:54:06', NULL, 1, NULL),
(148, 546, 543, 1, '2024-09-18 16:54:06', NULL, 1, NULL),
(149, 547, 541, 1, '2024-09-18 16:54:06', NULL, 1, NULL),
(150, 548, 544, 1, '2024-09-18 16:54:06', NULL, 1, NULL),
(151, 549, 545, 1, '2024-09-18 16:54:06', NULL, 1, NULL),
(152, 550, 542, 1, '2024-09-18 16:54:06', NULL, 1, NULL),
(153, 551, 546, 1, '2024-09-18 16:54:06', NULL, 1, NULL),
(154, 553, 549, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(155, 554, 545, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(156, 555, 552, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(157, 556, 547, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(158, 556, 551, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(159, 557, 553, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(160, 558, 550, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(161, 559, 554, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(162, 560, 555, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(163, 562, 559, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(164, 563, 560, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(165, 564, 558, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(166, 565, 560, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(167, 566, 556, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(168, 567, 556, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(169, 568, 564, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(170, 569, 556, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(171, 570, 563, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(172, 570, 565, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(173, 571, 562, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(174, 572, 570, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(175, 573, 569, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(176, 574, 570, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(177, 575, 571, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(178, 576, 566, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(179, 577, 573, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(180, 578, 567, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(181, 578, 574, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(182, 579, 575, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(183, 579, 578, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(184, 579, 572, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(185, 580, 574, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(186, 581, 576, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(187, 582, 577, 1, '2024-09-18 16:54:07', NULL, 1, NULL),
(188, 44, 37, 1, '2024-09-18 16:54:19', NULL, 1, NULL),
(189, 45, 40, 1, '2024-09-18 16:54:19', NULL, 1, NULL),
(190, 44, 37, 1, '2024-09-18 16:54:39', NULL, 1, NULL),
(191, 45, 40, 1, '2024-09-18 16:54:39', NULL, 1, NULL),
(192, 44, 37, 1, '2024-09-18 16:54:51', NULL, 1, NULL),
(193, 45, 40, 1, '2024-09-18 16:54:51', NULL, 1, NULL),
(194, 44, 37, 1, '2024-09-18 16:54:58', NULL, 1, NULL),
(195, 45, 40, 1, '2024-09-18 16:54:58', NULL, 1, NULL),
(196, 583, 311, 1, '2024-09-18 17:00:31', NULL, 1, NULL),
(197, 583, 312, 1, '2024-09-18 17:00:31', NULL, 1, NULL),
(198, 588, 584, 1, '2024-09-18 17:02:50', NULL, 1, NULL),
(199, 589, 583, 1, '2024-09-18 17:02:50', NULL, 1, NULL),
(200, 591, 583, 1, '2024-09-18 17:02:50', NULL, 1, NULL),
(201, 593, 589, 1, '2024-09-18 17:03:12', NULL, 1, NULL),
(202, 594, 588, 1, '2024-09-18 17:03:12', NULL, 1, NULL),
(203, 595, 589, 1, '2024-09-18 17:03:12', NULL, 1, NULL),
(204, 595, 592, 1, '2024-09-18 17:03:12', NULL, 1, NULL),
(205, 596, 591, 1, '2024-09-18 17:03:12', NULL, 1, NULL),
(206, 597, 589, 1, '2024-09-18 17:03:12', NULL, 1, NULL),
(207, 583, 311, 1, '2024-09-18 17:44:05', NULL, 1, NULL),
(208, 583, 312, 1, '2024-09-18 17:44:05', NULL, 1, NULL),
(209, 583, 311, 1, '2024-09-18 18:36:36', NULL, 1, NULL),
(210, 583, 312, 1, '2024-09-18 18:36:36', NULL, 1, NULL),
(211, 584, 598, 1, '2024-09-18 18:36:36', NULL, 1, NULL),
(212, 587, 598, 1, '2024-09-18 18:36:36', NULL, 1, NULL),
(213, 331, 325, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(214, 332, 326, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(215, 333, 328, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(216, 334, 328, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(217, 376, 331, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(218, 377, 330, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(219, 379, 333, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(220, 381, 332, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(221, 381, 334, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(222, 383, 376, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(223, 384, 381, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(224, 385, 380, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(225, 386, 375, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(226, 386, 379, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(227, 387, 377, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(228, 388, 381, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(229, 362, 387, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(230, 363, 384, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(231, 364, 386, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(232, 365, 388, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(233, 366, 387, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(234, 367, 376, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(235, 396, 384, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(236, 397, 364, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(237, 398, 363, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(238, 399, 362, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(239, 399, 366, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(240, 400, 364, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(241, 400, 365, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(242, 401, 367, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(243, 402, 401, 1, '2024-09-18 19:30:00', NULL, 1, NULL),
(244, 403, 399, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(245, 404, 383, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(246, 405, 397, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(247, 405, 400, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(248, 406, 396, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(249, 406, 398, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(250, 407, 400, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(251, 427, 405, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(252, 428, 407, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(253, 429, 399, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(254, 430, 405, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(255, 431, 403, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(256, 432, 404, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(257, 433, 406, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(258, 434, 365, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(259, 441, 430, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(260, 442, 385, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(261, 442, 427, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(262, 443, 427, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(263, 444, 396, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(264, 445, 428, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(265, 447, 431, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(266, 448, 432, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(267, 449, 433, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(268, 466, 445, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(269, 467, 441, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(270, 468, 442, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(271, 469, 441, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(272, 470, 447, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(273, 471, 448, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(274, 472, 449, 1, '2024-09-18 19:30:01', NULL, 1, NULL),
(275, 506, 504, 1, '2024-09-18 19:35:16', NULL, 1, NULL),
(276, 507, 501, 1, '2024-09-18 19:35:16', NULL, 1, NULL),
(277, 508, 504, 1, '2024-09-18 19:35:16', NULL, 1, NULL),
(278, 510, 500, 1, '2024-09-18 19:35:16', NULL, 1, NULL),
(279, 511, 504, 1, '2024-09-18 19:35:16', NULL, 1, NULL),
(280, 513, 504, 1, '2024-09-18 19:35:16', NULL, 1, NULL),
(281, 514, 506, 1, '2024-09-18 19:35:16', NULL, 1, NULL),
(282, 515, 507, 1, '2024-09-18 19:35:16', NULL, 1, NULL),
(283, 516, 510, 1, '2024-09-18 19:35:16', NULL, 1, NULL),
(284, 517, 508, 1, '2024-09-18 19:35:16', NULL, 1, NULL),
(285, 518, 508, 1, '2024-09-18 19:35:16', NULL, 1, NULL),
(286, 47, 609, 1, '2024-09-19 17:14:28', NULL, 1, NULL),
(287, 46, 601, 1, '2024-09-19 17:14:36', NULL, 1, NULL),
(288, 43, 610, 1, '2024-09-19 17:14:42', NULL, 1, NULL),
(289, 43, 612, 1, '2024-09-19 17:14:49', NULL, 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `curriculums`
--

CREATE TABLE `curriculums` (
  `id` int NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `tag` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT NULL,
  `created_id` int NOT NULL,
  `modified_id` int DEFAULT NULL,
  `culmination` date DEFAULT NULL,
  `careers_id` int UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `curriculums`
--

INSERT INTO `curriculums` (`id`, `status`, `tag`, `created`, `modified`, `created_id`, `modified_id`, `culmination`, `careers_id`) VALUES
(1, 1, 'Malla Curricular 2012', '2024-09-17 03:43:42', NULL, 1, NULL, NULL, 2),
(2, 1, 'Malla Curricular 2016', '2024-09-17 03:43:42', NULL, 1, NULL, NULL, 2),
(3, 1, 'Malla Curricular 2021', '2024-09-17 03:43:42', NULL, 1, NULL, NULL, 2),
(4, 1, 'Malla Curricular 2024', '2024-09-17 03:43:42', NULL, 1, NULL, NULL, 2),
(5, 1, 'Malla Curricular 1995', '2024-09-17 03:43:42', NULL, 1, NULL, NULL, 1),
(6, 1, 'Malla Curricular 1997', '2024-09-17 03:43:42', NULL, 1, NULL, NULL, 1),
(7, 1, 'Malla Curricular 2002', '2024-09-17 03:43:42', NULL, 1, NULL, NULL, 1),
(8, 1, 'Malla Curricular 2013', '2024-09-17 03:43:42', NULL, 1, NULL, NULL, 1),
(9, 1, 'Malla Curricular 2017', '2024-09-17 03:43:42', NULL, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departments`
--

CREATE TABLE `departments` (
  `id` int UNSIGNED NOT NULL,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT NULL,
  `created_id` int NOT NULL,
  `modified_id` int DEFAULT NULL,
  `faculty_id` int UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `departments`
--

INSERT INTO `departments` (`id`, `name`, `status`, `created`, `modified`, `created_id`, `modified_id`, `faculty_id`) VALUES
(1, 'Departamento de Ingeniería y Matemáticas', 1, '2024-09-12 00:00:00', NULL, 1, 1, 1),
(2, 'Departamento de Ingeniería de Sistemas e Informática', 1, '2024-09-12 00:00:00', NULL, 1, NULL, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `faculties`
--

CREATE TABLE `faculties` (
  `id` int UNSIGNED NOT NULL,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT NULL,
  `created_id` int NOT NULL,
  `modified_id` int DEFAULT NULL,
  `university_id` int UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `faculties`
--

INSERT INTO `faculties` (`id`, `name`, `description`, `status`, `created`, `modified`, `created_id`, `modified_id`, `university_id`) VALUES
(1, 'Facultad de Ingeniería', NULL, 1, '2024-09-12 00:00:00', NULL, 1, NULL, 2),
(2, 'Facultad de Ingeniería de Producción y Servicios', NULL, 1, '2024-09-12 00:00:00', NULL, 1, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `groups`
--

CREATE TABLE `groups` (
  `id` int NOT NULL,
  `name` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `code` int NOT NULL,
  `status` int NOT NULL DEFAULT '1',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT NULL,
  `created_id` int NOT NULL,
  `modified_id` int DEFAULT NULL,
  `course_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `professions`
--

CREATE TABLE `professions` (
  `id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created` timestamp NOT NULL,
  `modified` timestamp NULL DEFAULT NULL,
  `created_id` int NOT NULL,
  `modified_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `professions`
--

INSERT INTO `professions` (`id`, `name`, `description`, `status`, `created`, `modified`, `created_id`, `modified_id`) VALUES
(1, 'DISEÑO WEB', NULL, 1, '2024-10-16 15:41:02', NULL, 1, NULL),
(2, 'ARQUITECTURA SOFTWARE', NULL, 1, '2024-10-16 15:42:08', NULL, 1, NULL),
(3, 'ESTRUCTURA DE DATOS', NULL, 1, '2024-10-16 15:42:08', NULL, 1, NULL),
(4, 'CIENCIAS DE LA COMPUTACION', NULL, 1, '2024-10-16 15:44:53', NULL, 1, NULL),
(5, 'SEGURIDAD INFORMATICA', NULL, 1, '2024-10-16 15:44:53', NULL, 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `professors`
--

CREATE TABLE `professors` (
  `id` int NOT NULL,
  `first_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `father_surname` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `mother_surname` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `gender` enum('M','F') COLLATE utf8mb4_general_ci NOT NULL,
  `profession_id` int DEFAULT NULL,
  `birthdate` date NOT NULL,
  `nationality` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` tinyint(1) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_id` int NOT NULL,
  `modified_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `professors`
--

INSERT INTO `professors` (`id`, `first_name`, `father_surname`, `mother_surname`, `gender`, `profession_id`, `birthdate`, `nationality`, `phone`, `status`, `created`, `modified`, `created_id`, `modified_id`) VALUES
(1, 'VICENTE', 'MACHACA', 'ARCEDA', 'M', 1, '1989-12-10', 'PERUANO', '984984984', 1, '2024-09-26 18:31:23', '2024-09-26 18:31:23', 1, NULL),
(2, 'MARIBEL', 'QUIROZ', 'PILCO', 'F', 2, '1987-12-11', 'PERUANO', '165489491', 1, '2024-09-26 18:31:23', '2024-09-26 18:31:23', 1, NULL),
(3, 'HENRY', 'TORRES', 'CALCIN', 'M', 3, '1978-12-12', 'PERUANO', '546546545', 1, '2024-09-26 18:31:23', '2024-09-26 18:31:23', 1, NULL),
(4, 'MILAGROS', 'ZEGARRA', 'MEJIA', 'F', 4, '1988-12-13', 'PERUANO', '456789123', 1, '2024-09-26 18:31:23', '2024-09-26 18:31:23', 1, NULL),
(5, 'PERCY', 'HUERTAS', 'NIQUEN', 'M', 5, '1979-12-14', 'PERUANO', '126789465', 1, '2024-09-26 18:31:23', '2024-09-26 18:31:23', 1, NULL),
(6, 'JOSE', 'ZAVALA', 'FERNANDEZ', 'M', 1, '1980-12-15', 'PERUANO', '159263487', 1, '2024-09-26 18:31:23', '2024-09-26 18:31:23', 1, NULL),
(7, 'EDSON', 'LUQUE', 'MAMANI', 'M', 2, '1988-12-16', 'PERUANO', '423789156', 1, '2024-09-26 18:31:23', '2024-09-26 18:31:23', 1, NULL),
(8, 'LEYDI', 'MANRIQUE', 'TEJADA', 'F', 3, '1985-12-17', 'PERUANO', '159784627', 1, '2024-09-26 18:31:23', '2024-09-26 18:31:23', 1, NULL),
(9, 'LIZ', 'BERNEDO', 'FLORES', 'F', 4, '1990-12-18', 'PERUANO', '112366848', 1, '2024-09-26 18:31:23', '2024-09-26 18:31:23', 1, NULL),
(10, 'ANA', 'CUADROS', 'VALDIVIA', 'F', 5, '1987-12-19', 'PERUANO', '978916447', 1, '2024-09-26 18:31:23', '2024-09-26 18:31:23', 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `semesters`
--

CREATE TABLE `semesters` (
  `id` int NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `details` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT NULL,
  `created_id` int NOT NULL,
  `modified_id` int DEFAULT NULL,
  `curriculum_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `semesters`
--

INSERT INTO `semesters` (`id`, `name`, `details`, `status`, `created`, `modified`, `created_id`, `modified_id`, `curriculum_id`) VALUES
(1, 'I', 'ULS2021', 1, '2024-09-17 03:46:24', NULL, 1, NULL, 3),
(2, 'II', 'ULS2021', 1, '2024-09-17 03:48:42', NULL, 1, NULL, 3),
(3, 'III', 'ULS2021', 1, '2024-09-17 03:48:42', NULL, 1, NULL, 3),
(4, 'IV', 'ULS2021', 1, '2024-09-17 03:56:36', NULL, 1, NULL, 3),
(5, 'V', 'ULS2021', 1, '2024-09-17 03:56:36', NULL, 1, NULL, 3),
(6, 'VI', 'ULS2021', 1, '2024-09-17 03:56:36', NULL, 1, NULL, 3),
(7, 'VII', 'ULS2021', 1, '2024-09-17 03:56:36', NULL, 1, NULL, 3),
(8, 'VIII', 'ULS2021', 1, '2024-09-17 03:56:36', NULL, 1, NULL, 3),
(9, 'IX', 'ULS2021', 1, '2024-09-17 03:56:36', NULL, 1, NULL, 3),
(10, 'X', 'ULS2021', 1, '2024-09-17 03:56:36', NULL, 1, NULL, 3),
(11, 'I', 'UNSA2002', 1, '2024-09-17 03:57:28', NULL, 1, NULL, 7),
(12, 'II', 'UNSA2002', 1, '2024-09-17 03:57:28', NULL, 1, NULL, 7),
(13, 'III', 'UNSA2002', 1, '2024-09-17 03:57:28', NULL, 1, NULL, 7),
(14, 'IV', 'UNSA2002', 1, '2024-09-17 03:57:28', NULL, 1, NULL, 7),
(15, 'V', 'UNSA2002', 1, '2024-09-17 03:57:28', NULL, 1, NULL, 7),
(16, 'VI', 'UNSA2002', 1, '2024-09-17 03:57:28', NULL, 1, NULL, 7),
(17, 'VII', 'UNSA2002', 1, '2024-09-17 03:57:28', NULL, 1, NULL, 7),
(18, 'VIII', 'UNSA2002', 1, '2024-09-17 03:57:28', NULL, 1, NULL, 7),
(19, 'IX', 'UNSA2002', 1, '2024-09-17 03:57:28', NULL, 1, NULL, 7),
(20, 'X', 'UNSA2002', 1, '2024-09-17 03:57:28', NULL, 1, NULL, 7),
(26, 'VII', 'ULS2016', 1, '2024-09-17 04:00:58', NULL, 1, NULL, 2),
(27, 'VIII', 'ULS2016', 1, '2024-09-17 04:00:58', NULL, 1, NULL, 2),
(28, 'IX', 'ULS2016', 1, '2024-09-17 04:00:58', NULL, 1, NULL, 2),
(29, 'I', 'UNSA1995', 1, '2024-09-17 04:01:15', NULL, 1, NULL, 5),
(30, 'II', 'UNSA1995', 1, '2024-09-17 04:01:15', NULL, 1, NULL, 5),
(31, 'III', 'UNSA1995', 1, '2024-09-17 04:01:15', NULL, 1, NULL, 5),
(32, 'IV', 'UNSA1995', 1, '2024-09-17 04:01:15', NULL, 1, NULL, 5),
(33, 'V', 'UNSA1995', 1, '2024-09-17 04:01:15', NULL, 1, NULL, 5),
(34, 'VI', 'UNSA1995', 1, '2024-09-17 04:01:15', NULL, 1, NULL, 5),
(35, 'VII', 'UNSA1995', 1, '2024-09-17 04:01:15', NULL, 1, NULL, 5),
(36, 'VIII', 'UNSA1995', 1, '2024-09-17 04:01:15', NULL, 1, NULL, 5),
(37, 'IX', 'UNSA1995', 1, '2024-09-17 04:01:15', NULL, 1, NULL, 5),
(38, 'X', 'UNSA1995', 1, '2024-09-17 04:01:15', NULL, 1, NULL, 5),
(39, 'I', 'UNSA2013', 1, '2024-09-17 04:01:26', NULL, 1, NULL, 8),
(40, 'II', 'UNSA2013', 1, '2024-09-17 04:01:26', NULL, 1, NULL, 8),
(41, 'III', 'UNSA2013', 1, '2024-09-17 04:01:26', NULL, 1, NULL, 8),
(42, 'IV', 'UNSA2013', 1, '2024-09-17 04:01:26', NULL, 1, NULL, 8),
(43, 'V', 'UNSA2013', 1, '2024-09-17 04:01:26', NULL, 1, NULL, 8),
(44, 'VI', 'UNSA2013', 1, '2024-09-17 04:01:26', NULL, 1, NULL, 8),
(45, 'VII', 'UNSA2013', 1, '2024-09-17 04:01:26', NULL, 1, NULL, 8),
(46, 'VIII', 'UNSA2013', 1, '2024-09-17 04:01:26', NULL, 1, NULL, 8),
(47, 'IX', 'UNSA2013', 1, '2024-09-17 04:01:26', NULL, 1, NULL, 8),
(48, 'X', 'UNSA2013', 1, '2024-09-17 04:01:26', NULL, 1, NULL, 8),
(49, 'I', 'UNSA1997', 1, '2024-09-17 04:02:55', NULL, 1, NULL, 6),
(50, 'II', 'UNSA1997', 1, '2024-09-17 04:02:55', NULL, 1, NULL, 6),
(51, 'III', 'UNSA1997', 1, '2024-09-17 04:02:55', NULL, 1, NULL, 6),
(52, 'IV', 'UNSA1997', 1, '2024-09-17 04:02:55', NULL, 1, NULL, 6),
(53, 'V', 'UNSA1997', 1, '2024-09-17 04:02:55', NULL, 1, NULL, 6),
(54, 'VI', 'UNSA1997', 1, '2024-09-17 04:02:55', NULL, 1, NULL, 6),
(55, 'VII', 'UNSA1997', 1, '2024-09-17 04:02:55', NULL, 1, NULL, 6),
(56, 'VIII', 'UNSA1997', 1, '2024-09-17 04:02:55', NULL, 1, NULL, 6),
(57, 'IX', 'UNSA1997', 1, '2024-09-17 04:02:55', NULL, 1, NULL, 6),
(58, 'X', 'UNSA1997', 1, '2024-09-17 04:02:55', NULL, 1, NULL, 6),
(59, 'I', 'ULS2024', 1, '2024-09-17 04:05:17', NULL, 1, NULL, 4),
(60, 'II', 'ULS2024', 1, '2024-09-17 04:05:17', NULL, 1, NULL, 4),
(61, 'III', 'ULS2024', 1, '2024-09-17 04:05:17', NULL, 1, NULL, 4),
(62, 'IV', 'ULS2024', 1, '2024-09-17 04:05:17', NULL, 1, NULL, 4),
(63, 'V', 'ULS2024', 1, '2024-09-17 04:05:17', NULL, 1, NULL, 4),
(64, 'VI', 'ULS2024', 1, '2024-09-17 04:05:17', NULL, 1, NULL, 4),
(65, 'VII', 'ULS2024', 1, '2024-09-17 04:05:17', NULL, 1, NULL, 4),
(66, 'VIII', 'ULS2024', 1, '2024-09-17 04:05:17', NULL, 1, NULL, 4),
(67, 'IX', 'ULS2024', 1, '2024-09-17 04:05:17', NULL, 1, NULL, 4),
(68, 'X', 'ULS2024', 1, '2024-09-17 04:05:17', NULL, 1, NULL, 4),
(69, 'X', 'ULS2016', 1, '2024-09-17 04:06:20', NULL, 1, NULL, 2),
(70, 'I', 'ULS2012', 1, '2024-09-17 04:20:04', NULL, 1, NULL, 1),
(71, 'II', 'ULS2012', 1, '2024-09-17 04:20:04', NULL, 1, NULL, 1),
(72, 'III', 'ULS2012', 1, '2024-09-17 04:20:04', NULL, 1, NULL, 1),
(73, 'IV', 'ULS2012', 1, '2024-09-17 04:20:04', NULL, 1, NULL, 1),
(74, 'V', 'ULS2012', 1, '2024-09-17 04:20:04', NULL, 1, NULL, 1),
(75, 'VI', 'ULS2012', 1, '2024-09-17 04:20:04', NULL, 1, NULL, 1),
(76, 'VII', 'ULS2012', 1, '2024-09-17 04:20:04', NULL, 1, NULL, 1),
(77, 'VIII', 'ULS2012', 1, '2024-09-17 04:20:04', NULL, 1, NULL, 1),
(78, 'IX', 'ULS2012', 1, '2024-09-17 04:20:04', NULL, 1, NULL, 1),
(79, 'X', 'ULS2012', 1, '2024-09-17 04:20:04', NULL, 1, NULL, 1),
(80, 'I', 'ULS2016', 1, '2024-09-17 04:21:38', NULL, 1, NULL, 2),
(81, 'II', 'ULS2016', 1, '2024-09-17 04:21:38', NULL, 1, NULL, 2),
(82, 'III', 'ULS2016', 1, '2024-09-17 04:21:38', NULL, 1, NULL, 2),
(83, 'IV', 'ULS2016', 1, '2024-09-17 04:21:38', NULL, 1, NULL, 2),
(84, 'V', 'ULS2016', 1, '2024-09-17 04:21:38', NULL, 1, NULL, 2),
(85, 'VI', 'ULS2016', 1, '2024-09-17 04:21:38', NULL, 1, NULL, 2),
(92, 'I', 'UNSA2017', 1, '2024-09-17 13:18:33', NULL, 1, NULL, 9),
(93, 'II', 'UNSA2017', 1, '2024-09-17 13:18:33', NULL, 1, NULL, 9),
(94, 'III', 'UNSA2017', 1, '2024-09-17 13:18:33', NULL, 1, NULL, 9),
(95, 'IV', 'UNSA2017', 1, '2024-09-17 13:18:34', NULL, 1, NULL, 9),
(96, 'V', 'UNSA2017', 1, '2024-09-17 13:18:34', NULL, 1, NULL, 9),
(97, 'VI', 'UNSA2017', 1, '2024-09-17 13:18:34', NULL, 1, NULL, 9),
(98, 'VII', 'UNSA2017', 1, '2024-09-17 13:18:34', NULL, 1, NULL, 9),
(99, 'VIII', 'UNSA2017', 1, '2024-09-17 13:18:34', NULL, 1, NULL, 9),
(100, 'IX', 'UNSA2017', 1, '2024-09-17 13:18:34', NULL, 1, NULL, 9),
(101, 'X', 'UNSA2017', 1, '2024-09-17 13:18:34', NULL, 1, NULL, 9);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `students`
--

CREATE TABLE `students` (
  `id` int NOT NULL,
  `first_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `father_surname` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `mother_surname` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `gender` enum('M','F') COLLATE utf8mb4_general_ci NOT NULL,
  `birthdate` date NOT NULL,
  `nationality` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` tinyint(1) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_id` int NOT NULL,
  `modified_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `students`
--

INSERT INTO `students` (`id`, `first_name`, `father_surname`, `mother_surname`, `gender`, `birthdate`, `nationality`, `phone`, `email`, `status`, `created`, `modified`, `create_id`, `modified_id`) VALUES
(1, 'Esthephany', 'Choquehuanca', 'Layme', 'F', '1998-08-24', 'Peruana', '929907836', 'echoquehuancal@ulasalle.edu.pe', 1, '2024-09-18 14:55:39', '2024-09-18 14:55:39', 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `universities`
--

CREATE TABLE `universities` (
  `id` int UNSIGNED NOT NULL,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `address` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `url` text COLLATE utf8mb4_general_ci,
  `acronym` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT NULL,
  `created_id` int NOT NULL,
  `modified_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `universities`
--

INSERT INTO `universities` (`id`, `name`, `address`, `description`, `url`, `acronym`, `status`, `created`, `modified`, `created_id`, `modified_id`) VALUES
(1, 'Universidad Nacional San Agustín de Arequipa', NULL, NULL, 'www.unsa.edu.pe', 'UNSA', 1, '2024-09-12 00:00:00', NULL, 1, NULL),
(2, 'Universidad La Salle de Arequipa', NULL, NULL, 'www.ulasalle.edu.pe', 'ULASALLE', 1, '2024-09-12 00:00:00', NULL, 1, NULL),
(3, 'Universidad Nacional Mayor de San Marcos', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(4, 'Universidad Nacional de San Cristóbal de Huamanga', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(5, 'Universidad Nacional de San Antonio Abad del Cusco', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(6, 'Universidad Nacional de Trujillo', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(7, 'Universidad Nacional de San Agustín de Arequipa', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(8, 'Universidad Nacional de Ingeniería', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(9, 'Universidad Nacional Agraria La Molina', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(10, 'Universidad Nacional San Luis Gonzaga', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(11, 'Universidad Nacional del Centro del Perú', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(12, 'Universidad Nacional de la Amazonía Peruana', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(13, 'Universidad Nacional del Altiplano', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(14, 'Universidad Nacional de Piura', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(15, 'Universidad Nacional de Cajamarca', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(16, 'Universidad Nacional Federico Villarreal', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(17, 'Universidad Nacional Agraria de la Selva', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(18, 'Universidad Nacional Hermilio Valdizán de Huánuco', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(19, 'Universidad Nacional de Educación Enrique Guzmán y Valle', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(20, 'Universidad Nacional Daniel Alcides Carrión', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(21, 'Universidad Nacional del Callao', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(22, 'Universidad Nacional José Faustino Sánchez Carrión', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(23, 'Universidad Nacional Pedro Ruiz Gallo', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(24, 'Universidad Nacional Jorge Basadre Grohmann', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(25, 'Universidad Nacional Santiago Antúnez de Mayolo', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(26, 'Universidad Nacional de San Martín', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(27, 'Universidad Nacional de Ucayali', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(28, 'Universidad Nacional de Tumbes', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(29, 'Universidad Nacional del Santa', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(30, 'Universidad Nacional de Huancavelica', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(31, 'Universidad Nacional Amazónica de Madre de Dios', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(32, 'Universidad Nacional Toribio Rodríguez de Mendoza de Amazonas', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(33, 'Universidad Nacional Micaela Bastidas de Apurímac', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(34, 'Universidad Nacional Intercultural de la Amazonía', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(35, 'Universidad Nacional Tecnológica de Lima Sur (*1)', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(36, 'Universidad Nacional José María Arguedas', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(37, 'Universidad Nacional de Moquegua', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(38, 'Universidad Nacional de Juliaca', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(39, 'Universidad Nacional de Jaén', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(40, 'Universidad Nacional de Frontera', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(41, 'Universidad Nacional Autónoma de Chota', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(42, 'Universidad Nacional de Barranca', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(43, 'Universidad Nacional de Cañete', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(44, 'Universidad Nacional Intercultural Fabiola Salazar Leguía de Bagua', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(45, 'Universidad Nacional Intercultural de la Selva Central Juan Santos Atahualpa', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(46, 'Universidad Nacional Intercultural de Quillabamba', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(47, 'Universidad Nacional Autónoma de Alto Amazonas', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(48, 'Universidad Nacional Autónoma Altoandina de Tarma', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(49, 'Universidad Nacional Autónoma de Huanta', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(50, 'Universidad Nacional Tecnológica de Lima Sur', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(51, 'Universidad Nacional Autónoma de Tayacaja Daniel Hernández Morillo', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(52, 'Universidad Nacional Ciro Alegría', NULL, NULL, NULL, NULL, 1, '2024-09-18 23:09:00', NULL, 1, NULL),
(53, 'universidad catolica de santa maria de arequipa', NULL, NULL, ' www.ucsm.edu.pe', 'ucsm', 1, '2024-09-19 23:29:04', NULL, 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `first_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `father_surname` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `mother_surname` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT NULL,
  `created_id` int NOT NULL,
  `modified_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `first_name`, `father_surname`, `mother_surname`, `email`, `password`, `status`, `created`, `modified`, `created_id`, `modified_id`) VALUES
(1, 'richart', 'escobedo', 'quispe', 'r.escobedo@ulasalle.edu.pe', '$2y$10$yWb4Ro6sTNoiDq36UM0.6eGo82cOJ7kXt9rJ8Fuy1NbwPquoTJzcu', 1, '2024-10-09 22:08:07', NULL, 1, NULL),
(3, 'Carlos Mijail', 'Mamani', 'Anccasi', 'cmamania@ulasalle.edu.pe', '$2y$10$F0xO1qvRawKniYCaE6lSPus8QBKC9ztYlrm//J.fh..48g.QmfTN2', 1, '2024-10-16 18:47:11', NULL, 1, NULL),
(4, 'Josshua', 'Flores', 'Chumbimuni', 'jfloresch@ulasalle.edu.pe', 'flores', 1, '2024-10-16 19:49:53', NULL, 1, NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `academic_degrees`
--
ALTER TABLE `academic_degrees`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `academic_semesters`
--
ALTER TABLE `academic_semesters`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `areas`
--
ALTER TABLE `areas`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `careers`
--
ALTER TABLE `careers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `department_id` (`department_id`);

--
-- Indices de la tabla `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `courses_ibfk_2` (`semester_id`),
  ADD KEY `fk_courses_areas` (`area_id`);

--
-- Indices de la tabla `course_loads`
--
ALTER TABLE `course_loads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_professor_course_load` (`professor_id`),
  ADD KEY `fk_course_course_load` (`course_id`);

--
-- Indices de la tabla `course_prerequisites`
--
ALTER TABLE `course_prerequisites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `course_id` (`course_id`),
  ADD KEY `prerequisite_id` (`prerequisite_id`);

--
-- Indices de la tabla `curriculums`
--
ALTER TABLE `curriculums`
  ADD PRIMARY KEY (`id`),
  ADD KEY `careers_id` (`careers_id`);

--
-- Indices de la tabla `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `faculty_id` (`faculty_id`);

--
-- Indices de la tabla `faculties`
--
ALTER TABLE `faculties`
  ADD PRIMARY KEY (`id`),
  ADD KEY `university_id` (`university_id`);

--
-- Indices de la tabla `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_course_groups` (`course_id`);

--
-- Indices de la tabla `professions`
--
ALTER TABLE `professions`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `professors`
--
ALTER TABLE `professors`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `semesters`
--
ALTER TABLE `semesters`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_curriculums` (`curriculum_id`);

--
-- Indices de la tabla `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `universities`
--
ALTER TABLE `universities`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `academic_degrees`
--
ALTER TABLE `academic_degrees`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `academic_semesters`
--
ALTER TABLE `academic_semesters`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `areas`
--
ALTER TABLE `areas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT de la tabla `careers`
--
ALTER TABLE `careers`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `courses`
--
ALTER TABLE `courses`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=615;

--
-- AUTO_INCREMENT de la tabla `course_loads`
--
ALTER TABLE `course_loads`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `course_prerequisites`
--
ALTER TABLE `course_prerequisites`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=290;

--
-- AUTO_INCREMENT de la tabla `curriculums`
--
ALTER TABLE `curriculums`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `faculties`
--
ALTER TABLE `faculties`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `groups`
--
ALTER TABLE `groups`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `professions`
--
ALTER TABLE `professions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `professors`
--
ALTER TABLE `professors`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `semesters`
--
ALTER TABLE `semesters`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT de la tabla `students`
--
ALTER TABLE `students`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `universities`
--
ALTER TABLE `universities`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `careers`
--
ALTER TABLE `careers`
  ADD CONSTRAINT `department_id` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT;

--
-- Filtros para la tabla `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `courses_ibfk_2` FOREIGN KEY (`semester_id`) REFERENCES `semesters` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  ADD CONSTRAINT `fk_courses_areas` FOREIGN KEY (`area_id`) REFERENCES `areas` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT;

--
-- Filtros para la tabla `course_loads`
--
ALTER TABLE `course_loads`
  ADD CONSTRAINT `fk_course_course_load` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_professors` FOREIGN KEY (`professor_id`) REFERENCES `professors` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT;

--
-- Filtros para la tabla `course_prerequisites`
--
ALTER TABLE `course_prerequisites`
  ADD CONSTRAINT `course_prerequisites_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  ADD CONSTRAINT `course_prerequisites_ibfk_2` FOREIGN KEY (`prerequisite_id`) REFERENCES `courses` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT;

--
-- Filtros para la tabla `curriculums`
--
ALTER TABLE `curriculums`
  ADD CONSTRAINT `careers_id` FOREIGN KEY (`careers_id`) REFERENCES `careers` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT;

--
-- Filtros para la tabla `departments`
--
ALTER TABLE `departments`
  ADD CONSTRAINT `faculty_id` FOREIGN KEY (`faculty_id`) REFERENCES `faculties` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT;

--
-- Filtros para la tabla `faculties`
--
ALTER TABLE `faculties`
  ADD CONSTRAINT `university_id` FOREIGN KEY (`university_id`) REFERENCES `universities` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT;

--
-- Filtros para la tabla `groups`
--
ALTER TABLE `groups`
  ADD CONSTRAINT `fk_course_groups` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `semesters`
--
ALTER TABLE `semesters`
  ADD CONSTRAINT `semesters_ibfk_1` FOREIGN KEY (`curriculum_id`) REFERENCES `curriculums` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
