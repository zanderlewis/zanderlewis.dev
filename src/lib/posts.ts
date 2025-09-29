// Helper utilities for blog posts using a literal import.meta.glob (required by Vite/Astro)
// Centralizes content loading so pages can call `getAllPosts()` instead of repeating globs.

export type PostModule = {
  frontmatter: Record<string, any>;
  default: any;
  filePath?: string;
};

// NOTE: the glob pattern must be a string literal here. Keep it relative to this file.
const modules = import.meta.glob('../pages/blog/content/*.md', { eager: true }) as Record<string, PostModule>;

function basenameFromPath(filePath = ''): string {
  // Convert a path like '../pages/blog/content/my-post.md' to 'my-post'
  return String(filePath).replace(/^.*\/([^\/]+)$/, '$1').replace(/\.(md|mdx|markdown)$/i, '');
}

export function getAllPosts(): Array<PostModule & { filePath: string }> {
  return Object.entries(modules).map(([filePath, mod]) => ({ ...mod, filePath }));
}

export function getAllSlugs(): string[] {
  const slugs = getAllPosts().map(p => String(p.frontmatter?.slug ?? basenameFromPath(p.filePath)));
  // ensure uniqueness and stable order
  return Array.from(new Set(slugs));
}

export function getPostBySlug(slug: string) {
  const normalized = String(slug);
  return getAllPosts().find(p => {
    const fmSlug = p.frontmatter?.slug ? String(p.frontmatter.slug) : '';
    const fileSlug = basenameFromPath(p.filePath);
    return fmSlug === normalized || fileSlug === normalized;
  });
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
