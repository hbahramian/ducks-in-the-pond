# Duck Simulator - Avalonia Desktop App

This project demonstrates object-oriented strategy pattern using a Duck class hierarchy with animated swimming and quacking!

## Features
- 🦆 Animated ducks swimming in a pond
- 💬 Random quacking with speech bubbles
- 🎨 Different duck types with unique behaviors
- 🌊 Smooth animation with bouncing off pond edges

## Running in VS Code Dev Container

1. Open this folder in VS Code
2. Press F1 or Cmd+Shift+P
3. Select "Dev Containers: Reopen in Container"
4. Wait for the container to build
5. Open browser to http://localhost:6080 (password: vscode)
6. In the virtual desktop, open terminal and run:
   ```bash
   cd /workspaces/DuckSimulator
   export DISPLAY=:1
   dotnet run
   ```

## Class Structure

- **Duck** (abstract base class)
  - quack() - all ducks can quack
  - swim() - all ducks can swim
  - display() - abstract method, each subtype implements
  - getEmoji() - returns the emoji for the duck

- **MallardDuck** - Standard duck (🦆)
- **RedheadDuck** - Redhead duck (🦆)
- **RubberDuck** - Squeaky rubber duck (🐥) - squeaks instead of quacks!
- **DecoyDuck** - Silent wooden duck (🪵) - doesn't quack!

## Animation Details
- Ducks swim automatically using DispatcherTimer
- Random quacking every 2-5 seconds
- Smooth 30fps animation
- Bounces off pond boundaries
