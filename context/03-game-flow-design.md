# Game Flow & Player Experience

## Game Creation & Invitation Flow

### 1. Game Creator Experience
```
1. Creator visits platform (GitHub Pages)
2. Selects game type (e.g., "Tic-Tac-Toe")
3. Platform calls Registry Service to create new game instance
4. Registry Service:
   - Generates unique game ID
   - Stores game rules (TypeScript functions)
   - Randomly selects starting player
   - Returns shareable game link
5. Creator shares link with friend via any method (text, email, etc.)
```

### 2. Friend Joining Experience
```
1. Friend clicks shared link
2. Link opens platform with game ID in URL
3. Platform calls Registry Service to join game
4. Registry Service validates game exists and has space
5. Platform redirects both players to game interface
6. Real-time Service establishes SSE connections
7. Game begins!
```

## Real-time Gameplay Flow

### Move Submission & Broadcasting
```
Player A makes move:
1. Frontend validates move locally (basic checks)
2. POST to Game Engine Service: /api/games/{id}/moves
3. Game Engine Service:
   - Validates move using TypeScript rules
   - Updates authoritative game state
   - Returns new game state
4. Game Engine notifies Real-time Service of state change
5. Real-time Service broadcasts update via SSE to both players
6. Both players see updated board immediately
```

### SSE Event Flow
```typescript
// Frontend establishes SSE connection
const eventSource = new EventSource(`/api/games/${gameId}/events`);

eventSource.onmessage = (event) => {
  const update = JSON.parse(event.data);
  switch(update.type) {
    case 'move_made':
      updateGameBoard(update.gameState);
      break;
    case 'game_ended':
      showGameResult(update.winner);
      break;
    case 'player_connected':
      updatePlayerStatus(update.playerId, 'online');
      break;
  }
};
```

## Browser Storage Strategy

### Player Data (localStorage)
```typescript
interface PlayerData {
  playerId: string;           // UUID generated on first visit
  friends: Friend[];          // List of friends played with
  gameStats: GameStats[];     // Win/loss records per friend
  activeGames: ActiveGame[];  // Currently ongoing games
}

interface Friend {
  friendId: string;
  nickname: string;
  gamesPlayed: number;
  lastPlayed: Date;
}

interface GameStats {
  friendId: string;
  gameType: string;
  wins: number;
  losses: number;
  draws: number;
}
```

### Game State Backup
```typescript
interface GameBackup {
  gameId: string;
  gameType: string;
  players: string[];
  currentState: any;          // Flexible JSON state
  moveHistory: Move[];
  timestamp: Date;
  backupVersion: string;
}
```

## Backup & Recovery System

### Automatic Backup Triggers
- After every 5 moves
- When game reaches critical state (near end)
- Player manually requests backup
- When connection issues detected

### Email Backup Process
```
1. Player/System triggers backup
2. Frontend calls Backup Service: POST /api/games/{id}/backup
3. Backup Service:
   - Captures current game state
   - Generates backup file (JSON)
   - Emails file to both players
   - Returns backup confirmation
```

### Recovery Process
```
1. Player uploads backup file to platform
2. Platform calls Backup Service: POST /api/restore
3. Backup Service:
   - Validates backup file integrity
   - Extracts game state and metadata
   - Creates new game instance with restored state
   - Returns new game link
4. Player shares new link with friend to resume
```

## Connection Handling

### Connection Loss Recovery
```typescript
// Frontend connection monitoring
let reconnectAttempts = 0;
const maxReconnectAttempts = 5;

eventSource.onerror = () => {
  if (reconnectAttempts < maxReconnectAttempts) {
    setTimeout(() => {
      reconnectToGame();
      reconnectAttempts++;
    }, 1000 * Math.pow(2, reconnectAttempts)); // Exponential backoff
  } else {
    showOfflineMode();
    offerBackupDownload();
  }
};
```

### Peer-to-Peer State Sync
When server connection fails:
```
1. Frontend detects friend is still connected (via last heartbeat)
2. Establishes direct WebRTC connection with friend
3. Downloads latest game state from friend's browser
4. Continues game locally until server reconnects
5. Syncs state back to server when connection restored
```

## Game End & Statistics

### Game Completion
```
1. Game Engine detects win/loss/draw condition
2. Real-time Service broadcasts game_ended event
3. Frontend updates local statistics
4. Platform offers:
   - Rematch option (creates new game)
   - Share result
   - Download final game state
   - Return to friend list
```

### Statistics Tracking
- Win/loss/draw records per friend per game type
- Average game duration
- Move patterns and strategies
- All stored locally in browser
- Backed up via email on request