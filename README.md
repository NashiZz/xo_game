# XO Game (Tic-Tac-Toe)

## Overview
This project consists of a Tic-Tac-Toe game developed with Dart using Flutter and Firebase. The game supports playing against an AI and records game history using Firebase Firestore.

# Getting Started

## Prerequisites
- Flutter installed on your development machine.
- A code editor such as Visual Studio Code or Android Studio.

## Setup

### 1. Clone the Repository

        git clone https://github.com/NashiZz/xo_game.git 
        cd xo_game 

### 2. Install Dependencies
Make sure you have Flutter installed and set up. Run the following command to install the required packages:

        flutter pub get 

# Running the Application
### 1. Run the App on an Emulator or Device
Make sure an emulator or physical device is connected. Run the following command:

        flutter run 

### 2. Building for Production
To build a release version of the app, use:

        flutter build apk --release 

or for iOS:

        flutter build ios --release

# Design

## Application Structure
- lib/: Contains the main Dart code for the application.
  - main.dart: The entry point of the application.
  - screens/: Contains the UI screens such as GameScreen, SelectBoard, SelectPlayer and ReplayScreen. 
  - models/: Contains the game logic and data models such as XOGame.

# UI Design
- Home Screen: Allows users to start a new game or view game history.
- Game Screen: Displays the Tic-Tac-Toe board and allows players to make moves.
- Replay Screen: Shows the board state and highlights the winning cells for a replayed game.

# Algorithm

## Game Logic

### 1. Game State Management
- The game board is represented as a 2D list of strings.
- The current player alternates between 'X' and 'O'.

### 2. Move Validation
- Moves are only valid if the selected cell is empty and the game is not won or drawn.

### 3. Winning Conditions
- The game checks for a winner by verifying rows, columns, and diagonals.
- Winning cells are stored and used to highlight the winning combination.

### 4. AI Behavior
- **AI Moves**: Utilizes basic strategies for making moves:
        - **Winning Move**: Checks if AI can win with the next move.
        - **Blocking Move**: Checks if the opponent can win with the next move and blocks it.
        - **Random Move**: Makes a random move based on probability.

### 5. Algorithm
- This approach uses a modified version of the Minimax Algorithm adapted to handle different board sizes.

# Firebase Integration
- Firestore: Used to store game history, including board states, winners, and timestamps.
- Game History Screen: Displays a list of past games fetched from Firestore and allows replaying them.

## Usage

1. **Playing the Game**

    - **Player vs. AI**: In this game, players can compete against an AI where the player starts as 'X' and the AI plays as 'O', or you can select the side to play in the application.
    - **Making Moves**: Click on any cell of the board to make a move. The AI will respond automatically.

2. **Viewing Game History**

    - Game history is recorded in Firebase Firestore, and players can view it by going to the Home page and clicking the History Play button.

