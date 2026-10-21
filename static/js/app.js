const CLIENT_TRANSLATIONS = {
    'en': {
        'nav_home': 'Home',
        'nav_about': 'About',
        'nav_learn': 'Learn',
        'nav_tutorials': 'Tutorials',
        'nav_smartphone_basics': 'Smartphone Basics',
        'nav_digital_safety': 'Digital Safety',
        'nav_payments': 'Payment Safety',
        'nav_scams': 'Scam Awareness',
        'nav_quiz': 'Safety Quiz',
        'nav_request_help': 'Request Help',
        'nav_contact': 'Contact Us',
        'nav_login': 'Login',
        'nav_register': 'Register',
        'nav_logout': 'Logout',
        'nav_dashboard': 'My Dashboard',
        'nav_profile': 'My Profile',
        'nav_my_requests': 'My Help Requests',
        'nav_volunteer_portal': 'Volunteer Portal',
        'nav_admin_panel': 'Admin Dashboard',
        'btn_start_learning': 'Start Learning',
        'btn_stay_safe': 'Stay Safe Online',
        'btn_request_help': 'Request Volunteer Help',
        'btn_submit': 'Submit',
        'btn_save': 'Save Changes',
        'btn_cancel': 'Cancel',
        'btn_back': 'Go Back',
        'btn_mark_completed': 'Mark as Completed',
        'btn_completed': 'Completed',
        'btn_take_quiz': 'Take Safety Quiz',
        'btn_retake_quiz': 'Retake Quiz',
        'btn_view_details': 'View Details',
        'status_pending': 'Pending',
        'status_assigned': 'Assigned',
        'status_in_progress': 'In Progress',
        'status_resolved': 'Resolved',
        'status_closed': 'Closed',
        'form_full_name': 'Full Name',
        'form_email': 'Email Address',
        'form_mobile': 'Mobile Number',
        'form_password': 'Password',
        'form_confirm_password': 'Confirm Password',
        'emergency_banner': 'National Cyber Crime Helpline: Dial 1930 or visit cybercrime.gov.in for immediate fraud reporting.'
    },
    'te': {
        'nav_home': 'హోమ్',
        'nav_about': 'గురించి',
        'nav_learn': 'నేర్చుకోండి',
        'nav_tutorials': 'పాఠాలు',
        'nav_smartphone_basics': 'స్మార్ట్‌ఫోన్ ప్రాథమికాంశాలు',
        'nav_digital_safety': 'డిజిటల్ భద్రత',
        'nav_payments': 'చెల్లింపుల భద్రత',
        'nav_scams': 'మోసాలపై అవగాహన',
        'nav_quiz': 'భద్రతా క్విజ్',
        'nav_request_help': 'సహాయం కోరండి',
        'nav_contact': 'సంప్రదించండి',
        'nav_login': 'లాగిన్',
        'nav_register': 'నమోదు చేసుకోండి',
        'nav_logout': 'లాగ్ అవుట్',
        'nav_dashboard': 'నా డాష్‌బోర్డ్',
        'nav_profile': 'నా ప్రొఫైల్',
        'nav_my_requests': 'నా సహాయ అభ్యర్థనలు',
        'nav_volunteer_portal': 'వాలంటీర్ పోర్టల్',
        'nav_admin_panel': 'అడ్మిన్ డాష్‌బోర్డ్',
        'btn_start_learning': 'నేర్చుకోవడం ప్రారంభించండి',
        'btn_stay_safe': 'ఆన్‌లైన్‌లో సురక్షితంగా ఉండండి',
        'btn_request_help': 'వాలంటీర్ సహాయం కోరండి',
        'btn_submit': 'సమర్పించండి',
        'btn_save': 'మార్పులను సేవ్ చేయండి',
        'btn_cancel': 'రద్దు చేయండి',
        'btn_back': 'వెనుకకు వెళ్లండి',
        'btn_mark_completed': 'పూర్తయినట్లు గుర్తించండి',
        'btn_completed': 'పూర్తయింది',
        'btn_take_quiz': 'భద్రతా క్విజ్ రాయండి',
        'btn_retake_quiz': 'మళ్ళీ క్విజ్ రాయండి',
        'btn_view_details': 'వివరాలు చూడండి',
        'status_pending': 'పెండింగ్‌లో ఉంది',
        'status_assigned': 'కేటాయించబడింది',
        'status_in_progress': 'పరిశీలనలో ఉంది',
        'status_resolved': 'పరిష్కరించబడింది',
        'status_closed': 'ముగిసింది',
        'form_full_name': 'పూర్తి పేరు',
        'form_email': 'ఈమెయిల్ చిరునామా',
        'form_mobile': 'మొబైల్ నంబర్',
        'form_password': 'పాస్‌వర్డ్',
        'form_confirm_password': 'పాస్‌వర్డ్ ధృవీకరణ',
        'emergency_banner': 'జాతీయ సైబర్ క్రైమ్ హెల్ప్‌లైన్: తక్షణ సైబర్ మోసాల ఫిర్యాదు కోసం 1930కి డయల్ చేయండి లేదా cybercrime.gov.in ని సందర్శించండి.'
    }
};

