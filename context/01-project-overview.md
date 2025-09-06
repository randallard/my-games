# Game Platform Project Overview

## Vision
A platform for hosting custom turn-based games where users submit structured game rules (TypeScript functions) and invite friends to play in real-time. Each deployment is self-hosted - the creator builds the platform architecture as open source, and others deploy their own instances with their own games.

## Core Features
- **Game Rules**: Users define games via TypeScript functions (game logic, validation, win conditions)
- **Real-time Gameplay**: Players see moves instantly via Server-Sent Events (SSE)
- **Stateless Design**: All data stored in browser (no database, no user accounts)
- **Backup System**: Email-based game state backups for recovery
- **Friend-to-Friend**: Generate shareable links to invite friends to games

## Technology Stack

### Frontend
- **Platform**: GitHub Pages (static hosting)
- **Framework**: Vanilla TypeScript (no framework)
- **Storage**: Browser localStorage only
- **Data**: Player ID, friend lists, game stats per friend

### Backend
- **Language**: Rust
- **Framework**: Axum (following Jeremy Chone patterns)
- **Platform**: Google Cloud Platform (GCP)
- **Deployment**: Cloud Run (containerized microservices)
- **Database**: None (stateless design)

### Communication
- **API**: REST APIs between frontend and backend
- **Real-time**: Server-Sent Events (SSE) for move updates
- **Backup**: Email delivery for game state files

## Game Rules Structure
Games defined via TypeScript functions:

```typescript
// Core game interface
interface GameRules {
  initializeGame(): GameState;
  isValidMove(gameState: GameState, playerId: string, move: Move): boolean;
  applyMove(gameState: GameState, playerId: string, move: Move): GameState;
  checkGameEnd(gameState: GameState): GameResult;
  getGameDisplay(gameState: GameState, playerId: string): DisplayState;
}

// Flexible JSON state - completely customizable per game
type GameState = any;
type Move = any;
```

## Deployment Architecture
- **Open Source**: Platform code available for others to deploy
- **Self-Hosted**: Each instance runs independently
- **Creator Deployment**: Initial creator hosts their own games
- **Community Deployments**: Others fork and deploy with their own games