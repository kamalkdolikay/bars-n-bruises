# Git Commit Message Standards for Bars n Bruises

This document defines the Git commit message format for **Bars n Bruises**, a 2D beat 'em up game built in Godot 4.4. Following the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) standard, it ensures a clear, consistent, and maintainable version control history.

## Commit Message Format
Each commit message should follow this structure:
```
<type>(<scope>): <short description>
<BLANK LINE>
<optional detailed description>
```

- **type**: A prefix indicating the nature of the change.
- **scope**: The module, feature, or area of the project affected (e.g., `player`, `enemy`, `combat`, `ui`).
- **Short Description**: A concise summary (50 characters or less, imperative mood, capitalized, no period).
- **detailed description** (optional): Additional context, reasoning, or details (wrap at 72 characters).

### Commit Types

- **feat**: A new feature or addition (e.g., adding a new game mechanic).
  - Example: `feat(player): add punch attack mechanic`
- **fix**: A bug fix or correction.
  - Example: `fix(enemy): resolve collision detection issue`
- **update**: An enhancement or improvement to existing functionality without introducing new features or fixing bugs.
  - Example: `update(combat): increase player punch damage`
- **refactor**: Code restructuring without changing external behavior (e.g., improving code readability or performance).
  - Example: `refactor(player): optimize movement logic`
- **docs**: Documentation-only changes (e.g., updating README or comments).
  - Example: `docs(readme): add project setup instructions`
- **test**: Adding or modifying tests.
  - Example: `test(combat): add unit tests for damage system`
- **chore**: Maintenance tasks (e.g., updating dependencies, build scripts).
  - Example: `chore(build): update SCons configuration`
- **style**: Code style or formatting changes (e.g., fixing whitespace, linting).
  - Example: `style(player): format GDScript to follow style guide`

## Guidelines
1. **Use Imperative Mood**: Write descriptions as commands (e.g., "Add punch attack" instead of "Added punch attack").
2. **Capitalize First Letter**: Start the short description with a capital letter.
3. **No Period at End**: Omit periods at the end of the short description.
4. **Specific Scopes**: Use precise scopes from the folder structure (e.g., `player-movement`, not `player`) to avoid magic strings.
5. **Keep It Concise**: Short description should be 50 characters or less; use the detailed description for elaboration.
6. **Reference Issues**: If applicable, include issue numbers (e.g., `Closes #123` in the detailed description).
7. **Single Concern**: Each commit should address one logical change.

## Examples
- **New feature**:
  ```
  feat(player): add basic melee combat system

  Implemented punch attack for the player, triggered by Space key,
  with a configurable damage value. Added Area2D for hit detection.
  ```
- **Bug fix**:
  ```
  fix(enemy): correct health not updating on damage

  Fixed issue where enemy health was not decreasing when hit by
  player punch. Added debug logging to track health changes.
  Closes #42
  ```
- **Update**:
  ```
  update(combat): adjust player speed to 450

  Increased player movement speed from 400 to 450 for better
  gameplay feel based on playtesting feedback.
  ```
- **Refactor**:
  ```
  refactor(player): simplify velocity calculation

  Rewrote movement logic to reduce redundant calculations and
  improve readability without altering functionality.
  ```
- **Documentation**:
  ```
  docs(readme): add combat system overview

  Updated README with details on the melee combat system and
  instructions for testing player and enemy interactions.
  ```

## Git Workflow Integration

- **Feature Branches**: Create branches matching the commit type and scope (e.g., `git checkout -b player-combat`).
- **Frequent Commits**: Commit after completing a logical unit of work:
  ```bash
  git add .
  git commit -m "feat(<scope>): <description>"
  git push origin <branch>
  ```
- **Pull Requests**: Submit pull requests to `main` for review, ensuring commits follow this standard (see [GitWorkflow.md](GitWorkflow.md)).
- **Main Branch**: Keep `main` stable with production-ready code.