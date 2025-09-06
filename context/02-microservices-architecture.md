# Microservices Architecture Design

## Service Breakdown

### 1. Game Engine Service (`game-engine-svc`)
**Purpose**: Core game logic execution and state management

**Responsibilities**:
- Execute TypeScript game rules safely
- Validate player moves according to game rules
- Maintain authoritative game state
- Determine game end conditions and winners

**API Endpoints**:
```
POST   /api/games/{game_id}/moves     # Submit a move
GET    /api/games/{game_id}/state     # Get current game state
GET    /api/games/{game_id}/valid-moves # Get valid moves for current player
```

**Models**:
- `Game` - game metadata and rules
- `GameState` - current game state (flexible JSON)
- `Move` - player move data
- `Player` - player information

### 2. Real-time Service (`realtime-svc`)
**Purpose**: Manage SSE connections and real-time move broadcasting

**Responsibilities**:
- Maintain SSE connections for active players
- Broadcast move updates to connected players
- Handle connection lifecycle (connect/disconnect)
- Route real-time events between players

**API Endpoints**:
```
GET    /api/games/{game_id}/events    # SSE endpoint for real-time updates
POST   /api/games/{game_id}/notify    # Internal: notify of game state changes
```

**Context Tracking**:
- Active SSE connections per game
- Player connection status
- Connection health monitoring

### 3. Game Registry Service (`registry-svc`)
**Purpose**: Game instance management and player matching

**Responsibilities**:
- Create new game instances
- Generate shareable game links
- Match players to games
- Store game metadata and rules
- Determine starting player randomly

**API Endpoints**:
```
POST   /api/games                     # Create new game instance
GET    /api/games/{game_id}           # Get game information
POST   /api/games/{game_id}/join      # Join existing game
GET    /api/games/{game_id}/link      # Generate shareable link
```

### 4. Backup Service (`backup-svc`)
**Purpose**: Game state backup and restoration via email

**Responsibilities**:
- Generate game state backup files
- Email backup files to players
- Process backup file restoration
- Handle backup file validation

**API Endpoints**:
```
POST   /api/games/{game_id}/backup    # Generate and email backup
POST   /api/restore                   # Restore from backup file
GET    /api/backup/{backup_id}        # Download backup file
```

## Jeremy Chone Patterns Applied

### Code Structure (per service)
```
src/
├── web/
│   ├── routes_games.rs      # Game-specific routes
│   ├── routes_common.rs     # Health, CORS, etc.
│   ├── mw_auth.rs          # Auth middleware
│   └── mw_res_map.rs       # Response mapping
├── model/
│   ├── game.rs             # Game models
│   ├── player.rs           # Player models
│   └── store.rs            # In-memory storage
├── ctx/
│   └── mod.rs              # Request context
├── error/
│   └── mod.rs              # Error handling
├── utils/
│   └── mod.rs              # Utilities
└── main.rs                 # Server setup
examples/
└── quick_dev.rs            # Development testing
```

### Error Handling Pattern
```rust
pub type Result<T> = core::result::Result<T, Error>;

#[derive(thiserror::Error, Debug)]
pub enum Error {
    #[error("Game not found")]
    GameNotFound,
    
    #[error("Invalid move: {0}")]
    InvalidMove(String),
    
    #[error("Player not in game")]
    PlayerNotInGame,
}
```

### Context Pattern
```rust
#[derive(Debug, Clone)]
pub struct Ctx {
    pub player_id: String,
    pub game_id: Option<String>,
}
```

### Development Workflow
- `cargo watch -q -c -w src/ -x "run"` for hot reload
- `examples/quick_dev.rs` for endpoint testing
- Custom Result types throughout
- Structured error handling

## Service Communication

### Frontend → Backend
- Static site (GitHub Pages) → Cloud Run services
- REST API calls with CORS configured
- SSE connections for real-time updates

### Service → Service
- Internal Cloud Run URLs for service communication
- HTTP/JSON for inter-service calls
- Event-driven updates (realtime service notified of state changes)

### Deployment Flow
```
GitHub → Cloud Build → Container Registry → Cloud Run
```

Each service deployed independently with auto-scaling and zero-ops management.