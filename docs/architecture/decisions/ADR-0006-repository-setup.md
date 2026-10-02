---
status: Accepted
date: 2026-10-02
supersedes:
superseded-by:
---

# ADR-0006: Set up the git repository and scaffold on a work branch

## Context
A scaffolded repo isn't ready to work in if its branching strategy exists only as prose: a new repo has no long-lived branches, and a machine without a global git identity can't commit. Scaffolding writes many files, and the workflow says changes reach the integration branch through work branches. A branch can't exist, or be pushed, without a commit.

## Decision
Before anything is written, the skill makes the repository match the git workflow, asking before each change.

- **New repo:** initialize it; set `user.name`/`user.email` for the repo only when no scope sets them; commit an empty `.gitignore` to the default branch; create the integration branch and commit the project `.gitignore` there — the chosen stacks' `github/gitignore` templates plus the JetBrains rules, which ignore per-user IDE files and keep shared ones such as project dictionaries.
- **Existing repo:** create or track missing long-lived branches.
- **Every run that writes:** first create a work branch from the integration branch, named by the workflow's pattern, asking for a ticket when the pattern needs one. At the end, offer one commit of the scaffold on that branch.

It only adds: never renames, deletes, resets, forces or pushes, and never adds a remote. The report gives the push commands and the pull request to open.

## Consequences
Scaffolding arrives through the same pull request flow as any other change. The skill makes at most three commits: the empty `.gitignore`, the project `.gitignore`, and the scaffold. Global git config is never touched. When it can't ask, it changes nothing in git and won't write to a long-lived branch.

## Alternatives considered
Writing on whatever branch is checked out — scaffolding would land on `main` or `dev` directly. A single initial commit with everything — it bypasses the work-branch and pull request flow. `dotnet new gitignore` — Visual Studio-oriented, and it refuses to run once a `.gitignore` exists.
