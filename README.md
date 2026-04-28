# xen-skills

Senior Engineer skills: persona, philosophy, and (eventually) language-specific skills.

## Use these skills in every Cursor project

Skills must live under `~/.cursor/skills/<skill-name>/` (personal) or `.cursor/skills/` in a repo (project). To install **this** repo’s skills for **all** your projects, from the repo root run:

```bash
bash setup-skills.sh
```

That symlinks each top-level folder that contains a `SKILL.md` into `~/.cursor/skills/`. Use `bash setup-skills.sh --copy` for a full copy instead of symlinks, and `bash setup-skills.sh --force` to replace skills you already installed. On Windows, use **Git Bash** or **WSL**.

After installing, restart Cursor or open a new chat so skills are picked up.

If you previously installed the philosophy skill under the old folder name `xen-philisophy`, delete `~/.cursor/skills/xen-philisophy` so only `xen-philosophy` remains.
