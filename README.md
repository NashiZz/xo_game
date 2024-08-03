# XO Game

## Overview
The XO Game (Tic-Tac-Toe) is a Flutter application where players can play a classic game of Tic-Tac-Toe against either another player or an AI. This README will guide you through setting up, running, and understanding the design and algorithms used in the application.

# Getting Started

## Prerequisites
- Flutter installed on your development machine.
- A code editor such as Visual Studio Code or Android Studio.
- Access to a Firebase project for real-time database functionalities.

## Setup

### 1. Clone the Repository

```bash``
git clone https://github.com/NashiZz/xo_game.git
cd xo_game

### 2. Install Dependencies
Make sure you have Flutter installed and set up. Run the following command to install the required packages:

```bash``
flutter pub get

### 3. Set Up Firebase
Follow the Firebase documentation to set up a Firebase project and add Firebase to your Flutter application. Ensure that you configure the Firebase Firestore correctly to match the structure used in this app.

### 4. Configure Firebase
Create a firebase_options.dart file in your lib folder with your Firebase configuration details.
Update the android/app/build.gradle and ios/Runner/Info.plist with Firebase configurations as described in the Firebase setup guide.

# Running the Application
### 1. Run the App on an Emulator or Device
Make sure an emulator or physical device is connected. Run the following command:

```bash``
flutter run

### 2. Building for Production
To build a release version of the app, use:

```bash``
flutter build apk --release

or for iOS:

```bash``
Copy code
flutter build ios --release

# Design
## Application Structure
- lib/: Contains the main Dart code for the application.
  - main.dart: The entry point of the application.
  - screens/: Contains the UI screens such as GameScreen and ReplayScreen.
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
      - Easy Mode: Chooses a random empty cell.
      - Medium Mode: Checks for immediate win or block and falls back to random if none found.
      - Hard Mode: Uses the Minimax algorithm for optimal moves.

### 5. Minimax Algorithm
      - A recursive algorithm that evaluates all possible moves to determine the best move.
      - Scores moves based on whether they lead to a win, loss, or draw.

# Firebase Integration
- Firestore: Used to store game history, including board states, winners, and timestamps.
- Game History Screen: Displays a list of past games fetched from Firestore and allows replaying them.

# Contribution
Feel free to submit issues or pull requests. Contributions are welcome!

# License
This project is licensed under the MIT License - see the LICENSE file for details.
