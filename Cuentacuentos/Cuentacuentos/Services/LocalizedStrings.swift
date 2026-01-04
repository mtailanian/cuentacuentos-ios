import Foundation

struct LocalizedStrings {
    static func string(for key: String, language: Story.Language) -> String {
        let strings = translations[language] ?? translations[.spanish]!
        return strings[key] ?? key
    }
    
    private static let translations: [Story.Language: [String: String]] = [
        .spanish: [
            // App name and header
            "app.name": "Cuentacuentos",
            "app.tagline": "Historias con IA para niños",
            "app.description": "Ingresa un nombre, edad, idioma e idea—o deja que elijamos un tema aleatorio—para una historia cálida y amigable para niños con narración opcional.",
            
            // Form fields
            "form.name": "Nombre",
            "form.name.placeholder": "ej., Sofía",
            "form.age": "Edad",
            "form.age.placeholder": "ej., 6",
            "form.story.idea": "Idea de la historia",
            "form.random.topic": "Tema aleatorio",
            "form.story.idea.hint": "Deja en blanco o marca 'Tema aleatorio' para una sorpresa",
            "form.length": "Duración",
            "form.language": "Idioma",
            "form.generate": "Generar historia",
            "form.name.required": "El nombre es requerido",
            "form.age.invalid": "Por favor ingresa una edad válida entre 1 y 15",
            "form.age.error": "Por favor ingresa una edad válida",
            
            // Story display
            "story.your.story": "TU HISTORIA",
            "story.for": "Para",
            "story.age": "Edad",
            "story.playback.voice": "Voz de reproducción",
            "story.voice.hint": "Cambia el narrador sin regenerar la historia.",
            "story.save": "Guardar",
            "story.share": "Compartir",
            
            // Saved stories
            "saved.stories": "Historias guardadas",
            "saved.stories.description": "Revive aventuras pasadas. Se quedan en este dispositivo.",
            "saved.stories.empty": "Aún no hay historias guardadas. Genera una y toca Guardar.",
            "saved.label": "GUARDADA",
            "saved.read": "Leer",
            "saved.delete": "Eliminar",
            "saved.voice": "Voz:",
            "saved.auto": "Auto",
            
            // Audio player
            "audio.play": "Reproducir",
            "audio.playing": "Reproduciendo",
            "audio.pause": "Pausar",
            "audio.stop": "Detener",
            "audio.preparing": "Preparando...",
            
            // Length options
            "length.short": "Corta (~250 palabras)",
            "length.medium": "Media (~400 palabras)",
            "length.long": "Larga (~600 palabras)",
            
            // Language names (for UI)
            "language.spanish": "Español",
            "language.english": "Inglés",
            "language.french": "Francés",
            "language.german": "Alemán",
            "language.italian": "Italiano",
            "language.portuguese": "Portugués",
            "language.japanese": "Japonés",
            
            // Tabs
            "tab.generate": "Generar",
            "tab.saved": "Guardadas",
            "tab.profile": "Perfil",
            
            // Profile
            "profile.user.section": "Perfil",
            "profile.name.placeholder": "Tu nombre",
            "profile.photo.placeholder": "Elige una foto",
            "profile.language.section": "Idioma preferido",
            "profile.credits.section": "Créditos",
            "profile.credits.balance": "Saldo",
            "profile.credits.add": "Agregar créditos (próximamente)",
            "profile.payment.card": "Agregar tarjeta (próximamente)",
            "profile.payment.iap": "Compras en la app (próximamente)",
            "profile.settings.section": "Ajustes",
            "profile.notifications": "Notificaciones",
            "profile.mock.note": "Funciones simuladas por ahora",
            
            // Defaults
            "form.default.name": "Amigo",
            // Form labels
            "form.age.target": "Edad objetivo del cuento",
            // Themes
            "theme.morning": "Mañana suave",
            "theme.sunset": "Atardecer vibrante",
            "theme.night": "Noche estrellada",
            "theme.forest": "Bosque encantado",
            "theme.candy": "Dulce algodón",
            "theme.ocean": "Olas brillantes",
            "theme.galaxy": "Cielo galáctico",
            "theme.select": "Elige un tema",
            
            // Splash
            "splash.title": "Historias con IA para niños",
            "splash.subtitle": "Crea cuentos cálidos, amigables y narrados para los peques.",
            "splash.start": "Comenzar",
            
            // Generate header
            "generate.title": "Crea una historia mágica",
            
            // UI Language selector
            "ui.language": "Idioma de la interfaz"
        ],
        .english: [
            // App name and header
            "app.name": "Cuentacuentos",
            "app.tagline": "AI-powered stories for kids",
            "app.description": "Enter a name, age, language, and idea—or let us pick a random topic—for a warm, kid-friendly story with optional narration.",
            
            // Form fields
            "form.name": "Name",
            "form.name.placeholder": "e.g., Sofia",
            "form.age": "Age",
            "form.age.placeholder": "e.g., 6",
            "form.story.idea": "Story Idea",
            "form.random.topic": "Random Topic",
            "form.story.idea.hint": "Leave blank or check 'Random Topic' for a surprise story",
            "form.length": "Length",
            "form.language": "Language",
            "form.generate": "Generate Story",
            "form.name.required": "Name is required",
            "form.age.invalid": "Please enter a valid age between 1 and 15",
            "form.age.error": "Please enter a valid age",
            
            // Story display
            "story.your.story": "YOUR STORY",
            "story.for": "For",
            "story.age": "Age",
            "story.playback.voice": "Playback Voice",
            "story.voice.hint": "Change the speaker without regenerating the story.",
            "story.save": "Save",
            "story.share": "Share",
            
            // Saved stories
            "saved.stories": "Saved stories",
            "saved.stories.description": "Revisit past adventures. They stay on this device.",
            "saved.stories.empty": "No stories saved yet. Generate one and tap Save.",
            "saved.label": "SAVED",
            "saved.read": "Read",
            "saved.delete": "Delete",
            "saved.voice": "Voice:",
            "saved.auto": "Auto",
            
            // Audio player
            "audio.play": "Play",
            "audio.playing": "Playing",
            "audio.pause": "Pause",
            "audio.stop": "Stop",
            "audio.preparing": "Preparing...",
            
            // Length options
            "length.short": "Short (~250 words)",
            "length.medium": "Medium (~400 words)",
            "length.long": "Long (~600 words)",
            
            // Language names (for UI)
            "language.spanish": "Spanish",
            "language.english": "English",
            "language.french": "French",
            "language.german": "German",
            "language.italian": "Italian",
            "language.portuguese": "Portuguese",
            "language.japanese": "Japanese",
            
            // Tabs
            "tab.generate": "Generate",
            "tab.saved": "Saved",
            "tab.profile": "Profile",
            
            // Profile
            "profile.user.section": "Profile",
            "profile.name.placeholder": "Your name",
            "profile.photo.placeholder": "Pick a photo",
            "profile.language.section": "Preferred language",
            "profile.credits.section": "Credits",
            "profile.credits.balance": "Balance",
            "profile.credits.add": "Add credits (coming soon)",
            "profile.payment.card": "Add card (coming soon)",
            "profile.payment.iap": "In-app purchases (coming soon)",
            "profile.settings.section": "Settings",
            "profile.notifications": "Notifications",
            "profile.mock.note": "These items are mocked for now",
            
            // Defaults
            "form.default.name": "Friend",
            // Form labels
            "form.age.target": "Target age for the story",
            // Themes
            "theme.morning": "Soft morning",
            "theme.sunset": "Vibrant sunset",
            "theme.night": "Starry night",
            "theme.forest": "Enchanted forest",
            "theme.candy": "Candy clouds",
            "theme.ocean": "Shimmering waves",
            "theme.galaxy": "Cosmic sky",
            "theme.select": "Pick a theme",
            
            // Splash
            "splash.title": "AI-powered stories for kids",
            "splash.subtitle": "Create warm, friendly, narrated stories for little ones.",
            "splash.start": "Get started",
            
            // Generate header
            "generate.title": "Create a magical story",
            
            // UI Language selector
            "ui.language": "Interface Language"
        ],
        .french: [
            "app.name": "Cuentacuentos",
            "app.tagline": "Histoires avec IA pour enfants",
            "app.description": "Entrez un nom, un âge, une langue et une idée—ou laissez-nous choisir un sujet aléatoire—pour une histoire chaleureuse et adaptée aux enfants avec narration optionnelle.",
            "form.name": "Nom",
            "form.name.placeholder": "ex., Sophie",
            "form.age": "Âge",
            "form.age.placeholder": "ex., 6",
            "form.story.idea": "Idée d'histoire",
            "form.random.topic": "Sujet aléatoire",
            "form.story.idea.hint": "Laissez vide ou cochez 'Sujet aléatoire' pour une surprise",
            "form.length": "Longueur",
            "form.language": "Langue",
            "form.generate": "Générer l'histoire",
            "form.name.required": "Le nom est requis",
            "form.age.invalid": "Veuillez entrer un âge valide entre 1 et 15",
            "form.age.error": "Veuillez entrer un âge valide",
            "story.your.story": "VOTRE HISTOIRE",
            "story.for": "Pour",
            "story.age": "Âge",
            "story.playback.voice": "Voix de lecture",
            "story.voice.hint": "Changez le narrateur sans régénérer l'histoire.",
            "story.save": "Enregistrer",
            "story.share": "Partager",
            "saved.stories": "Histoires enregistrées",
            "saved.stories.description": "Revivez les aventures passées. Elles restent sur cet appareil.",
            "saved.stories.empty": "Aucune histoire enregistrée. Générez-en une et appuyez sur Enregistrer.",
            "saved.label": "ENREGISTRÉE",
            "saved.read": "Lire",
            "saved.delete": "Supprimer",
            "saved.voice": "Voix:",
            "saved.auto": "Auto",
            "audio.play": "Lire",
            "audio.playing": "En cours",
            "audio.pause": "Pause",
            "audio.stop": "Arrêter",
            "audio.preparing": "Préparation...",
            "length.short": "Courte (~250 mots)",
            "length.medium": "Moyenne (~400 mots)",
            "length.long": "Longue (~600 mots)",
            "language.spanish": "Espagnol",
            "language.english": "Anglais",
            "language.french": "Français",
            "language.german": "Allemand",
            "language.italian": "Italien",
            "language.portuguese": "Portugais",
            "language.japanese": "Japonais",
            
            // Tabs
            "tab.generate": "Créer",
            "tab.saved": "Enregistrées",
            "tab.profile": "Profil",
            
            // Profile
            "profile.user.section": "Profil",
            "profile.name.placeholder": "Votre nom",
            "profile.photo.placeholder": "Choisir une photo",
            "profile.language.section": "Langue préférée",
            "profile.credits.section": "Crédits",
            "profile.credits.balance": "Solde",
            "profile.credits.add": "Ajouter des crédits (bientôt)",
            "profile.payment.card": "Ajouter une carte (bientôt)",
            "profile.payment.iap": "Achats intégrés (bientôt)",
            "profile.settings.section": "Réglages",
            "profile.notifications": "Notifications",
            "profile.mock.note": "Ces éléments sont simulés pour l’instant",
            
            // Defaults
            "form.default.name": "Ami",
            // Form labels
            "form.age.target": "Âge cible pour l'histoire",
            // Themes
            "theme.morning": "Douce matinée",
            "theme.sunset": "Coucher vibrant",
            "theme.night": "Nuit étoilée",
            "theme.forest": "Forêt enchantée",
            "theme.candy": "Nuages sucrés",
            "theme.ocean": "Vagues scintillantes",
            "theme.galaxy": "Ciel galactique",
            "theme.select": "Choisis un thème",
            
            // Splash
            "splash.title": "Histoires IA pour enfants",
            "splash.subtitle": "Créez des contes chaleureux, amicaux et narrés pour les petits.",
            "splash.start": "Commencer",
            
            // Generate header
            "generate.title": "Crée une histoire magique",
            
            "ui.language": "Langue de l'interface"
        ],
        .german: [
            "app.name": "Cuentacuentos",
            "app.tagline": "KI-generierte Geschichten für Kinder",
            "app.description": "Geben Sie einen Namen, ein Alter, eine Sprache und eine Idee ein—oder lassen Sie uns ein zufälliges Thema wählen—für eine warmherzige, kindgerechte Geschichte mit optionaler Erzählung.",
            "form.name": "Name",
            "form.name.placeholder": "z.B., Sofia",
            "form.age": "Alter",
            "form.age.placeholder": "z.B., 6",
            "form.story.idea": "Geschichtenidee",
            "form.random.topic": "Zufälliges Thema",
            "form.story.idea.hint": "Leer lassen oder 'Zufälliges Thema' ankreuzen für eine Überraschung",
            "form.length": "Länge",
            "form.language": "Sprache",
            "form.generate": "Geschichte generieren",
            "form.name.required": "Name ist erforderlich",
            "form.age.invalid": "Bitte geben Sie ein gültiges Alter zwischen 1 und 15 ein",
            "form.age.error": "Bitte geben Sie ein gültiges Alter ein",
            "story.your.story": "IHRE GESCHICHTE",
            "story.for": "Für",
            "story.age": "Alter",
            "story.playback.voice": "Wiedergabestimme",
            "story.voice.hint": "Ändern Sie den Sprecher, ohne die Geschichte neu zu generieren.",
            "story.save": "Speichern",
            "story.share": "Teilen",
            "saved.stories": "Gespeicherte Geschichten",
            "saved.stories.description": "Vergangene Abenteuer wiederholen. Sie bleiben auf diesem Gerät.",
            "saved.stories.empty": "Noch keine Geschichten gespeichert. Generieren Sie eine und tippen Sie auf Speichern.",
            "saved.label": "GESPEICHERT",
            "saved.read": "Lesen",
            "saved.delete": "Löschen",
            "saved.voice": "Stimme:",
            "saved.auto": "Auto",
            "audio.play": "Abspielen",
            "audio.playing": "Wiedergabe",
            "audio.pause": "Pause",
            "audio.stop": "Stopp",
            "audio.preparing": "Vorbereitung...",
            "length.short": "Kurz (~250 Wörter)",
            "length.medium": "Mittel (~400 Wörter)",
            "length.long": "Lang (~600 Wörter)",
            "language.spanish": "Spanisch",
            "language.english": "Englisch",
            "language.french": "Französisch",
            "language.german": "Deutsch",
            "language.italian": "Italienisch",
            "language.portuguese": "Portugiesisch",
            "language.japanese": "Japanisch",
            
            // Tabs
            "tab.generate": "Erstellen",
            "tab.saved": "Gespeichert",
            "tab.profile": "Profil",
            
            // Profile
            "profile.user.section": "Profil",
            "profile.name.placeholder": "Dein Name",
            "profile.photo.placeholder": "Foto auswählen",
            "profile.language.section": "Bevorzugte Sprache",
            "profile.credits.section": "Credits",
            "profile.credits.balance": "Guthaben",
            "profile.credits.add": "Credits hinzufügen (bald)",
            "profile.payment.card": "Karte hinzufügen (bald)",
            "profile.payment.iap": "In-App-Käufe (bald)",
            "profile.settings.section": "Einstellungen",
            "profile.notifications": "Benachrichtigungen",
            "profile.mock.note": "Diese Einträge sind vorerst simuliert",
            
            // Defaults
            "form.default.name": "Freund",
            // Form labels
            "form.age.target": "Zielalter für die Geschichte",
            // Themes
            "theme.morning": "Sanfter Morgen",
            "theme.sunset": "Lebendiger Sonnenuntergang",
            "theme.night": "Sternenklare Nacht",
            "theme.forest": "Zauberwald",
            "theme.candy": "Süße Wolken",
            "theme.ocean": "Schimmernde Wellen",
            "theme.galaxy": "Galaktischer Himmel",
            "theme.select": "Thema auswählen",
            
            // Splash
            "splash.title": "KI-Geschichten für Kinder",
            "splash.subtitle": "Erzähle warme, freundliche Geschichten mit Erzählstimme für Kinder.",
            "splash.start": "Los geht’s",
            
            // Generate header
            "generate.title": "Erzähle eine magische Geschichte",
            
            "ui.language": "Oberflächensprache"
        ],
        .italian: [
            "app.name": "Cuentacuentos",
            "app.tagline": "Storie con IA per bambini",
            "app.description": "Inserisci un nome, età, lingua e idea—o lascia che scegliamo un argomento casuale—per una storia calda e adatta ai bambini con narrazione opzionale.",
            "form.name": "Nome",
            "form.name.placeholder": "es., Sofia",
            "form.age": "Età",
            "form.age.placeholder": "es., 6",
            "form.story.idea": "Idea della storia",
            "form.random.topic": "Argomento casuale",
            "form.story.idea.hint": "Lascia vuoto o seleziona 'Argomento casuale' per una sorpresa",
            "form.length": "Lunghezza",
            "form.language": "Lingua",
            "form.generate": "Genera storia",
            "form.name.required": "Il nome è richiesto",
            "form.age.invalid": "Inserisci un'età valida tra 1 e 15",
            "form.age.error": "Inserisci un'età valida",
            "story.your.story": "LA TUA STORIA",
            "story.for": "Per",
            "story.age": "Età",
            "story.playback.voice": "Voce di riproduzione",
            "story.voice.hint": "Cambia il narratore senza rigenerare la storia.",
            "story.save": "Salva",
            "story.share": "Condividi",
            "saved.stories": "Storie salvate",
            "saved.stories.description": "Rivisita avventure passate. Rimangono su questo dispositivo.",
            "saved.stories.empty": "Nessuna storia salvata. Generane una e tocca Salva.",
            "saved.label": "SALVATA",
            "saved.read": "Leggi",
            "saved.delete": "Elimina",
            "saved.voice": "Voce:",
            "saved.auto": "Auto",
            "audio.play": "Riproduci",
            "audio.playing": "In riproduzione",
            "audio.pause": "Pausa",
            "audio.stop": "Ferma",
            "audio.preparing": "Preparazione...",
            "length.short": "Corta (~250 parole)",
            "length.medium": "Media (~400 parole)",
            "length.long": "Lunga (~600 parole)",
            "language.spanish": "Spagnolo",
            "language.english": "Inglese",
            "language.french": "Francese",
            "language.german": "Tedesco",
            "language.italian": "Italiano",
            "language.portuguese": "Portoghese",
            "language.japanese": "Giapponese",
            
            // Tabs
            "tab.generate": "Genera",
            "tab.saved": "Salvate",
            "tab.profile": "Profilo",
            
            // Profile
            "profile.user.section": "Profilo",
            "profile.name.placeholder": "Il tuo nome",
            "profile.photo.placeholder": "Scegli una foto",
            "profile.language.section": "Lingua preferita",
            "profile.credits.section": "Crediti",
            "profile.credits.balance": "Saldo",
            "profile.credits.add": "Aggiungi crediti (presto)",
            "profile.payment.card": "Aggiungi carta (presto)",
            "profile.payment.iap": "Acquisti in-app (presto)",
            "profile.settings.section": "Impostazioni",
            "profile.notifications": "Notifiche",
            "profile.mock.note": "Elementi simulati per ora",
            
            // Defaults
            "form.default.name": "Amico",
            // Form labels
            "form.age.target": "Età target della storia",
            // Themes
            "theme.morning": "Mattina soffice",
            "theme.sunset": "Tramonto vibrante",
            "theme.night": "Notte stellata",
            "theme.forest": "Foresta incantata",
            "theme.candy": "Nuvole di zucchero",
            "theme.ocean": "Onde scintillanti",
            "theme.galaxy": "Cielo galattico",
            "theme.select": "Scegli un tema",
            
            // Splash
            "splash.title": "Storie IA per bambini",
            "splash.subtitle": "Crea racconti caldi, amichevoli e narrati per i più piccoli.",
            "splash.start": "Inizia",
            
            // Generate header
            "generate.title": "Crea una storia magica",
            
            "ui.language": "Lingua dell'interfaccia"
        ],
        .portuguese: [
            "app.name": "Cuentacuentos",
            "app.tagline": "Histórias com IA para crianças",
            "app.description": "Digite um nome, idade, idioma e ideia—ou deixe-nos escolher um tópico aleatório—para uma história calorosa e adequada para crianças com narração opcional.",
            "form.name": "Nome",
            "form.name.placeholder": "ex., Sofia",
            "form.age": "Idade",
            "form.age.placeholder": "ex., 6",
            "form.story.idea": "Ideia da história",
            "form.random.topic": "Tópico aleatório",
            "form.story.idea.hint": "Deixe em branco ou marque 'Tópico aleatório' para uma surpresa",
            "form.length": "Duração",
            "form.language": "Idioma",
            "form.generate": "Gerar história",
            "form.name.required": "O nome é obrigatório",
            "form.age.invalid": "Digite uma idade válida entre 1 e 15",
            "form.age.error": "Digite uma idade válida",
            "story.your.story": "SUA HISTÓRIA",
            "story.for": "Para",
            "story.age": "Idade",
            "story.playback.voice": "Voz de reprodução",
            "story.voice.hint": "Mude o narrador sem regenerar a história.",
            "story.save": "Salvar",
            "story.share": "Compartilhar",
            "saved.stories": "Histórias salvas",
            "saved.stories.description": "Reviva aventuras passadas. Elas ficam neste dispositivo.",
            "saved.stories.empty": "Nenhuma história salva. Gere uma e toque em Salvar.",
            "saved.label": "SALVA",
            "saved.read": "Ler",
            "saved.delete": "Excluir",
            "saved.voice": "Voz:",
            "saved.auto": "Auto",
            "audio.play": "Reproduzir",
            "audio.playing": "Reproduzindo",
            "audio.pause": "Pausar",
            "audio.stop": "Parar",
            "audio.preparing": "Preparando...",
            "length.short": "Curta (~250 palavras)",
            "length.medium": "Média (~400 palavras)",
            "length.long": "Longa (~600 palavras)",
            "language.spanish": "Espanhol",
            "language.english": "Inglês",
            "language.french": "Francês",
            "language.german": "Alemão",
            "language.italian": "Italiano",
            "language.portuguese": "Português",
            "language.japanese": "Japonês",
            
            // Tabs
            "tab.generate": "Gerar",
            "tab.saved": "Salvas",
            "tab.profile": "Perfil",
            
            // Profile
            "profile.user.section": "Perfil",
            "profile.name.placeholder": "Seu nome",
            "profile.photo.placeholder": "Escolha uma foto",
            "profile.language.section": "Idioma preferido",
            "profile.credits.section": "Créditos",
            "profile.credits.balance": "Saldo",
            "profile.credits.add": "Adicionar créditos (em breve)",
            "profile.payment.card": "Adicionar cartão (em breve)",
            "profile.payment.iap": "Compras no app (em breve)",
            "profile.settings.section": "Configurações",
            "profile.notifications": "Notificações",
            "profile.mock.note": "Itens simulados por enquanto",
            
            // Defaults
            "form.default.name": "Amigo",
            // Form labels
            "form.age.target": "Idade alvo da história",
            // Themes
            "theme.morning": "Manhã suave",
            "theme.sunset": "Pôr vibrante",
            "theme.night": "Noite estrelada",
            "theme.forest": "Floresta encantada",
            "theme.candy": "Nuvens de algodão",
            "theme.ocean": "Ondas brilhantes",
            "theme.galaxy": "Céu galáctico",
            "theme.select": "Escolha um tema",
            
            // Splash
            "splash.title": "Histórias com IA para crianças",
            "splash.subtitle": "Crie contos calorosos, amigáveis e narrados para os pequenos.",
            "splash.start": "Começar",
            
            // Generate header
            "generate.title": "Crie uma história mágica",
            
            "ui.language": "Idioma da interface"
        ],
        .japanese: [
            "app.name": "Cuentacuentos",
            "app.tagline": "AI搭載の子供向けストーリー",
            "app.description": "名前、年齢、言語、アイデアを入力するか、ランダムなトピックを選択して、オプションのナレーション付きの温かみのある子供向けストーリーを作成します。",
            "form.name": "名前",
            "form.name.placeholder": "例：ソフィア",
            "form.age": "年齢",
            "form.age.placeholder": "例：6",
            "form.story.idea": "ストーリーのアイデア",
            "form.random.topic": "ランダムトピック",
            "form.story.idea.hint": "空白のままにするか、「ランダムトピック」をチェックしてサプライズストーリーを取得",
            "form.length": "長さ",
            "form.language": "言語",
            "form.generate": "ストーリーを生成",
            "form.name.required": "名前が必要です",
            "form.age.invalid": "1から15の有効な年齢を入力してください",
            "form.age.error": "有効な年齢を入力してください",
            "story.your.story": "あなたのストーリー",
            "story.for": "対象",
            "story.age": "年齢",
            "story.playback.voice": "再生音声",
            "story.voice.hint": "ストーリーを再生成せずにナレーターを変更します。",
            "story.save": "保存",
            "story.share": "共有",
            "saved.stories": "保存されたストーリー",
            "saved.stories.description": "過去の冒険を再訪。このデバイスに残ります。",
            "saved.stories.empty": "保存されたストーリーはありません。生成して「保存」をタップしてください。",
            "saved.label": "保存済み",
            "saved.read": "読む",
            "saved.delete": "削除",
            "saved.voice": "音声：",
            "saved.auto": "自動",
            "audio.play": "再生",
            "audio.playing": "再生中",
            "audio.pause": "一時停止",
            "audio.stop": "停止",
            "audio.preparing": "準備中...",
            "length.short": "短い（約250語）",
            "length.medium": "中（約400語）",
            "length.long": "長い（約600語）",
            "language.spanish": "スペイン語",
            "language.english": "英語",
            "language.french": "フランス語",
            "language.german": "ドイツ語",
            "language.italian": "イタリア語",
            "language.portuguese": "ポルトガル語",
            "language.japanese": "日本語",
            
            // Tabs
            "tab.generate": "作成",
            "tab.saved": "保存済み",
            "tab.profile": "プロフィール",
            
            // Profile
            "profile.user.section": "プロフィール",
            "profile.name.placeholder": "あなたの名前",
            "profile.photo.placeholder": "写真を選択",
            "profile.language.section": "優先言語",
            "profile.credits.section": "クレジット",
            "profile.credits.balance": "残高",
            "profile.credits.add": "クレジットを追加 (近日公開)",
            "profile.payment.card": "カードを追加 (近日公開)",
            "profile.payment.iap": "アプリ内購入 (近日公開)",
            "profile.settings.section": "設定",
            "profile.notifications": "通知",
            "profile.mock.note": "現在はモック表示です",
            
            // Defaults
            "form.default.name": "ともだち",
            // Form labels
            "form.age.target": "物語の対象年齢",
            // Themes
            "theme.morning": "穏やかな朝",
            "theme.sunset": "鮮やかな夕焼け",
            "theme.night": "星空の夜",
            "theme.forest": "魔法の森",
            "theme.candy": "キャンディの雲",
            "theme.ocean": "きらめく波",
            "theme.galaxy": "銀河の空",
            "theme.select": "テーマを選択",
            
            // Splash
            "splash.title": "子供向けAIストーリー",
            "splash.subtitle": "あたたかく親しみやすい語り付きの物語を作ろう。",
            "splash.start": "はじめる",
            
            // Generate header
            "generate.title": "魔法の物語を作ろう",
            
            "ui.language": "インターフェース言語"
        ]
    ]
}