const QUIZ_DATA = {
    'en': [
        {
            q: "You receive an SMS saying your electricity power will be disconnected at 9:30 PM tonight unless you call an unknown mobile number immediately. What should you do?",
            options: [
                "Call the mobile number immediately and follow their instructions",
                "Ignore the SMS and do not call; official departments never send personal cell phone numbers for disconnections",
                "Install whatever app they ask you to download to pay 10 rupees"
            ],
            correct: 1,
            explanation: "Correct! Electricity departments never send threat SMS from 10-digit mobile numbers demanding you call a personal number. This is a common cyber fraud."
        },
        {
            q: "A caller claims you have won 50,000 rupees in a lucky draw and asks you to scan a QR code and enter your UPI PIN to receive the money. What should you do?",
            options: [
                "Scan the QR code and enter UPI PIN right away",
                "Ask a family member to enter their UPI PIN instead",
                "Disconnect the call immediately; receiving money NEVER requires entering your UPI PIN"
            ],
            correct: 2,
            explanation: "Correct! The golden rule of UPI: Entering your UPI PIN always DEDUCTS money from your bank account. Receiving money never needs a PIN."
        },
        {
            q: "Someone calls claiming to be from your bank customer care and asks you to install 'AnyDesk' or 'QuickSupport' on your phone to solve your problem. What is the right response?",
            options: [
                "Never install AnyDesk or screen-sharing apps for callers; they can see your phone screen and steal your passwords",
                "Install it immediately since the caller sounds polite",
                "Install it and give them the 9-digit access code"
            ],
            correct: 0,
            explanation: "Correct! AnyDesk and QuickSupport allow scammers to remotely control your phone, read your passwords, and view incoming OTPs."
        },
        {
            q: "You receive a message saying: 'Your Bank account or PAN card is blocked. Click this link immediately to update KYC'. What should you do?",
            options: [
                "Click the link and type your debit card number and PIN",
                "Forward the message to your friends",
                "Do not click the link; delete the message or visit your bank branch directly"
            ],
            correct: 2,
            explanation: "Correct! Banks never send unknown links asking for sensitive debit card or internet banking credentials."
        },
        {
            q: "A friendly stranger at an ATM machine offers to help you withdraw money and asks for your 4-digit ATM PIN. What should you do?",
            options: [
                "Tell them the PIN so they can press the buttons for you",
                "Politely refuse and never share your ATM PIN with any stranger; ask only bank security or a trusted family member",
                "Write your PIN on the back of your card"
            ],
            correct: 1,
            explanation: "Correct! Never disclose your ATM PIN to strangers. Always guard the keypad with your hand when entering your PIN."
        }
    ],
    'te': [
        {
            q: "ఈ రాత్రి 9:30 గంటలకు మీ విద్యుత్ కనెక్షన్ కట్ చేయబడుతుందని, వెంటనే ఒక మొబైల్ నంబర్‌కు కాల్ చేయాలని ఎస్సెమ్మెస్ వచ్చింది. మీరు ఏమి చేయాలి?",
            options: [
                "వెంటనే ఆ నంబర్‌కు కాల్ చేసి వారు చెప్పినట్లు చేయాలి",
                "ఆ మెసేజ్‌ను విస్మరించాలి; ప్రభుత్వ విద్యుత్ సంస్థలు వ్యక్తిగత సెల్ నంబర్ల నుండి ఇలాంటి బెదిరింపు మెసేజ్‌లు పంపవు",
                "10 రూపాయల బిల్లు చెల్లించడానికి వారు పంపే లింక్ ద్వారా యాప్ డౌన్‌లోడ్ చేయాలి"
            ],
            correct: 1,
            explanation: "సరైన సమాధానం! ప్రభుత్వ విద్యుత్ శాఖలు ఎప్పుడూ 10 అంకెల మొబైల్ నంబర్ల ద్వారా విద్యుత్ నిలిపివేత మెసేజ్‌లు పంపవు. ఇది సాధారణ సైబర్ మోసం."
        },
        {
            q: "మీకు లక్కీ డ్రాలో రూ. 50,000 నగదు బహుమతి వచ్చిందని, డబ్బులు అందుకోవడానికి QR కోడ్ స్కాన్ చేసి UPI పిన్ నొక్కమని కాల్ వచ్చింది. మీరు ఏమి చేయాలి?",
            options: [
                "వెంటనే QR కోడ్ స్కాన్ చేసి మీ UPI పిన్ ఎంటర్ చేయాలి",
                "మీ కుటుంబ సభ్యుల ఫోన్ నుండి పిన్ నొక్కాలి",
                "వెంటనే ఫోన్ కట్ చేయాలి; డబ్బులు అందుకోవడానికి ఎప్పుడూ UPI పిన్ అవసరం లేదు"
            ],
            correct: 2,
            explanation: "సరైన సమాధానం! UPI గోల్డెన్ రూల్: మీ బ్యాంక్ ఖాతా నుండి డబ్బు కట్ కావడానికి మాత్రమే పిన్ అవసరం. ఎవరైనా డబ్బు పంపుతుంటే పిన్ ఎంటర్ చేయాల్సిన పని లేదు."
        },
        {
            q: "బ్యాంక్ కస్టమర్ కేర్ నుండి మాట్లాడుతున్నామని చెప్పి, మీ సమస్య పరిష్కారం కోసం AnyDesk లేదా QuickSupport యాప్ డౌన్‌లోడ్ చేయమని ఒక వ్యక్తి అడిగితే మీరు ఏమి చేయాలి?",
            options: [
                "ఎట్టిపరిస్థితుల్లోనూ AnyDesk లేదా స్క్రీన్ షేరింగ్ యాప్‌లను డౌన్‌లోడ్ చేయకూడదు; అవి మీ ఫోన్ పాస్‌వర్డ్‌లను దొంగిలిస్తాయి",
                "వారు మర్యాదగా మాట్లాడుతున్నారు కాబట్టి వెంటనే ఇన్‌స్టాల్ చేయాలి",
                "ఇన్‌స్టాల్ చేసి అందులో కనిపించే 9 అంకెల కోడ్‌ను వారికి చెప్పాలి"
            ],
            correct: 0,
            explanation: "సరైన సమాధానం! AnyDesk మరియు TeamViewer వంటి యాప్‌ల ద్వారా సైబర్ నేరగాళ్లు మీ ఫోన్ స్క్రీన్‌ను నేరుగా చూస్తూ మీ OTPలు మరియు బ్యాంక్ వివరాలను దొంగిలిస్తారు."
        },
        {
            q: "'మీ పాన్ కార్డు లేదా బ్యాంక్ ఖాతా బ్లాక్ చేయబడింది. వెంటనే ఈ లింక్ క్లిక్ చేసి KYC అప్‌డేట్ చేయండి' అని వచ్చిన మెసేజ్‌కు మీరు ఏమి చేయాలి?",
            options: [
                "లింక్ ఓపెన్ చేసి డెబిట్ కార్డు నంబర్ మరియు పిన్ ఎంటర్ చేయాలి",
                "ఆ లింక్‌ను బంధువులకు ఫార్వర్డ్ చేయాలి",
                "ఆ లింక్‌ను ఎప్పుడూ క్లిక్ చేయకూడదు; నేరుగా మీ బ్యాంక్ శాఖను సంప్రదించాలి"
            ],
            correct: 2,
            explanation: "సరైన సమాధానం! బ్యాంకులు ఎప్పుడూ అనామక లింక్‌ల ద్వారా వ్యక్తిగత లేదా కార్డ్ వివరాలను అడగవు."
        },
        {
            q: "ATM వద్ద ఒక తెలియని వ్యక్తి మీకు డబ్బులు తీసిపెడతానని చెప్పి మీ 4 అంకెల ATM పిన్ అడిగితే మీరు ఏమి చేయాలి?",
            options: [
                "వారు బటన్లు నొక్కడానికి పిన్ నంబర్ వారికి చెప్పాలి",
                "మర్యాదగా నిరాకరించాలి; మీ ATM పిన్ ఎవరితోనూ పంచుకోకూడదు, కేవలం కుటుంబ సభ్యుల సహాయం మాత్రమే తీసుకోవాలి",
                "కార్డు వెనుక పిన్ నంబర్ రాసి ఉంచాలి"
            ],
            correct: 1,
            explanation: "సరైన సమాధానం! ATM పిన్ అనేది రహస్యమైనది. ఎట్టిపరిస్థితుల్లోనూ ఇతరులకు చెప్పకూడదు."
        }
    ]
};

