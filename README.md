# My Games Platform

A platform for creating and playing custom turn-based games with friends. Define game rules once, play anywhere with real-time updates and seamless friend-to-friend gameplay.

## 🎮 What We're Building

**Vision**: Create a platform where you can submit structured game rules (TypeScript functions) and instantly invite friends to play those games in real-time. No databases, no user accounts, just pure gaming fun.

**Key Features**:
- 🎯 **Custom Game Logic**: Define any turn-based game with TypeScript functions
- ⚡ **Real-time Gameplay**: See moves instantly via Server-Sent Events
- 🔄 **Stateless Design**: Everything stored in browser - no databases needed
- 📧 **Email Backups**: Never lose a game with automatic email backup system
- 🔗 **Friend-to-Friend**: Generate shareable links to invite anyone to play
- 🚀 **Self-Hosted**: Deploy your own instance with your own games

## 🏗️ Architecture Overview

### Frontend (GitHub Pages)
- **Vanilla TypeScript** - No framework complexity
- **Browser Storage** - Player data, game stats, active games
- **Real-time UI** - SSE for instant move updates

### Backend (Google Cloud Platform)
- **Rust + Axum** - Following [Jeremy Chone's production patterns](https://github.com/jeremychone-channel/rust-axum-course)
- **Microservices** - 4 focused services for maximum reusability
- **Cloud Run** - Serverless, auto-scaling containers
- **Zero Database** - Completely stateless design

### Microservices Breakdown

1. **Game Engine Service** - Execute game logic, validate moves, manage state
2. **Real-time Service** - Handle SSE connections, broadcast updates
3. **Game Registry Service** - Create games, generate links, match players
4. **Backup Service** - Email game states, handle recovery

## 🎲 Game Rules Interface

Games are defined via TypeScript functions:

```typescript
interface GameRules {
  initializeGame(): GameState;
  isValidMove(gameState: GameState, playerId: string, move: Move): boolean;
  applyMove(gameState: GameState, playerId: string, move: Move): GameState;
  checkGameEnd(gameState: GameState): GameResult;
  getGameDisplay(gameState: GameState, playerId: string): DisplayState;
}

// Example: Tic-Tac-Toe
const ticTacToeRules: GameRules = {
  initializeGame: () => ({ 
    board: Array(9).fill(null), 
    currentPlayer: 'X' 
  }),
  
  isValidMove: (state, playerId, move) => 
    state.board[move.position] === null,
    
  applyMove: (state, playerId, move) => ({
    ...state,
    board: state.board.map((cell, i) => 
      i === move.position ? state.currentPlayer : cell
    ),
    currentPlayer: state.currentPlayer === 'X' ? 'O' : 'X'
  }),
  
  checkGameEnd: (state) => {
    // Win condition logic...
    return { gameOver: false, winner: null };
  },
  
  getGameDisplay: (state, playerId) => ({
    board: state.board,
    isMyTurn: state.currentPlayer === getPlayerSymbol(playerId)
  })
};
```

## 🚀 Getting Started

### For Players
1. Visit the platform (when deployed to GitHub Pages)
2. Select a game type
3. Generate a shareable link
4. Send link to a friend
5. Play in real-time!

### For Developers
1. Clone this repository
2. Check the `context/` folder for detailed documentation
3. Follow Jeremy Chone's Rust patterns for consistent code style
4. Deploy services to Google Cloud Run
5. Host frontend on GitHub Pages

## 📚 Documentation

All project context and decisions are documented in the `context/` folder:

- **[Project Overview](context/01-project-overview.md)** - Vision, features, tech stack
- **[Microservices Architecture](context/02-microservices-architecture.md)** - Service breakdown, API design, Jeremy Chone patterns
- **[Game Flow Design](context/03-game-flow-design.md)** - Player experience, real-time updates, backup system
- **[Technical Decisions](context/04-technical-decisions.md)** - Why we chose each technology and pattern

## 🛠️ Technology Stack

### Why These Choices?

**Rust + Axum**: Performance, safety, and excellent async support for SSE
**Google Cloud Run**: Serverless simplicity with auto-scaling
**GitHub Pages**: Free, fast, global CDN for static frontend
**No Database**: Eliminates complexity, reduces costs, improves privacy
**TypeScript Game Rules**: Familiar to developers, type-safe, flexible

### Development Workflow
Following Jeremy Chone's proven patterns:

```bash
# Hot reload development
cargo watch -q -c -w src/ -x "run"

# Quick endpoint testing
cargo run --example quick_dev

# Service structure
src/
├── web/     # Routes, middleware
├── model/   # Data models
├── ctx/     # Request context
├── error/   # Error handling
└── utils/   # Utilities
```

## 🎯 What Makes This Special

1. **Zero Infrastructure Complexity**: No databases, no user accounts, no complex setup
2. **Infinite Game Possibilities**: Any turn-based game can be implemented
3. **True Real-time Experience**: SSE provides instant updates without polling overhead
4. **Privacy-First**: All data stays in players' browsers
5. **Community Driven**: Open source, self-hosted, forkable
6. **Production Ready**: Following proven Rust/Axum patterns from day one

## 🚧 Current Status

**Phase 1**: Architecture design and documentation ✅  
**Phase 2**: Core service implementation (in progress)  
**Phase 3**: Frontend development  
**Phase 4**: GCP deployment setup  
**Phase 5**: First game implementation (Tic-Tac-Toe)  

## 🤝 Contributing

This project follows Jeremy Chone's Rust production patterns. Key principles:

- **Clean Error Handling**: Custom `Result<T>` types with `thiserror`
- **Modular Structure**: Clear separation of web, model, context, and error layers
- **Context Pattern**: Request context flows through all operations
- **Resource-Based APIs**: RESTful design with predictable endpoints
- **Development First**: `cargo watch` + `quick_dev.rs` for fast iteration

## 📄 License

[Apache 2.0](LICENSE) - Same as Jeremy Chone's patterns we're following

## 🙏 Acknowledgments

- **[Jeremy Chone](https://github.com/jeremychone-channel)** - For the excellent Rust/Axum production patterns
- **Rust Community** - For making systems programming accessible and safe
- **Axum Team** - For a fantastic async web framework

---

*Building games should be fun. Playing them should be instant. Sharing them should be effortless.*