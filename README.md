# Cats, Cables & Containers

A Hugo blog about security, infrastructure, and the kind of homelab tinkering that usually starts with "this should be quick" and ends with me reading logs at 2 AM.

I have worked in both IT and cybersecurity, and I use this blog as a public notebook for the things I learn while building and maintaining my lab. Expect practical notes, small write-ups, and occasional post-mortems when something breaks in an interesting way.

## What you will find here

- Linux and self-hosting notes
- Docker and Docker Compose projects
- Networking experiments (routing, nftables, dnsmasq, Tailscale, WireGuard, and others)
- Monitoring and security tooling (what is useful and what is noise)
- Short fixes and longer deep dives, depending on how painful the problem was
- Cheatsheets!!!
- Small notes about specific commands or programs (yes Git, I am looking at you)

## Writing style

This is not meant to be perfect documentation or a polished tutorial. I prefer my work to be:

- Clear about the goal
- Honest about the mistakes
- Easy to reproduce
- Focused on what worked for me and why
- Actually useful, like notes for my future self (and hopefully for others too)

## Repo structure (high level)

- `content/` contains posts and pages (Markdown)
- `static/` contains static assets (favicons, images, etc.)
- `layouts/` contains template overrides (if/when needed)
- `hugo.toml` or `config.toml` contains site configuration
- `public/` contains generated output (build artifact)

## Stack

- Hugo (static site generator)
- Markdown (written in VS Code)
- Nginx (serving `public/`)
- Cloudflare Tunnel (public access without opening inbound ports)

## Local development

Preview with drafts:
```bash
hugo server -D
```

## Create a post (page bundle)

```bash
hugo new content/posts/my-post/index.md
```

Put images next to `index.md` and reference them like:
```md
![](image.png)
```

## Build

```bash
hugo
```

Output is generated into `public/`.

## Deploy (example)

Build locally and sync to the server:
```bash
hugo
rsync -av --delete public/ user@your-vm:/opt/blog/public/
```

## License

Code in this repository is licensed under the MIT License.

Blog posts and original written content are licensed under
Creative Commons Attribution 4.0 International (CC BY 4.0), unless noted otherwise.
https://creativecommons.org/licenses/by/4.0/