-- TRY_PARSE
-- 
-- Demonstrate parsing with protection

DECLARE
    @MONEY TABLE
(
    currency nvarchar(15) NOT NULL 
,   meta varchar(20) NOT NULL
)

INSERT INTO
    @MONEY
VALUES
    (N'$4,000.23', 'USA')
,   (N'€2.500', 'Germany')
,   (N'€3,750', 'Italian')
,   (N'€1 250', 'France')

DECLARE
    @CULTURES TABLE
(
    full_name sysname NOT NULL 
,   alias sysname NOT NULL 
,   LCID smallint NOT NULL 
,   specific_culture sysname NOT NULL 
)

INSERT INTO
    @CULTURES
VALUES
    ('us_english', 'English', 1033, 'en-US')
,   ('Deutsch', 'German', 1031, 'de-DE')
,   ('Français', 'French', 1036, 'fr-FR')
,   ('日本語', 'Japanese', 1041, 'ja-JP')
,   ('Dansk', 'Danish', 1030, 'da-DK')
,   ('Español', 'Spanish', 3082, 'es-ES')
,   ('Italiano', 'Italian', 1040, 'it-IT')
,   ('Nederlands', 'Dutch', 1043, 'nl-NL')
,   ('Norsk', 'Norwegian', 2068, 'nn-NO')
,   ('Português', 'Portuguese', 2070, 'pt-PT')
,   ('Suomi', 'Finnish', 1035, 'fi')
,   ('Svenska', 'Swedish', 1053, 'sv-SE')
,   ('čeština', 'Czech', 1029, 'Cs-CZ')
,   ('magyar', 'Hungarian', 1038, 'Hu-HU')
,   ('polski', 'Polish', 1045, 'Pl-PL')
,   ('română', 'Romanian', 1048, 'Ro-RO')
,   ('hrvatski', 'Croatian', 1050, 'hr-HR')
,   ('slovenčina', 'Slovak', 1051, 'Sk-SK')
,   ('slovenski', 'Slovenian', 1060, 'Sl-SI')
,   ('ελληνικά', 'Greek', 1032, 'El-GR')
,   ('български', 'Bulgarian', 1026, 'bg-BG')
,   ('русский', 'Russian', 1049, 'Ru-RU')
,   ('Türkçe', 'Turkish', 1055, 'Tr-TR')
,   ('British', 'British English', 2057, 'en-GB')
,   ('eesti', 'Estonian', 1061, 'Et-EE')
,   ('latviešu', 'Latvian', 1062, 'lv-LV')
,   ('lietuvių', 'Lithuanian', 1063, 'lt-LT')
,   ('Português (Brasil)', 'Brazilian', 1046, 'pt-BR')
,   ('繁體中文', 'Traditional Chinese', 1028, 'zh-TW')
,   ('한국어', 'Korean', 1042, 'Ko-KR')
,   ('简体中文', 'Simplified Chinese', 2052, 'zh-CN')
,   ('Arabic', 'Arabic', 1025, 'ar-SA')
,   ('ไทย', 'Thai', 1054, 'Th-TH')

SELECT
    D.*
FROM
    (
        SELECT
            M.currency 
        ,   TRY_PARSE(M.currency AS money using C.specific_culture) AS parsed
        ,   M.meta
        ,   C.*
        FROM
            @CULTURES C
            CROSS APPLY
                @MONEY M
    ) D
WHERE
    D.parsed IS NOT NULL
