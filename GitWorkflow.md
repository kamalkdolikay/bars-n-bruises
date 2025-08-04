## Git Workflow for Bars n Bruises

This document outlines the Git workflow for the **Bars n Bruises** project, a 2D beat 'em up game built in Godot 4.4. The workflow ensures a clean, collaborative, and scalable development process by using feature branches to keep the `main` branch stable and production-ready.

### Branch Naming Convention

Branches follow the format: `<scope>-<feature-or-task>`

- **Type**: Indicates the nature of the change, matching the commit message standard:
  - `feat`: New feature
  - `fix`: Bug fix
  - `update`: Enhancement to existing functionality
  - `refactor`: Code restructuring without behavioral changes
  - `docs`: Documentation updates
  - `test`: Adding or modifying tests
  - `chore`: Maintenance tasks (e.g., build setup)
  - `style`: Code style or formatting changes
- **Scope**: The game component or system affected (e.g., `player`, `enemy`, `ui`)
- **Feature-or-Task**: A concise description of the work (e.g., `movement`, `punch-attack`)

**Examples**:
- `player-movement`: Implement player walking and jumping.
- `ui-health-bar`: Implement health bar display.

## Branching Guidelines

- **Feature Branches**: Create a branch for significant features, fixes, or refactors from main branch:
  ```bash
  git checkout -b player-movement
  ```
- **Group Related Work**: Combine related changes (e.g., player movement and animation) into a single branch (e.g., `player-movement`) unless they warrant separate branches.
- **Direct Commits to `main`**: Minor changes (e.g., typo fixes, documentation) can be committed directly to `main` with `docs`, `style`, or `update` types.
- **Merge Strategy**: Follow the following steps when merging to `main`:
  ```bash
  git checkout main
  git merge player-movement
  git push origin main
  ```
- **Rebasing for Small Fixes**: For minor fixes, rebase onto `main` to keep a linear history:
  ```bash
  git checkout ui-health-bar
  git rebase main
  git checkout main
  git merge ui-health-bar
  ```
- **Push Regularly**: Back up branches to the remote repository:
  ```bash
  git push origin player-movement
  ```

## Pull Requests

- **Create Pull Requests**: For collaborative development, submit pull requests to `main` via GitHub or similar platforms.
- **Review Process**: Ensure pull requests include a clear description, reference relevant issues, and pass any automated checks (e.g., linting, tests).
- **Squash or Merge**: Use `--no-ff` merges for feature branches; squash commits for small fixes to maintain a clean history.

## Branch Categories

Branches are organized by game systems, aligned with the project's folder structure (see [FolderStructure.md](FolderStructure.md)).

### Player
- **Scope**: `player-movement`, `player-combat`, `player-health`, `player-animation`
- **Examples**:
  - `player-combat`: Add punch and combo mechanics.
  - `player-movement`: Resolve jump height inconsistencies.

### Enemy
- **Scope**: `enemy-ai`, `enemy-combat`, `enemy-health`, `enemy-animation`
- **Examples**:
  - `enemy-ai`: Implement patrol and chase behaviors.
  - `enemy-health`: Fix health not updating on hit.

### Stage
- **Scope**: `stage-layout`, `stage-environment`
- **Examples**:
  - `stage-layout`: Design prison yard level.
  - `stage-environment`: Correct collision issues.

### Props
- **Scope**: `props-interactable`, `props-decorative`
- **Examples**:
  - `feat/props-interactable`: Add destructible barrels.
  - `update/props-decorative`: Enhance background visuals.

### Collectables
- **Scope**: `collectables-food`, `collectables-weapons`
- **Examples**:
  - `collectables-food`: Implement health pickups.
  - `collectables-weapons`: Fix weapon equip animation.

### UI
- **Scope**: `ui-hud`, `ui-menu`
- **Examples**:
  - `ui-hud`: Add combo counter to HUD.
  - `ui-menu`: Resolve pause menu navigation.

### Audio
- **Scope**: `audio-sfx`, `audio-music`
- **Examples**:
  - `audio-sfx`: Add punch sound effects.
  - `audio-music`: Adjust background track volume.

### Game Systems
- **Scope**: `systems-progression`, `systems-save`
- **Examples**:
  - `systems-progression`: Implement scoring system.
  - `systems-save`: Correct save file corruption.

### Additional Branches
- `chore/project-setup`: Configure Godot project or C++ integration.
- `docs/readme`: Update project documentation.
- `test/player-combat`: Add unit tests for combat mechanics.
- `style/code-format`: Apply GDScript style guidelines.

## Adding or Removing Categories

To add a new category (e.g., `network` for multiplayer):
1. Update this document with the new category and example branches.
2. Commit the change:
   ```bash
   git add GitWorkflow.md
   git commit -m "docs(git-workflow): add network category"
   ```

To remove a category, update this document and commit similarly.