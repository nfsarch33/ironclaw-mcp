# Changelog

All notable changes to `ironclaw-mcp` are recorded in this file. The format
follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this
project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned

- v1.0.0 release: dedicated CLI binary, not just an MCP server.
  - `ironclaw-mcp serve` (current behaviour, default)
  - `ironclaw-mcp doctor` (config + IronClaw connectivity probes)
  - `ironclaw-mcp tools list|describe|invoke`
  - `ironclaw-mcp smoke` (replaces `scripts/smoke-test.sh`)
- Push `internal/tools` and `internal/ironclaw` test coverage to >= 80 %
  using the existing `httptest.NewServer` mock harness.
- Add `cmd/ironclaw-mcp` integration tests covering CLI flag parsing,
  graceful shutdown, and SSE transport setup.

## [0.4.0] - 2026-04-30

### Removed (BREAKING)

- All `ironclaw_research_*` MCP tools (`scrape`, `pdf`, `search`, `store`,
  `pipeline`, `transcript`, `extract`, `crawl`, `deakin`, `assessments`).
  These wrapped an external `research-agent` CLI and are not part of the
  IronClaw HTTP bridge surface.
- All `ironclaw_ui_*` MCP tools (`navigate`, `discover`, `heal`, `verify`).
- All `ironclaw_evolver_*` MCP tools (`status`, `propose`, `validate`,
  `promote`).
- Internal source files: `internal/tools/research.go`,
  `internal/tools/research_test.go`, `internal/tools/uiauto.go`,
  `internal/tools/uiauto_test.go`, `internal/tools/evolver.go`,
  `internal/tools/evolver_test.go`. Approx. 2 629 lines of Go removed.

### Migration

Consumers that relied on the removed surfaces should call the equivalent
`research-agent` CLI directly or via the workflows in
`agentic-ai-research`. `ironclaw-mcp` no longer attempts to wrap that
binary.

### Changed

- `internal/server/server.go` no longer registers research, UI-auto, or
  evolver handlers. Base tool count is now **14** (15 with
  `PROMETHEUS_URL`).
- `internal/server/server_test.go` updated with new tool-count
  expectations and the v1.0 baseline comment.
- `README.md` documents the cleanup, the v1.0 direction, and the new
  per-config tool counts.

### Evidence

- Pre-cleanup file snapshots archived in
  `~/Code/global-kb/session-handoffs/evidence/v257-w2-d0-ironclaw-mcp-cleanup/before/`.
- All packages green:
  - `internal/config`: 89.4 %
  - `internal/server`: 94.1 %
  - `internal/tools`: 74.7 %
  - `internal/ironclaw`: 61.9 %
  - `cmd/ironclaw-mcp`: 0.0 % (entry point, no tests yet)
  - **Total: 73.1 %** (target: >= 80 % in next sprint).

## [0.3.0] - 2026-04-21

### Added

- `ironclaw_reviewed_push` tool: runs Gemini diff review and pushes only
  when no must-fix issues remain.
- Sprint-65 dual-ops, Sprint-68 ops, Sprint-69 extended ops surfaces
  (CEO-tier CLI integrations).
- Prometheus metrics endpoint and `ironclaw_get_metrics` tool.
