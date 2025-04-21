# ♟️ Onchain Checkers in Solidity

A fully onchain, two-player **Checkers (Draughts)** game built with pure Solidity.  
No frontend. No database. Just smart contract and pure game logic on Ethereum-compatible chains.

---

## 🛠 Features

- ✅ 8x8 checkers board
- ✅ Turn-based logic
- ✅ Player matching
- ✅ Basic move validation 
- 🚧 Coming soon:
  - King logic (damka 👑)
  - Jump captures
  - Game end detection
  - Frontend in React or Telegram bot

---

## ⚙️ How It Works

- First player calls `joinGame()`, becomes **Red**
- Second player joins as **Black**
- Red always moves first
- Each player takes turns using `move(fromY, fromX, toY, toX)`
- Game state is stored and updated **onchain**

---

## 🧪 Example

```solidity
checkers.joinGame(); // Player 1
checkers.joinGame(); // Player 2
checkers.move(5, 0, 4, 1); // Red's move
checkers.move(2, 1, 3, 0); // Black's move
