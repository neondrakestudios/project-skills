# Git workflow interview

Produces the `{{git_workflow}}` slot: three short paragraphs covering the base branch, tickets and branch names, and what to check before editing.

## Infer first

Gather before asking, and offer each inferred value as the first option, marked "(Recommended)":

- Default branch, and whether `dev` or `develop` exists: `git branch -r`, `git ls-remote --heads origin`.
- Branch names in use: `git branch -r` and `gh pr list --state all --limit 50 --json headRefName,baseRefName`. Look for a type prefix (`feature/`, `fix/`…), a ticket key (`ABC-123`), and which base PRs target.
- Tracker: a Linear or Jira key pattern in branch names or PR titles, `.github/ISSUE_TEMPLATE/`, links in the README.

A value with unambiguous evidence — every PR targets `dev`, every branch is `feature/ABC-123-…` — is not asked; state it in the report as inferred.

## Ask

Use AskUserQuestion, at most four questions per call; split a round across calls when it has more. Skip any question already answered by evidence or by an earlier answer.

Round 1:

1. **Integration branch** — the base for new work: the default branch, `dev`, `develop`, or other.
2. **Tracker** — Linear, GitHub Issues, Jira, or none.
3. **Direct commits to the integration branch** — never (PR only), or allowed for trivial changes.

Round 2, only what round 1 made relevant:

- **Branch names** — show each as a preview with an example, offering only patterns that fit the tracker answer: with no tracker, only `TYPE/short-description`-style patterns; with a tracker:
  - `TYPE/KEY-123-short-description`
  - `KEY-123-short-description`
  - the name the tracker generates (Linear's "Copy git branch name")
- **Ticket key** — the team or project prefix, e.g. `SR`. Offer prefixes seen in branches or PRs.
- **Branch types** — `feature / bugfix / improvement`, `feat / fix / chore`, or other.
- **Relation to the release branch**, when the integration branch is not the default branch — PRs never target the default branch and the integration branch is refreshed from it; or release PRs merge the integration branch into it.
- **Stacked work** — may a work branch be based on another work branch?
- **Every change needs a ticket?** — yes, or trivial changes exempt.

When you cannot ask, write what the evidence supports and a `TODO:` line for each open question, and list them in the report.

## Write

Write plain, imperative prose in this order — no headings, no options that weren't chosen:

1. Which branch is the base for new work, which branch PRs never target, and whether direct commits to it are allowed.
2. The ticket requirement, the branch pattern with its allowed types, and one realistic example using the real key (`feature/SR-142-usage-upload-crash`). With Linear, add that the issue ID must appear in the branch name so Linear links the PR. State whether dependent work may branch from another work branch.
3. Before editing: check the current branch and ticket. From the integration branch, create or switch to the ticket branch. On a different ticket's branch, stop and ask which branch to use.

Example of the finished section, for a Linear project with a `dev` integration branch:

> `dev` is the integration branch and the base for new work; it is periodically updated from `main`. Never target `main`, and never commit directly to `dev`.
>
> Every change needs a Linear issue and a branch named `feature/<issue-id>-<short-description>`, `bugfix/<issue-id>-<short-description>` or `improvement/<issue-id>-<short-description>` — for example `bugfix/SR-142-usage-upload-crash`. The issue ID must appear in the branch name so Linear links the PR. Dependent work may branch from another work branch.
>
> Before editing, check the current branch and issue. From `dev`, create or switch to the issue branch. If already on a different issue's branch, stop and ask which branch to use.
