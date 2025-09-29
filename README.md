# Website
This is the source code for my personal website, [zanderlewis.dev](https://zanderlewis.dev). It is built using [Astro](https://astro.build/) and is designed to be a simple, fast, and easy-to-maintain site.

# Features
- **Blog**: Articles and updates at `/blog`, written in Markdown with frontmatter.
- **Education**: Lists my educational background and ongoing learning.
- **Skills**: Outlines my key skills in web development and software development.
- **Programming Languages**: Displays the programming languages I use.
- **Languages**: Lists the languages I speak.
- **Portfolio**: Showcases my projects and achievements.
- **Achievements**: Highlights my accomplishments and skills.
- **Learning**: Shows the technologies and tools I'm currently learning.
- **Social Links**: Connects to my social media profiles.

# Running the Project
To run this project locally, you can run `pnpm run dev` or `npm run dev` in the project directory. This will start a local development server where you can view the site.

# Blogging
- Posts live in `src/pages/blog/content` as Markdown files (`.md`).
- Each post should include frontmatter:

```md
---
title: "Post title"
pubDate: 2025-09-28
description: "Short description"
tags: [tag1, tag2]
---

Your content here.
```

- There is also an optional `editedDate` variable to indicate when the post was last edited at.
- The blog index is at `/blog` and lists posts by `pubDate` (newest first).
- By clicking on a post's tag, it will bring you to another page with all the posts of that tag.