document.addEventListener('DOMContentLoaded', function () {
    const savedFontSize = localStorage.getItem('digitalsaathi_fontsize');
    if (savedFontSize) {
        document.body.classList.remove('font-large', 'font-xlarge');
        if (savedFontSize === 'large') document.body.classList.add('font-large');
        if (savedFontSize === 'xlarge') document.body.classList.add('font-xlarge');
    }

    const savedContrast = localStorage.getItem('digitalsaathi_contrast');
    if (savedContrast === 'high') {
        document.body.classList.add('high-contrast');
    }

    const btnFontNormal = document.getElementById('btn-font-normal');
    const btnFontLarge = document.getElementById('btn-font-large');
    const btnFontXlarge = document.getElementById('btn-font-xlarge');
    const btnContrast = document.getElementById('btn-contrast-toggle');

    if (btnFontNormal) {
        btnFontNormal.addEventListener('click', function () {
            document.body.classList.remove('font-large', 'font-xlarge');
            localStorage.setItem('digitalsaathi_fontsize', 'normal');
        });
    }

    if (btnFontLarge) {
        btnFontLarge.addEventListener('click', function () {
            document.body.classList.remove('font-large', 'font-xlarge');
            document.body.classList.add('font-large');
            localStorage.setItem('digitalsaathi_fontsize', 'large');
        });
    }

    if (btnFontXlarge) {
        btnFontXlarge.addEventListener('click', function () {
            document.body.classList.remove('font-large', 'font-xlarge');
            document.body.classList.add('font-xlarge');
            localStorage.setItem('digitalsaathi_fontsize', 'xlarge');
        });
    }

    if (btnContrast) {
        btnContrast.addEventListener('click', function () {
            document.body.classList.toggle('high-contrast');
            const isHigh = document.body.classList.contains('high-contrast');
            localStorage.setItem('digitalsaathi_contrast', isHigh ? 'high' : 'normal');
        });
    }

    const navToggle = document.getElementById('mobileNavToggle');
    const mainNav = document.getElementById('mainNavigation');
    if (navToggle && mainNav) {
        navToggle.addEventListener('click', function (e) {
            e.stopPropagation();
            mainNav.classList.toggle('is-open');
            const isOpen = mainNav.classList.contains('is-open');
            navToggle.innerHTML = isOpen ? '&times;' : '&#9776;';
            if (isOpen) {
                document.body.style.overflow = 'hidden';
            } else {
                document.body.style.overflow = '';
            }
        });

        function closeNav() {
            if (mainNav.classList.contains('is-open')) {
                mainNav.classList.remove('is-open');
                navToggle.innerHTML = '&#9776;';
                document.body.style.overflow = '';
            }
        }

        document.addEventListener('click', function (e) {
            if (!mainNav.contains(e.target) && !navToggle.contains(e.target)) {
                closeNav();
            }
        });

        mainNav.querySelectorAll('.nav-link:not(.nav-dropdown-toggle), .dropdown-item').forEach(function (link) {
            link.addEventListener('click', function () {
                closeNav();
            });
        });
    }

    document.querySelectorAll('.nav-dropdown-toggle').forEach(function (btn) {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            const parent = this.closest('.nav-dropdown');
            if (parent) {
                parent.classList.toggle('is-active');
            }
        });
    });

    document.querySelectorAll('.lang-pill').forEach(function (pill) {
        pill.addEventListener('click', function (e) {
            e.preventDefault();
            const targetLang = this.getAttribute('data-lang');
            setLanguageClient(targetLang);
        });
    });

    initQuiz();
});

