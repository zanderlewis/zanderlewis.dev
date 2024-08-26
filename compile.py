import requests
import json

def load_config():
    config = {}
    with open('portfolio.cfg', 'r') as file:
        for line in file:
            key, value = line.strip().split('=')
            config[key.strip()] = value.strip()
    return config

def fetch_github_profile(username):
    response = requests.get(f'https://api.github.com/users/{username}')
    return response.json()

def fetch_github_repos(username, repo_limit, include_forks):
    response = requests.get(f'https://api.github.com/users/{username}/repos')
    repos = response.json()
    return [repo for repo in repos if include_forks or not repo['fork']][:repo_limit]

def generate_static_html(config, profile, repos):
    with open('template.html', 'r') as file:
        html_content = file.read()

    # Update profile section
    html_content = html_content.replace('src=""', f'src="{profile["avatar_url"]}"')
    html_content = html_content.replace('The Octocat', profile['name'])
    html_content = html_content.replace('[ octocat ]', f'[ {profile["login"]} ]')
    html_content = html_content.replace('<!-- Bio will be inserted here -->', profile['bio'] or '')

    # Update profile link
    profile_link_html = f'<a href="{profile["html_url"]}" target="_blank" class="text-blue-400 hover:text-blue-300">View GitHub Profile</a>'
    html_content = html_content.replace('<!-- Github link will be inserted here -->', profile_link_html)

    # Update projects section
    projects_html = ''
    for repo in repos:
        projects_html += f'''
        <div class="bg-gray-800 p-4 rounded-lg shadow-md hover:bg-gray-700 transition fade-in">
            <h3 class="text-xl font-semibold">{repo["name"]}</h3>
            <p class="text-gray-400">{repo["description"] or "No description available."}</p>
            <a href="{repo["html_url"]}" target="_blank" class="text-blue-400 hover:text-blue-300">View on GitHub</a>
        </div>
        '''
    html_content = html_content.replace('<!-- GitHub projects will be inserted here -->', projects_html)

    # Save the updated HTML content to a new file
    with open('index.html', 'w') as file:
        file.write(html_content)

if __name__ == "__main__":
    config = load_config()
    profile = fetch_github_profile(config['username'])
    repos = fetch_github_repos(config['username'], int(config['repoLimit']), config['includeForks'].lower() == 'true')
    generate_static_html(config, profile, repos)