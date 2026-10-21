CREATE DATABASE IF NOT EXISTS digitalsaathi_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE digitalsaathi_db;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    mobile_number VARCHAR(20) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('senior', 'volunteer', 'admin') NOT NULL DEFAULT 'senior',
    preferred_language VARCHAR(10) NOT NULL DEFAULT 'en',
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS tutorial_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    slug VARCHAR(50) NOT NULL UNIQUE,
    name_en VARCHAR(100) NOT NULL,
    name_te VARCHAR(100) NOT NULL,
    description_en VARCHAR(255) DEFAULT NULL,
    description_te VARCHAR(255) DEFAULT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS tutorials (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    title_en VARCHAR(200) NOT NULL,
    title_te VARCHAR(255) NOT NULL,
    description_en TEXT NOT NULL,
    description_te TEXT NOT NULL,
    content_en MEDIUMTEXT NOT NULL,
    content_te MEDIUMTEXT NOT NULL,
    display_order INT NOT NULL DEFAULT 0,
    icon VARCHAR(50) DEFAULT 'phone',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS quiz_questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    topic VARCHAR(100) NOT NULL DEFAULT 'Scam Awareness',
    question_en TEXT NOT NULL,
    question_te TEXT NOT NULL,
    option_a_en VARCHAR(255) NOT NULL,
    option_a_te VARCHAR(255) NOT NULL,
    option_b_en VARCHAR(255) NOT NULL,
    option_b_te VARCHAR(255) NOT NULL,
    option_c_en VARCHAR(255) NOT NULL,
    option_c_te VARCHAR(255) NOT NULL,
    correct_option CHAR(1) NOT NULL DEFAULT 'B',
    explanation_en TEXT NOT NULL,
    explanation_te TEXT NOT NULL,
    display_order INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS quiz_results (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT DEFAULT NULL,
    score INT NOT NULL,
    total_questions INT NOT NULL,
    percentage DECIMAL(5,2) NOT NULL,
    topic VARCHAR(100) NOT NULL,
    completed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS help_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subject VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    preferred_contact_method ENUM('Phone Call', 'WhatsApp', 'SMS', 'In-Person') NOT NULL DEFAULT 'Phone Call',
    preferred_contact_time VARCHAR(100) DEFAULT NULL,
    status ENUM('Pending', 'Assigned', 'In Progress', 'Resolved', 'Closed') NOT NULL DEFAULT 'Pending',
    volunteer_id INT DEFAULT NULL,
    resolution_summary TEXT DEFAULT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (volunteer_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS request_assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    volunteer_id INT NOT NULL,
    assigned_by INT DEFAULT NULL,
    assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes TEXT DEFAULT NULL,
    FOREIGN KEY (request_id) REFERENCES help_requests(id) ON DELETE CASCADE,
    FOREIGN KEY (volunteer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS tutorial_progress (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    tutorial_id INT NOT NULL,
    completed TINYINT(1) NOT NULL DEFAULT 1,
    completed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_user_tutorial (user_id, tutorial_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (tutorial_id) REFERENCES tutorials(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO tutorial_categories (slug, name_en, name_te, description_en, description_te)
VALUES
('smartphone_basics', 'Smartphone Basics', 'స్మార్ట్‌ఫోన్ ప్రాథమికాంశాలు', 'Essential phone controls, calling, font resizing, and contacts', 'ప్రాథమిక ఫోన్ వాడకం, కాలింగ్, అక్షరాల పరిమాణం మరియు కాంటాక్ట్స్')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_te=VALUES(name_te);

INSERT INTO tutorial_categories (slug, name_en, name_te, description_en, description_te)
VALUES
('digital_payments', 'Digital Payments', 'చెల్లింపుల భద్రత', 'Safe UPI transactions, OTP rules, and scanning QR codes', 'సురక్షితమైన UPI వాడకం, OTP నియమాలు మరియు QR కోడ్ భద్రత')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_te=VALUES(name_te);

INSERT INTO tutorial_categories (slug, name_en, name_te, description_en, description_te)
VALUES
('scam_awareness', 'Scam Awareness', 'మోసాలపై అవగాహన', 'Identifying phishing calls, lottery messages, and remote access apps', 'నకిలీ కాల్స్, లాటరీ మోసాలు మరియు రిమోట్ యాప్స్ గుర్తించడం')
ON DUPLICATE KEY UPDATE name_en=VALUES(name_en), name_te=VALUES(name_te);

INSERT INTO tutorials (id, category, title_en, title_te, description_en, description_te, content_en, content_te, display_order, icon)
VALUES
(
    1,
    'smartphone_basics',
    'Turning On, Unlocking, and Basic Gestures',
    'ఫోన్ ఆన్ చేయడం, అన్‌లాక్ చేయడం మరియు ప్రాథమిక సంజ్ఞలు',
    'Learn how to power on your smartphone, unlock the screen, and use gentle finger touches.',
    'మీ స్మార్ట్‌ఫోన్‌ను ఎలా ఆన్ చేయాలో, స్క్రీన్ అన్‌లాక్ చేయాలో మరియు వేలితో సున్నితంగా ఎలా తాకాలో నేర్చుకోండి.',
    'Step 1: Press and hold the Power button on the side until the screen lights up.<br>Step 2: Swipe up from the bottom with one finger to reveal the keypad or fingerprint icon.<br>Step 3: Enter your 4-digit or 6-digit PIN carefully. Do not hurry.<br>Step 4: Tap once to open any application.<br>Step 5: Drag your finger up or down gently to scroll through pages.',
    'దశ 1: స్క్రీన్ వెలిగే వరకు ఫోన్ వైపు ఉన్న పవర్ బటన్‌ను నొక్కి పట్టుకోండి.<br>దశ 2: అన్‌లాక్ చేయడానికి స్క్రీన్ కింది భాగం నుండి పైకి వేలితో స్వైప్ చేయండి.<br>దశ 3: మీ 4 లేదా 6 అంకెల పిన్‌ను నమోదు చేయండి. తొందరపడవద్దు.<br>దశ 4: ఏదైనా యాప్‌ను తెరవడానికి దానిపై ఒక్కసారి తాకండి (ట్యాప్ చేయండి).<br>దశ 5: పేజీలను పైకి క్రిందికి జరపడానికి వేలితో సున్నితంగా స్వైప్ చేయండి.',
    1,
    'power'
),
(
    2,
    'smartphone_basics',
    'Saving New Contacts and Calling Family',
    'కొత్త ఫోన్ నంబర్లను సేవ్ చేయడం మరియు కాల్స్ చేయడం',
    'Step-by-step instructions on saving phone numbers and making regular voice or video calls.',
    'ఫోన్ నంబర్లను సులభంగా సేవ్ చేసుకోవడం మరియు మీ కుటుంబ సభ్యులకు వాయిస్ లేదా వీడియో కాల్స్ చేయడం ఎలాగో తెలుసుకోండి.',
    'Step 1: Open the Phone or Contacts app on your home screen.<br>Step 2: Tap the plus sign (+) or Add Contact button.<br>Step 3: Type the persons First Name and Mobile Number.<br>Step 4: Tap Save at the top right corner.<br>Step 5: To call, search their name, tap on it, and press the green telephone icon.',
    'దశ 1: మీ ఫోన్ హోమ్ స్క్రీన్‌లో కాంటాక్ట్స్ (Contacts) లేదా ఫోన్ యాప్‌ను తెరవండి.<br>దశ 2: ప్లస్ (+) లేదా క్రియేట్ కాంటాక్ట్ గుర్తుపై నొక్కండి.<br>దశ 3: వ్యక్తి పేరు మరియు మొబైల్ నంబర్‌ను టైప్ చేయండి.<br>దశ 4: కుడి వైపు పైభాగంలో ఉన్న సేవ్ (Save) బటన్‌ను నొక్కండి.<br>దశ 5: కాల్ చేయడానికి, వారి పేరును వెతికి ఆకుపచ్చ ఫోన్ గుర్తుపై నొక్కండి.',
    2,
    'user-plus'
),
(
    3,
    'smartphone_basics',
    'Connecting to Safe Home Wi-Fi',
    'సురక్షితమైన హోమ్ వై-ఫైకి కనెక్ట్ అవ్వడం',
    'How to connect your phone to your home wireless network without data charges.',
    'మీ ఫోన్‌ను ఇంట్లోని వై-ఫై నెట్‌వర్క్‌కు సురక్షితంగా ఎలా కనెక్ట్ చేయాలో తెలుసుకోండి.',
    'Step 1: Swipe down from the top of your screen to open the Quick Settings panel.<br>Step 2: Press and hold the Wi-Fi icon for two seconds.<br>Step 3: Turn the Wi-Fi switch ON.<br>Step 4: Select your home Wi-Fi name from the list.<br>Step 5: Enter the password provided by your internet provider and tap Connect.<br>Safety Tip: Never connect to unknown public Wi-Fi networks in railway stations or parks for banking.',
    'దశ 1: నోటిఫికేషన్ బార్ తెరవడానికి స్క్రీన్ పైనుండి కిందికి స్వైప్ చేయండి.<br>దశ 2: వై-ఫై (Wi-Fi) చిహ్నంపై రెండు సెకన్లు నొక్కి ఉంచండి.<br>దశ 3: వై-ఫై స్విచ్‌ను ఆన్ చేయండి.<br>దశ 4: జాబితా నుండి మీ ఇంటి వై-ఫై పేరును ఎంచుకోండి.<br>దశ 5: సరైన పాస్‌వర్డ్ నమోదు చేసి కనెక్ట్ నొక్కండి.<br>భద్రతా చిట్కా: రైల్వే స్టేషన్లు లేదా బహిరంగ ప్రదేశాల్లోని తెలియని ఉచిత వై-ఫై నెట్‌వర్క్‌లను బ్యాంకింగ్ కోసం ఎప్పుడూ ఉపయోగించవద్దు.',
    3,
    'wifi'
),
(
    4,
    'smartphone_basics',
    'Making Screen Text Larger and High Contrast',
    'స్క్రీన్ అక్షరాల పరిమాణం పెంచడం మరియు హై కాంట్రాస్ట్',
    'Enlarge fonts across all your apps so you can read messages comfortably without eye strain.',
    'మీ కళ్లపై భారం పడకుండా అన్ని యాప్‌లలోని అక్షరాలను పెద్దవిగా మరియు స్పష్టంగా కనిపించేలా చేయడం.',
    'Step 1: Open the Settings app (gear icon).<br>Step 2: Tap on Display or Accessibility.<br>Step 3: Tap Font Size and Display Size.<br>Step 4: Drag the slider to the right towards Large or Largest.<br>Step 5: Toggle High-Contrast Text to ON for sharp letters.',
    'దశ 1: మీ ఫోన్ సెట్టింగ్స్ (Settings) యాప్‌ను తెరవండి.<br>దశ 2: డిస్‌ప్లే (Display) లేదా యాక్సెసిబిలిటీ (Accessibility) పై నొక్కండి.<br>దశ 3: ఫాంట్ సైజు (Font Size) ఎంపికను తాకండి.<br>దశ 4: స్లైడర్‌ను కుడి వైపుకు జరిపి అక్షరాల పరిమాణాన్ని పెంచండి.<br>దశ 5: అక్షరాలు మరింత స్పష్టంగా కనిపించడానికి హై-కాంట్రాస్ట్ టెక్స్ట్ ఆన్ చేయండి.',
    4,
    'type'
),
(
    5,
    'digital_payments',
    'Understanding UPI and Paying Safely at Shops',
    'UPI అర్థం చేసుకోవడం మరియు దుకాణాల్లో సురక్షితంగా చెల్లించడం',
    'Learn how Google Pay, PhonePe, and Paytm work when buying groceries or medicine.',
    'కిరాణా దుకాణాలు మరియు మందుల షాపుల్లో గూగుల్ పే, ఫోన్‌పే సురక్షితంగా ఎలా వాడాలో నేర్చుకోండి.',
    'Step 1: Open your trusted UPI app (PhonePe or Google Pay).<br>Step 2: Tap Scan QR Code.<br>Step 3: Point your camera at the shopkeepers official printed QR standee.<br>Step 4: Verify the merchant name on screen and type the exact bill amount.<br>Step 5: Enter your confidential 4 or 6-digit UPI PIN.<br>Golden Rule: Never enter your PIN to receive payments. PIN is only for sending money.',
    'దశ 1: మీ ఫోన్‌పే లేదా గూగుల్ పే యాప్‌ను తెరవండి.<br>దశ 2: స్కాన్ QR కోడ్ (Scan QR) గుర్తుపై నొక్కండి.<br>దశ 3: దుకాణదారుడి QR కోడ్‌పై మీ ఫోన్ కెమెరాను చూపించండి.<br>దశ 4: స్క్రీన్‌పై కనిపించే దుకాణం పేరు సరిచూసి, బిల్లు మొత్తాన్ని టైప్ చేయండి.<br>దశ 5: మీ రహస్య 4 లేదా 6 అంకెల UPI పిన్‌ను నమోదు చేయండి.<br>ముఖ్య గమనిక: డబ్బులు స్వీకరించడానికి ఎప్పుడూ పిన్ నొక్కవద్దు. డబ్బు పంపడానికి మాత్రమే పిన్ అవసరం.',
    5,
    'credit-card'
),
(
    6,
    'digital_payments',
    'Never Share OTP with Anyone Calling You',
    'ఫోన్ కాల్స్‌లో OTPని ఎవరితోనూ పంచుకోవద్దు',
    'Why OTP is like your house key and how bank fraudsters trick elders into revealing it.',
    'OTP అంటే ఏమిటి మరియు బ్యాంక్ అధికారుల పేరుతో వచ్చే నకిలీ కాల్స్‌కు ఎందుకు చెప్పకూడదో తెలుసుకోండి.',
    'Rule 1: An OTP (One Time Password) is sent to confirm a payment or account change.<br>Rule 2: Real bank managers will NEVER ask you for an OTP over telephone calls.<br>Rule 3: If anyone claims your pension will stop unless you tell them an SMS code, hang up immediately.<br>Rule 4: Call your local bank branch directly if you have any doubts.',
    'నియమం 1: OTP అనేది మీ బ్యాంక్ ఖాతా లాకర్ తాళం లాంటిది.<br>నియమం 2: నిజమైన బ్యాంక్ సిబ్బంది ఫోన్ కాల్స్‌లో ఎప్పుడూ OTP అడగరు.<br>నియమం 3: పెన్షన్ ఆగిపోతుందని బెదిరించి OTP అడిగితే వెంటనే కాల్ కట్ చేయండి.<br>నియమం 4: ఏదైనా సందేహం ఉంటే నేరుగా మీ బ్యాంక్ బ్రాంచ్‌కు వెళ్లండి.',
    6,
    'shield-alert'
),
(
    7,
    'scam_awareness',
    'Spotting Fake Electricity Bill Threat SMS',
    'నకిలీ విద్యుత్ బిల్లు బెదిరింపు మెసేజ్‌లను గుర్తించడం',
    'Protect yourself against the widespread fake power disconnection SMS scam.',
    'ఈ రాత్రి కరెంట్ కట్ అవుతుందనే సైబర్ నేరగాళ్ల నకిలీ సందేశాలను ఎలా గుర్తించాలో తెలుసుకోండి.',
    'Warning Signs:<br>1. Message comes from a normal 10-digit mobile number, not official department headers like APCPDCL.<br>2. Threatens disconnection tonight at 9:30 PM.<br>3. Demands you call an unknown cell number.<br>What To Do: Ignore the message. Electricity offices never send threatening SMS from private numbers.',
    'హెచ్చరిక సంకేతాలు:<br>1. సందేశం ఒక సాధారణ 10 అంకెల మొబైల్ నంబర్ నుండి వస్తుంది.<br>2. ఈ రాత్రికే కరెంట్ కట్ అవుతుందని భయపెడతారు.<br>3. ఒక వ్యక్తిగత నంబర్‌కు కాల్ చేయమని ఒత్తిడి తెస్తారు.<br>మీరు ఏమి చేయాలి: ఆ సందేశాన్ని తొలగించండి. విద్యుత్ శాఖ ఎప్పుడూ వ్యక్తిగత నంబర్ల నుండి ఇలాంటి మెసేజ్‌లు పంపదు.',
    7,
    'alert-triangle'
),
(
    8,
    'scam_awareness',
    'Say NO to AnyDesk and Screen-Sharing Apps',
    'AnyDesk మరియు స్క్రీన్ షేరింగ్ యాప్‌లను తిరస్కరించండి',
    'Understand how fraudsters use AnyDesk to see your screen and siphon your savings.',
    'AnyDesk వంటి యాప్‌లను ఇన్‌స్టాల్ చేయమని అడిగే కాల్స్ పట్ల ఎలా అప్రమత్తంగా ఉండాలో తెలుసుకోండి.',
    'What Fraudsters Say: "Sir, install AnyDesk or QuickSupport so our technician can fix your phone bank app."<br>The Reality: These apps allow strangers to watch everything you type on your screen, including passwords and banking OTPs.<br>Golden Rule: Never install AnyDesk or TeamViewer based on phone caller instructions.',
    'మోసగాళ్లు చెప్పే మాటలు: "సార్, మీ ఫోన్ లేదా బ్యాంక్ సమస్యను సరిచేయడానికి AnyDesk యాప్ ఇన్‌స్టాల్ చేయండి."<br>వాస్తవం: ఈ యాప్ ఇన్‌స్టాల్ చేస్తే మీ ఫోన్ స్క్రీన్ వారికి కనిపిస్తుంది. మీ పాస్‌వర్డ్‌లు, OTPలు దొంగిలిస్తారు.<br>బంగారు నియమం: ఫోన్ కాల్స్‌లో ఎవరైనా చెబితే ఎట్టిపరిస్థితుల్లోనూ AnyDesk లేదా TeamViewer యాప్‌లను డౌన్‌లోడ్ చేయకండి.',
    8,
    'eye-off'
)
ON DUPLICATE KEY UPDATE
    category=VALUES(category),
    title_en=VALUES(title_en),
    title_te=VALUES(title_te),
    description_en=VALUES(description_en),
    description_te=VALUES(description_te),
    content_en=VALUES(content_en),
    content_te=VALUES(content_te),
    display_order=VALUES(display_order),
    icon=VALUES(icon);

INSERT INTO quiz_questions (id, topic, question_en, question_te, option_a_en, option_a_te, option_b_en, option_b_te, option_c_en, option_c_te, correct_option, explanation_en, explanation_te, display_order)
VALUES
(
    1,
    'Electricity Bill Scam',
    'You receive an SMS saying your electricity power will be disconnected at 9:30 PM tonight unless you call an unknown mobile number immediately. What should you do?',
    'ఈ రాత్రి 9:30 గంటలకు మీ విద్యుత్ కనెక్షన్ కట్ చేయబడుతుందని, వెంటనే ఒక మొబైల్ నంబర్‌కు కాల్ చేయాలని ఎస్సెమ్మెస్ వచ్చింది. మీరు ఏమి చేయాలి?',
    'Call the mobile number immediately and follow their instructions',
    'వెంటనే ఆ నంబర్‌కు కాల్ చేసి వారు చెప్పినట్లు చేయాలి',
    'Ignore the SMS and do not call - official departments never send personal cell phone numbers for disconnections',
    'ఆ మెసేజ్‌ను విస్మరించాలి - ప్రభుత్వ విద్యుత్ సంస్థలు వ్యక్తిగత సెల్ నంబర్ల నుండి ఇలాంటి బెదిరింపు మెసేజ్‌లు పంపవు',
    'Install whatever app they ask you to download to pay 10 rupees',
    '10 రూపాయల బిల్లు చెల్లించడానికి వారు పంపే లింక్ ద్వారా యాప్ డౌన్‌లోడ్ చేయాలి',
    'B',
    'Correct! Electricity departments never send threat SMS from 10-digit mobile numbers demanding you call a personal number. This is a common cyber fraud.',
    'సరైన సమాధానం! ప్రభుత్వ విద్యుత్ శాఖలు ఎప్పుడూ 10 అంకెల మొబైల్ నంబర్ల ద్వారా విద్యుత్ నిలిపివేత మెసేజ్‌లు పంపవు. ఇది సాధారణ సైబర్ మోసం.',
    1
),
(
    2,
    'UPI QR Code Scam',
    'A caller claims you have won 50,000 rupees in a lucky draw and asks you to scan a QR code and enter your UPI PIN to receive the money. What should you do?',
    'మీకు లక్కీ డ్రాలో రూ. 50,000 నగదు బహుమతి వచ్చిందని, డబ్బులు అందుకోవడానికి QR కోడ్ స్కాన్ చేసి UPI పిన్ నొక్కమని కాల్ వచ్చింది. మీరు ఏమి చేయాలి?',
    'Scan the QR code and enter UPI PIN right away',
    'వెంటనే QR కోడ్ స్కాన్ చేసి మీ UPI పిన్ ఎంటర్ చేయాలి',
    'Disconnect the call immediately - receiving money NEVER requires entering your UPI PIN',
    'వెంటనే ఫోన్ కట్ చేయాలి - డబ్బులు అందుకోవడానికి ఎప్పుడూ UPI పిన్ అవసరం లేదు',
    'Ask a family member to enter their UPI PIN instead',
    'మీ కుటుంబ సభ్యుల ఫోన్ నుండి పిన్ నొక్కాలి',
    'B',
    'Correct! The golden rule of UPI: Entering your UPI PIN always DEDUCTS money from your bank account. Receiving money never needs a PIN.',
    'సరైన సమాధానం! UPI గోల్డెన్ రూల్: మీ బ్యాంక్ ఖాతా నుండి డబ్బు కట్ కావడానికి మాత్రమే పిన్ అవసరం. ఎవరైనా డబ్బు పంపుతుంటే పిన్ ఎంటర్ చేయాల్సిన పని లేదు.',
    2
),
(
    3,
    'Remote Screen Sharing',
    'Someone calls claiming to be from your bank customer care and asks you to install AnyDesk or QuickSupport on your phone to solve your problem. What is the right response?',
    'బ్యాంక్ కస్టమర్ కేర్ నుండి మాట్లాడుతున్నామని చెప్పి, మీ సమస్య పరిష్కారం కోసం AnyDesk లేదా QuickSupport యాప్ డౌన్‌లోడ్ చేయమని ఒక వ్యక్తి అడిగితే మీరు ఏమి చేయాలి?',
    'Never install AnyDesk or screen-sharing apps for callers - they can see your phone screen and steal your passwords',
    'ఎట్టిపరిస్థితుల్లోనూ AnyDesk లేదా స్క్రీన్ షేరింగ్ యాప్‌లను డౌన్‌లోడ్ చేయకూడదు - అవి మీ ఫోన్ పాస్‌వర్డ్‌లను దొంగిలిస్తాయి',
    'Install it immediately since the caller sounds polite',
    'వారు మర్యాదగా మాట్లాడుతున్నారు కాబట్టి వెంటనే ఇన్‌స్టాల్ చేయాలి',
    'Install it and give them the 9-digit access code',
    'ఇన్‌స్టాల్ చేసి అందులో కనిపించే 9 అంకెల కోడ్‌ను వారికి చెప్పాలి',
    'A',
    'Correct! AnyDesk and QuickSupport allow scammers to remotely control your phone, read your passwords, and view incoming OTPs.',
    'సరైన సమాధానం! AnyDesk మరియు TeamViewer వంటి యాప్‌ల ద్వారా సైబర్ నేరగాళ్లు మీ ఫోన్ స్క్రీన్‌ను నేరుగా చూస్తూ మీ OTPలు మరియు బ్యాంక్ వివరాలను దొంగిలిస్తారు.',
    3
),
(
    4,
    'Phishing & KYC Fraud',
    'You receive a message saying: Your Bank account or PAN card is blocked. Click this link immediately to update KYC. What should you do?',
    'మీ పాన్ కార్డు లేదా బ్యాంక్ ఖాతా బ్లాక్ చేయబడింది. వెంటనే ఈ లింక్ క్లిక్ చేసి KYC అప్‌డేట్ చేయండి అని వచ్చిన మెసేజ్‌కు మీరు ఏమి చేయాలి?',
    'Click the link and type your debit card number and PIN',
    'లింక్ ఓపెన్ చేసి డెబిట్ కార్డు నంబర్ మరియు పిన్ ఎంటర్ చేయాలి',
    'Do not click the link - delete the message or visit your bank branch directly',
    'ఆ లింక్‌ను ఎప్పుడూ క్లిక్ చేయకూడదు - నేరుగా మీ బ్యాంక్ శాఖను సంప్రదించాలి',
    'Forward the message to your friends',
    'ఆ లింక్‌ను బంధువులకు ఫార్వర్డ్ చేయాలి',
    'B',
    'Correct! Banks never send unknown links asking for sensitive debit card or internet banking credentials.',
    'సరైన సమాధానం! బ్యాంకులు ఎప్పుడూ అనామక లింక్‌ల ద్వారా వ్యక్తిగత లేదా కార్డ్ వివరాలను అడగవు.',
    4
),
(
    5,
    'ATM Safety',
    'A friendly stranger at an ATM machine offers to help you withdraw money and asks for your 4-digit ATM PIN. What should you do?',
    'ATM వద్ద ఒక తెలియని వ్యక్తి మీకు డబ్బులు తీసిపెడతానని చెప్పి మీ 4 అంకెల ATM పిన్ అడిగితే మీరు ఏమి చేయాలి?',
    'Tell them the PIN so they can press the buttons for you',
    'వారు బటన్లు నొక్కడానికి పిన్ నంబర్ వారికి చెప్పాలి',
    'Politely refuse and never share your ATM PIN with any stranger - ask only bank security or a trusted family member',
    'మర్యాదగా నిరాకరించాలి - మీ ATM పిన్ ఎవరితోనూ పంచుకోకూడదు, కేవలం కుటుంబ సభ్యుల సహాయం మాత్రమే తీసుకోవాలి',
    'Write your PIN on the back of your card',
    'కార్డు వెనుక పిన్ నంబర్ రాసి ఉంచాలి',
    'B',
    'Correct! Never disclose your ATM PIN to strangers. Always guard the keypad with your hand when entering your PIN.',
    'సరైన సమాధానం! ATM పిన్ అనేది రహస్యమైనది. ఎట్టిపరిస్థితుల్లోనూ ఇతరులకు చెప్పకూడదు.',
    5
)
ON DUPLICATE KEY UPDATE
    topic=VALUES(topic),
    question_en=VALUES(question_en),
    question_te=VALUES(question_te),
    option_a_en=VALUES(option_a_en),
    option_a_te=VALUES(option_a_te),
    option_b_en=VALUES(option_b_en),
    option_b_te=VALUES(option_b_te),
    option_c_en=VALUES(option_c_en),
    option_c_te=VALUES(option_c_te),
    correct_option=VALUES(correct_option),
    explanation_en=VALUES(explanation_en),
    explanation_te=VALUES(explanation_te),
    display_order=VALUES(display_order);