function setLanguageClient(lang) {
    localStorage.setItem('digitalsaathi_lang', lang);
    document.documentElement.lang = lang;

    fetch('/set-language/' + lang, {
        method: 'POST',
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(function () {
        window.location.reload();
    })
    .catch(function () {
        window.location.href = '/set-language/' + lang;
    });
}

function initQuiz() {
    const quizContainer = document.getElementById('quiz-questions-container');
    if (!quizContainer) return;

    const currentLang = document.documentElement.lang === 'te' ? 'te' : 'en';
    const questions = QUIZ_DATA[currentLang] || QUIZ_DATA['en'];
    let userAnswers = {};

    quizContainer.innerHTML = '';

    questions.forEach(function (qItem, qIndex) {
        const card = document.createElement('div');
        card.className = 'quiz-card';

        const numBadge = document.createElement('div');
        numBadge.className = 'quiz-question-number';
        numBadge.textContent = (currentLang === 'te' ? 'ప్రశ్న ' : 'Question ') + (qIndex + 1) + ' / ' + questions.length;
        card.appendChild(numBadge);

        const qTitle = document.createElement('div');
        qTitle.className = 'quiz-question-text';
        qTitle.textContent = qItem.q;
        card.appendChild(qTitle);

        const optionsWrap = document.createElement('div');
        optionsWrap.className = 'quiz-options';

        qItem.options.forEach(function (optText, optIndex) {
            const optBtn = document.createElement('button');
            optBtn.type = 'button';
            optBtn.className = 'quiz-option-btn';
            optBtn.innerHTML = '<strong>' + String.fromCharCode(65 + optIndex) + '.</strong> <span>' + optText + '</span>';

            optBtn.addEventListener('click', function () {
                if (userAnswers[qIndex] !== undefined) return;
                userAnswers[qIndex] = optIndex;

                const allOptions = optionsWrap.querySelectorAll('.quiz-option-btn');
                allOptions.forEach(function (b, idx) {
                    if (idx === qItem.correct) {
                        b.classList.add('correct');
                    } else if (idx === optIndex && optIndex !== qItem.correct) {
                        b.classList.add('incorrect');
                    }
                });

                expl.classList.add('show');
                if (optIndex === qItem.correct) {
                    expl.className = 'quiz-explanation show alert alert-success';
                    expl.innerHTML = '&#10004; ' + qItem.explanation;
                } else {
                    expl.className = 'quiz-explanation show alert alert-danger';
                    expl.innerHTML = '&#10008; ' + (currentLang === 'te' ? 'తప్పు ఎంపిక. ' : 'Incorrect choice. ') + qItem.explanation;
                }

                checkQuizCompletion(questions, userAnswers);
            });

            optionsWrap.appendChild(optBtn);
        });

        card.appendChild(optionsWrap);

        const expl = document.createElement('div');
        expl.className = 'quiz-explanation';
        card.appendChild(expl);

        quizContainer.appendChild(card);
    });
}

function checkQuizCompletion(questions, userAnswers) {
    if (Object.keys(userAnswers).length === questions.length) {
        let score = 0;
        questions.forEach(function (qItem, qIdx) {
            if (userAnswers[qIdx] === qItem.correct) score++;
        });

        const scoreBanner = document.getElementById('quiz-score-banner');
        const scoreText = document.getElementById('quiz-score-text');
        const currentLang = document.documentElement.lang === 'te' ? 'te' : 'en';

        if (scoreBanner && scoreText) {
            scoreBanner.style.display = 'block';
            const pct = Math.round((score / questions.length) * 100);
            if (currentLang === 'te') {
                scoreText.innerHTML = 'మీ స్కోరు: <strong>' + score + ' / ' + questions.length + ' (' + pct + '%)</strong><br>' + (pct >= 80 ? 'అభినందనలు! మీకు అద్భుతమైన సైబర్ భద్రతా అవగాహన ఉంది.' : 'మంచి ప్రయత్నం! భద్రతా నియమాలను మరొకసారి చదవండి.');
            } else {
                scoreText.innerHTML = 'Your Safety Score: <strong>' + score + ' / ' + questions.length + ' (' + pct + '%)</strong><br>' + (pct >= 80 ? 'Congratulations! You have strong fraud defense awareness.' : 'Good effort! Please review our safety guidelines to stay extra secure.');
            }
            scoreBanner.scrollIntoView({ behavior: 'smooth' });
        }

        fetch('/quiz/submit', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                score: score,
                total_questions: questions.length,
                topic: 'Online Scam Awareness Quiz'
            })
        }).catch(function () {});
    }
}
