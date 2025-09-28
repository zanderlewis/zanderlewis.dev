// Helper utilities for blog posts using a literal import.meta.glob (required by Vite/Astro)
// Centralizes content loading so pages can call `getAllPosts()` instead of repeating globs.

type PostModule = {
  frontmatter: Record<string, any>;
  default: any;
};

// NOTE: the glob pattern must be a string literal here. Keep it relative to this file.
const modules = import.meta.glob('../pages/blog/content/*.md', { eager: true }) as Record<string, PostModule>;

export function getAllPosts(): Array<PostModule & { filePath: string }> {
  return Object.entries(modules).map(([filePath, mod]) => ({ ...mod, filePath }));
}

export function getAllSlugs(): string[] {
  return getAllPosts().map(p => String(p.frontmatter?.slug ?? p.filePath));
}

export function getPostBySlug(slug: string) {
  return getAllPosts().find(p => String(p.frontmatter?.slug) === slug);
}

export function getAllTags(): Record<string, number> {
  const map: Record<string, number> = {};
  getAllPosts().forEach(p => {
    const tags = p.frontmatter?.tags ?? [];
    for (const t of tags) {
      const key = String(t);
      map[key] = (map[key] || 0) + 1;
    }
  });
  return map;
}

