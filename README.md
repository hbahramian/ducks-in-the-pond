# Duck Simulator - Avalonia Desktop App

This project demonstrates object-oriented strategy pattern using a Duck class hierarchy.

## Running in VS Code Dev Container

1. Open this folder in VS Code
2. Press F1 or Cmd+Shift+P
3. Select "Dev Containers: Reopen in Container"
4. Wait for the container to build
5. Open browser to http://localhost:6080 (password: vscode)
6. In the virtual desktop, open terminal and run:
   ```bash
   cd /workspaces/DuckSimulator
   dotnet run
   ```

## Class Structure

- **Duck** (abstract base class)
  - quack() - all ducks can quack
  - swim() - all ducks can swim
  - display() - abstract method, each subtype implements

- **MallardDuck** - implements display() for mallard appearance
- **RedheadDuck** - implements display() for redhead appearance
- **RubberDuck** - implements display() + overrides swim()
- **DecoyDuck** - implements display() + overrides quack()
