# Branching, Tagging & Release Workflow

## Branching Strategy

- **`main`**: Represents the current default stable development branch.
- **`8.x` / `[0-9].*`**: Major/minor version branches (e.g., `8.5`, `8.4`).
- **`feature/*` or `fix/*`**: Short-lived branches created from `main` or a version branch, merged via Pull Request.

---

## Direct Commits & Branch Protections

- Direct pushes to `main` and `[0-9].*` version branches are **blocked** by GitHub Rulesets.
- All changes must go through a **Pull Request**.
- PRs require the `Build, Test & Publish Pipeline` status check to pass before merging.

---

## Tagging & Release Strategy

Releases and Docker image pushes are triggered exclusively by published GitHub Releases.

### 1. Tag Naming Format
Release tags must mirror the target PHP version followed by the version tag:
```text
<PHP_VERSION>-v<SEMVER>

```

*Example:* `8.5-v1.0.0`

### 2. Release Steps

1. Navigate to **Releases** -> **Draft a new release**.
2. Create a tag following the `<PHP_VERSION>-v<SEMVER>` format (e.g., `8.5-v1.0.0`).
3. Select the corresponding target branch (`main` or version branch like `8.5`).
4. Publish the release.

### 3. Docker Tagging Matrix

When a release is published, the pipeline automatically builds and pushes the following tags to Docker Hub:

| Target Branch | GitHub Release Tag | Docker Hub Tags Pushed |
| --- | --- | --- |
| **`main` (default)** | `8.5-v1.0.0` | `repo:8.5-v1.0.0`, `repo:8.5`, `repo:latest` |
| **Version branch** (`8.4`) | `8.4-v1.0.0` | `repo:8.4-v1.0.0`, `repo:8.4` |
