// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Checkers {
    enum Player { None, Red, Black }
    enum GameState { WaitingForPlayer, InProgress, Finished }

    struct Game {
        address redPlayer;
        address blackPlayer;
        Player[8][8] board;
        Player currentTurn;
        GameState state;
    }

    Game public game;

    modifier onlyPlayers() {
        require(msg.sender == game.redPlayer || msg.sender == game.blackPlayer, "Not a player");
        _;
    }

    modifier onlyCurrentPlayer() {
        if (game.currentTurn == Player.Red) {
            require(msg.sender == game.redPlayer, "Not your turn");
        } else {
            require(msg.sender == game.blackPlayer, "Not your turn");
        }
        _;
    }

    constructor() {
        game.state = GameState.WaitingForPlayer;
    }

    function joinGame() external {
        require(game.state == GameState.WaitingForPlayer, "Game already started");

        if (game.redPlayer == address(0)) {
            game.redPlayer = msg.sender;
        } else if (game.blackPlayer == address(0)) {
            require(msg.sender != game.redPlayer, "You already joined");
            game.blackPlayer = msg.sender;
            game.state = GameState.InProgress;
            game.currentTurn = Player.Red;
            initializeBoard();
        }
    }

    function initializeBoard() internal {
        for (uint8 y = 0; y < 3; y++) {
            for (uint8 x = 0; x < 8; x++) {
                if ((x + y) % 2 == 1) {
                    game.board[y][x] = Player.Black;
                }
            }
        }
        for (uint8 y = 5; y < 8; y++) {
            for (uint8 x = 0; x < 8; x++) {
                if ((x + y) % 2 == 1) {
                    game.board[y][x] = Player.Red;
                }
            }
        }
    }

    function move(uint8 fromY, uint8 fromX, uint8 toY, uint8 toX) external onlyPlayers onlyCurrentPlayer {
        require(game.state == GameState.InProgress, "Game not active");
        require(isValidMove(fromY, fromX, toY, toX), "Invalid move");

        game.board[toY][toX] = game.board[fromY][fromX];
        game.board[fromY][fromX] = Player.None;

        game.currentTurn = game.currentTurn == Player.Red ? Player.Black : Player.Red;
    }

    function isValidMove(uint8 fromY, uint8 fromX, uint8 toY, uint8 toX) internal view returns (bool) {
        if (fromX >= 8 || fromY >= 8 || toX >= 8 || toY >= 8) return false;
        if (game.board[fromY][fromX] != game.currentTurn) return false;
        if (game.board[toY][toX] != Player.None) return false;

        int8 dy = int8(toY) - int8(fromY);
        int8 dx = int8(toX) - int8(fromX);

        if (abs(dx) != 1 || abs(dy) != 1) return false;

        if (game.currentTurn == Player.Red && dy != -1) return false;
        if (game.currentTurn == Player.Black && dy != 1) return false;

        return true;
    }

    function abs(int8 x) internal pure returns (int8) {
        return x >= 0 ? x : -x;
    }

    function getBoard() external view returns (Player[8][8] memory) {
        return game.board;
    }

    function getCurrentTurn() external view returns (Player) {
        return game.currentTurn;
    }

    function getGameState() external view returns (GameState) {
        return game.state;
    }
}
