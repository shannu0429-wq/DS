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
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
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

INSERT INTO tutorials (category, title_en, title_te, description_en, description_te, content_en, content_te, display_order, icon)
VALUES
(
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
    'smartphone_basics',
    'Installing Safe Apps from Google Play Store',
    'గూగుల్ ప్లే స్టోర్ నుండి సురక్షితమైన యాప్‌లను ఇన్‌స్టాల్ చేయడం',
    'Download official, safe applications and avoid downloading unauthorized files from WhatsApp or SMS.',
    'అధికారిక యాప్‌లను మాత్రమే డౌన్‌లోడ్ చేయడం మరియు వాట్సాప్ లేదా ఎస్సెమ్మెస్ లింక్‌ల ద్వారా ప్రమాదకరమైన ఫైళ్లను డౌన్‌లోడ్ చేయకుండా ఉండటం.',
    'Step 1: Open the Google Play Store app (it has a colorful triangle icon).<br>Step 2: Tap the search bar at the top and type the name of the app (e.g. WhatsApp or BHIM).<br>Step 3: Check that the publisher name is verified and the app has millions of downloads.<br>Step 4: Tap the green Install button.<br>Step 5: Wait until it finishes, then tap Open.<br>Golden Rule: Never tap on APK download links sent by strangers via SMS or WhatsApp.',
    'దశ 1: గూగుల్ ప్లే స్టోర్ (Google Play Store) యాప్‌ను తెరవండి.<br>దశ 2: పైభాగంలో ఉన్న సెర్చ్ బార్‌లో మీకు కావలసిన యాప్ పేరును టైప్ చేయండి.<br>దశ 3: యాప్ డెవలపర్ వివరాలు మరియు రేటింగ్‌లను పరిశీలించండి.<br>దశ 4: ఆకుపచ్చ రంగు ఇన్‌స్టాల్ (Install) బటన్‌ను నొక్కండి.<br>దశ 5: డౌన్‌లోడ్ పూర్తయిన తర్వాత ఓపెన్ నొక్కండి.<br>ముఖ్యమైన సూచన: వాట్సాప్ లేదా ఎస్సెమ్మెస్‌లో తెలియని వ్యక్తులు పంపే .apk ఫైళ్లను ఎట్టిపరిస్థితుల్లోనూ ఇన్‌స్టాల్ చేయవద్దు.',
    4,
    'download'
),
(
    'smartphone_basics',
    'Enlarging Font Size and Text for Easy Reading',
    'స్పష్టంగా చదవడానికి అక్షరాల పరిమాణాన్ని పెద్దదిగా చేయడం',
    'Make text, icons, and menus larger and clearer for relaxed reading without eye strain.',
    'కంటిపై ఒత్తిడి లేకుండా సులభంగా చదవడానికి ఫాంట్ సైజు మరియు డిస్‌ప్లే సైజును పెంచుకోవడం.',
    'Step 1: Open Settings on your phone (the gear icon).<br>Step 2: Scroll and tap on Display or Accessibility.<br>Step 3: Tap on Font size and style.<br>Step 4: Drag the slider circle to the right until the text appears large and comfortable.<br>Step 5: You can also enable High-contrast fonts or Bold text for even better clarity.',
    'దశ 1: మీ ఫోన్‌లో సెట్టింగ్స్ (Settings) తెరవండి.<br>దశ 2: డిస్‌ప్లే (Display) లేదా యాక్సెసిబిలిటీ (Accessibility) ఎంపికపై నొక్కండి.<br>దశ 3: ఫాంట్ సైజ్ (Font size) పై ట్యాప్ చేయండి.<br>దశ 4: అక్షరాలు మీకు సరిపడేంత పెద్దవిగా అయ్యే వరకు స్లైడర్‌ను కుడివైపుకి జరపండి.<br>దశ 5: స్పష్టత కోసం బోల్డ్ టెక్స్ట్ (Bold text) ఆప్షన్‌ను కూడా ఆన్ చేసుకోవచ్చు.',
    5,
    'eye'
),
(
    'digital_payments',
    'Golden Rules of UPI: Receiving Money Never Requires a PIN',
    'UPI గోల్డెన్ రూల్: డబ్బులు అందుకోవడానికి పిన్ అవసరం లేదు',
    'Crucial payment safety rules every senior citizen must know before using phone payment apps.',
    'ఆన్‌లైన్ చెల్లింపుల యాప్‌లు ఉపయోగించేటప్పుడు ప్రతి సీనియర్ సిటిజన్ తప్పక తెలుసుకోవలసిన కీలక భద్రతా నియమాలు.',
    'Rule 1: UPI PIN is ONLY needed when SENDING or DEDUCTING money from your bank account.<br>Rule 2: If someone claims they are sending you money, lottery prizes, or government pension and asks you to enter your UPI PIN, IT IS A SCAM.<br>Rule 3: Scanning a QR code is for paying someone, NEVER for receiving money.<br>Rule 4: Never click on Collect Request notifications from unknown callers.<br>Rule 5: Keep your daily transaction limit modest for peace of mind.',
    'నియమం 1: మీ బ్యాంక్ ఖాతా నుండి డబ్బు పంపేటప్పుడు మాత్రమే UPI PIN అవసరం.<br>నియమం 2: ఎవరైనా మీకు డబ్బు పంపుతున్నామని లేదా పెన్షన్ వేస్తున్నామని చెప్పి పిన్ నొక్కమంటే అది 100 శాతం మోసం.<br>నియమం 3: QR కోడ్ స్కాన్ చేయడం అనేది చెల్లింపు చేయడానికి మాత్రమే, డబ్బు అందుకోవడానికి కాదు.<br>నియమం 4: తెలియని నంబర్ల నుండి వచ్చే పేమెంట్ రిక్వెస్ట్‌లను తిరస్కరించండి.<br>నియమం 5: అనుమానం వస్తే వెంటనే బ్యాంక్‌కు లేదా 1930 నంబర్‌కు తెలియజేయండి.',
    6,
    'shield-check'
),
(
    'digital_payments',
    'Why OTP, Passwords, and UPI PINs Must Never Be Shared',
    'OTP, పాస్‌వర్డ్ మరియు UPI పిన్ ఎవరికీ ఎందుకు చెప్పకూడదు',
    'Understand why genuine bank staff never ask for OTP or PIN numbers over phone calls.',
    'బ్యాంక్ మేనేజర్లు లేదా అధికారులు ఎవరూ ఫోన్ చేసి మీ ఓటీపీ లేదా పిన్ అడగరని తెలుసుకోండి.',
    'Fact 1: OTP stands for One-Time Password. It acts as the digital key to your bank safe.<br>Fact 2: Bank employees, police, electricity department, or pension officers will NEVER ask for your OTP.<br>Fact 3: If a caller threatens that your SIM card, electricity connection, or bank account will be blocked unless you share an OTP, disconnect the call immediately.<br>Fact 4: Never read OTP messages aloud to anyone on a phone call.<br>Fact 5: If in doubt, visit your local bank branch directly with a trusted family member.',
    'నిజం 1: OTP అనేది మీ డిజిటల్ తాళం లాంటిది. దాన్ని ఎవరికీ తెలియజేయకూడదు.<br>నిజం 2: బ్యాంక్ మేనేజర్, పోలీస్ లేదా ప్రభుత్వ అధికారులు ఎవరూ ఫోన్ చేసి ఓటీపీ అడగరు.<br>నిజం 3: ఓటీపీ చెప్పకపోతే మీ కరెంట్ కట్ అవుతుంది లేదా బ్యాంక్ బ్లాక్ అవుతుంది అని బెదిరిస్తే వెంటనే ఫోన్ కట్ చేయండి.<br>నిజం 4: ఫోన్ మాట్లాడుతున్నప్పుడు ఎటువంటి నంబర్లను ఎవరికీ చదివి వినిపించవద్దు.<br>నిజం 5: ఏదైనా సందేహం ఉంటే మీ కుటుంబ సభ్యులతో కలిసి నేరుగా బ్యాంక్ బ్రాంచ్‌కి వెళ్లండి.',
    7,
    'lock'
),
(
    'scam_awareness',
    'Recognizing Fake Customer Care Numbers and Search Traps',
    'నకిలీ కస్టమర్ కేర్ నంబర్లు మరియు సెర్చ్ ఇంజిన్ మోసాలను గుర్తించడం',
    'Why you should never trust phone numbers found directly on Google search results.',
    'గూగుల్ లేదా ఇంటర్నెట్ సెర్చ్‌లో కనిపించే నంబర్లను గుడ్డిగా నమ్మి మోసపోకుండా ఉండటం.',
    'Scenario: You have an issue with gas booking, courier, or train ticket. You search on Google and call the first number listed.<br>Danger: Cybercriminals upload their own phone numbers as fake customer care desks.<br>What they do: They ask you to install apps like AnyDesk, TeamViewer, or send 10 rupees.<br>Safe Action: Always find customer care numbers only inside official mobile apps or on official physical bills/passbooks.<br>Never allow anyone to access your screen remotely.',
    'సన్నివేశం: గ్యాస్ సిలిండర్ లేదా కొరియర్ సమస్య కోసం గూగుల్‌లో సెర్చ్ చేసి నంబర్‌కు కాల్ చేయడం.<br>ప్రమాదం: సైబర్ నేరగాళ్లు గూగుల్‌లో తమ సొంత నంబర్లను నకిలీ కస్టమర్ కేర్‌గా నమోదు చేస్తారు.<br>వారి మోసం: మీ సమస్య పరిష్కరిస్తామని చెప్పి ఏదైనా యాప్ ఇన్‌స్టాల్ చేయమని లేదా 10 రూపాయలు పంపమని అడుగుతారు.<br>రక్షణ మార్గం: ఎల్లప్పుడూ అధికారిక యాప్‌లు లేదా మీ ఒరిజినల్ రశీదులపై ఉన్న నంబర్లను మాత్రమే సంప్రదించండి.<br>ఎవరికీ మీ స్క్రీన్‌ను రిమోట్ యాక్సెస్ ఇవ్వకండి.',
    8,
    'alert-triangle'
),
(
    'scam_awareness',
    'Electricity Bill and Pension Cut-off SMS Scams',
    'కరెంట్ బిల్లు మరియు పెన్షన్ ఆగిపోతుందనే నకిలీ ఎస్సెమ్మెస్‌లు',
    'Identify threatening SMS messages sent from personal mobile numbers demanding urgent action.',
    'వ్యక్తిగత మొబైల్ నంబర్ల నుండి వచ్చే బెదిరింపు ఎస్సెమ్మెస్‌లను గుర్తించి జాగ్రత్తపడటం.',
    'Typical Message: "Dear Consumer, your electricity power will be disconnected tonight at 9:30 PM because your previous bill was not updated. Call electricity officer at 98xxxxxx."<br>How to spot fraud:<br>1. Official government messages come from sender headers like APCPDCL, TSSPDCL, not from 10-digit mobile numbers.<br>2. Real departments do not disconnect power without formal written notices.<br>3. They will instruct you to install an APK file. Never install it.<br>Action: Report the sender number immediately on the 1930 cyber portal.',
    'సాధారణ మోసపూరిత మెసేజ్: "గౌరవనీయ వినియోగదారుడా, మీ విద్యుత్ బిల్లు అప్‌డేట్ కాలేదు కాబట్టి ఈ రాత్రి 9:30కి మీ కరెంట్ కట్ చేయబడుతుంది. వెంటనే ఈ ఆఫీసర్ నంబర్‌కు కాల్ చేయండి."<br>మోసాన్ని గుర్తించడం ఎలా:<br>1. ప్రభుత్వ విద్యుత్ సంస్థల మెసేజ్‌లు అధికారిక హెడర్లతో వస్తాయి, 10 అంకెల సాధారణ నంబర్ల నుండి రావు.<br>2. వ్రాతపూర్వక నోటీసు లేకుండా ఏ విభాగం కూడా అకస్మాత్తుగా కనెక్షన్ కట్ చేయదు.<br>3. వారు లింక్ పంపి యాప్ డౌన్‌లోడ్ చేయమంటారు. ఎట్టిపరిస్థితుల్లోనూ చేయవద్దు.<br>చేయవలసిన పని: వెంటనే ఈ మెసేజ్‌ను విస్మరించండి లేదా 1930కి ఫిర్యాదు చేయండి.',
    9,
    'zap-off'
),
(
    'scam_awareness',
    'Remote Access Apps Scam: Never Install AnyDesk or QuickSupport for Strangers',
    'రిమోట్ యాక్సెస్ యాప్‌ల మోసం: AnyDesk లేదా TeamViewer ఎప్పుడూ ఇన్‌స్టాల్ చేయవద్దు',
    'Understand how fraudsters see your phone screen and steal banking passwords through screen sharing.',
    'మోసగాళ్లు మీ ఫోన్ స్క్రీన్‌ను చూస్తూ బ్యాంక్ పాస్‌వర్డ్‌లను ఎలా దొంగిలిస్తారో తెలుసుకోండి.',
    'What is Remote Access? Apps like AnyDesk, TeamViewer QuickSupport, or RustDesk allow someone elsewhere to see your screen and control your phone.<br>The Scam: Fraudsters pose as bank officers, KYC executives, or courier delivery agents. They ask you to install one of these apps to "assist you".<br>The Result: Once installed, they ask for a 9-digit code. If you share it, they can see your bank account number, read your OTPs on screen, and steal your money.<br>Protection: NEVER install any application suggested by an incoming phone caller.',
    'రిమోట్ యాక్సెస్ అంటే ఏమిటి? AnyDesk, TeamViewer లేదా QuickSupport వంటి యాప్‌లు వేరే చోట ఉన్నవారికి మీ ఫోన్ స్క్రీన్‌ను చూసేందుకు అనుమతిస్తాయి.<br>మోసం జరిగే విధానం: సైబర్ నేరగాళ్లు తాము బ్యాంక్ అధికారులమని లేదా కేవైసీ ఏజెంట్లమని నమ్మించి ఈ యాప్‌లను ఇన్‌స్టాల్ చేయమని చెబుతారు.<br>ఫలితం: యాప్ ఓపెన్ చేయగానే కనిపించే 9 అంకెల కోడ్‌ను మీరు వారికి చెబితే, మీ ఫోన్ స్క్రీన్ మొత్తం వారికి కనిపిస్తుంది. వారు మీ బ్యాంక్ లావాదేవీలు మరియు ఓటీపీలను చూసి డబ్బు లాగేసుకుంటారు.<br>భద్రతా సూత్రం: ఫోన్ కాల్‌లో ఎవరైనా యాప్ డౌన్‌లోడ్ చేయమంటే వెంటనే కాల్ కట్ చేయండి.',
    10,
    'smartphone'
);
