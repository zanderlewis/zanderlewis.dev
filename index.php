<?php
require 'php/projects.php';
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Zander Lewis</title>
    <meta name="postaverse-web-verification" content="cf4cb6dcac062435b53fdc8dfaaa493f">
    <!-- SEO -->
    <link rel="canonical" href="https://zanderlewis.dev" />
    <meta name="description" content="Software/AI developer. I make software and AI available to everyone and are easy to use. So easy anyone can use it whether you are a programmer or not." />
    <meta name="keywords" content="software, ai, developer, zander, lewis, zanderlewis, wolfthedev, wolf, the, dev" />
    <meta name="author" content="Zander Lewis" />
    <meta property="og:title" content="Zander Lewis" />
    <meta property="og:description" content="Software/AI developer. I make software and AI available to everyone and are easy to use. So easy anyone can use it whether you are a programmer or not." />
    <meta property="og:url" content="https://zanderlewis.dev" />
    <meta property="og:type" content="website" />
    <meta property="og:site_name" content="Zander Lewis" />
    <meta property="og:locale" content="en_US" />
    <!-- Styles -->
    <link rel="stylesheet" href="css/body.css" />
    <link rel="stylesheet" href="css/text.css" />
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.0.2/dist/tailwind.min.css" rel="stylesheet">
    <!-- Scripts -->
    <script src="js/bg.js"></script>
    <script src="js/tidbits.js"></script>
</head>

<body class="center text-white">
    <div class="navbar text-white top-0 z-10 bg-gray-800 p-5 mb-10">
        <nav class="flex justify-center space-x-5">
            <a href="#projects" class="text-white">Projects</a>
            <a href="#contact" class="text-white">Contact</a>
        </nav>
    </div>

<button onclick="document.getElementById('background-music').play()">Play Music</button>
    <div class="stars" id="stars"></div>
    <div class="content text-white">
        <h1 class="text-7xl pb-1 mask-1">Zander Lewis</h1>
        <div class="bio mt-5 text-white">
            <h2 class="text-3xl pb-2">About Me</h2>
            <p>Hello! I'm Zander Lewis, a <span id="age"></span> y/o software/web/ai developer.</p>
        </div>
    </div>
    <div class="projects max-w-screen-md mx-auto" id="projects">
        <h2 class="text-3xl p-5">Projects</h2>
        <?php foreach ($projects as $project) : ?>
            <div class="project bg-gray-800 mb-5 p-5 rounded-lg">
                <a href="<?= $project['link'] ?>" class="text-white">
                    <h3 class="text-2xl pb-1"><?= $project['name'] ?></h3>
                    <h4 class="text-xl pb-1">Owner: <?= $project['owner'] ?></h4>
                    <p><?= $project['description'] ?></p>
                </a>
            </div>
        <?php endforeach; ?>
    </div>
    <div class="contact text-white" id="contact">
        <h2 class="text-3xl p-5">Contact</h2>
        <p>Email: <a href="mailto:zander@zanderlewis.dev" class="text-blue-500">zander@zanderlewis.dev</a></p>
        <p>Discord: <span class="text-blue-500">zanderlewis</span></p>
        <p>GitHub: <a href="https://github.com/zanderlewis" class="text-blue-500">zanderlewis</a></p>
    </div>
    <footer class="pb-10"></footer>
</body>

</html>
