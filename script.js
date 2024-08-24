document.addEventListener('DOMContentLoaded', async () => {
    const projectsList = document.getElementById('projects-list');
    const profilePhoto = document.getElementById('profile-photo');
    const profileName = document.getElementById('profile-name');
    const profileLinks = document.getElementById('profile-link');
    const profileBio = document.getElementById('profile-bio');
    const profileUsername = document.getElementById('profile-username');

    // Function to load and parse the configuration file
    async function loadConfig() {
        const response = await fetch('portfolio.cfg');
        const text = await response.text();
        const config = {};
        text.split('\n').forEach(line => {
            const [key, value] = line.split('=');
            config[key.trim()] = value.trim();
        });
        return config;
    }

    try {
        // Load configuration
        const config = await loadConfig();
        const username = config.username;
        const repoLimit = parseInt(config.repoLimit, 10);
        const daysLimit = parseInt(config.daysLimit, 10);
        const includeForks = config.includeForks === 'true';

        // Fetch user profile data
        let userResponse;
        try {
            userResponse = await fetch(`https://api.github.com/users/${username}`);
            if (!userResponse.ok) throw new Error('User not found');
        } catch (error) {
            userResponse = await fetch(`https://api.github.com/users/octocat`);
        }
        const userData = await userResponse.json();

        // Set profile photo, name, and username
        profilePhoto.src = userData.avatar_url;
        profileName.textContent = userData.name || 'GitHub User';
        profileUsername.textContent = `[ ${userData.login} ]`;

        // Set profile links
        const link = 'https://github.com/' + userData.login;
        profileLinks.innerHTML = `
            <a href="${link}" target="_blank" class="text-blue-400 hover:text-blue-300">View GitHub Profile</a>
        `;

        let bio = userData.bio;

        // Convert any URLs and mentions in the bio to clickable links
        if (bio) {
            bio = bio.replace(/(https?:\/\/[^\s]+)/g, '<a href="$1" target="_blank">$1</a>');
            bio = bio.replace(/@([a-zA-Z0-9_]+)/g, '<a href="https://github.com/$1" target="_blank">@$1</a>');
        }

        // Set profile bio
        profileBio.innerHTML = bio || 'No bio available.';

        // Fetch repositories data
        const reposResponse = await fetch(userData.repos_url);
        const repos = await reposResponse.json();

        // Filter repositories based on includeForks and pushed within the last 30 days
        const now = new Date();
        const recentRepos = repos.filter(repo => {
            const pushedDate = new Date(repo.pushed_at);
            const diffTime = Math.abs(now - pushedDate);
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
            return (includeForks || !repo.fork) && diffDays <= daysLimit;
        });

        // Sort repositories by most recently pushed
        recentRepos.sort((a, b) => new Date(b.pushed_at) - new Date(a.pushed_at));

        // Limit the number of repositories displayed
        recentRepos.slice(0, repoLimit).forEach((repo, index) => {
            setTimeout(() => {
                const repoCard = document.createElement('div');
                repoCard.className = 'bg-gray-800 p-4 rounded-lg shadow-md hover:bg-gray-700 transition fade-in';

                repoCard.innerHTML = `
                    <h3 class="text-xl font-semibold">${repo.name}</h3>
                    <p class="text-gray-400">${repo.description || 'No description available.'}</p>
                    <a href="${repo.html_url}" target="_blank" class="text-blue-400 hover:text-blue-300">View on GitHub</a>
                `;

                projectsList.appendChild(repoCard);
            }, index * 200); // Delay each card by 200ms
        });
    } catch (error) {
        console.error('Error fetching GitHub data:', error);
        projectsList.innerHTML = `<p class="text-gray-400">Failed to load projects.</p>`;
    }
});