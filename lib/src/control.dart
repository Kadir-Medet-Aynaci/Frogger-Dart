part of dartfrogger;

class FroggerGameController {
  /// Reference to model
  var model = FroggerGame();

  /// Reference to view
  final view = FroggerView();

  /// Current levelnumber
  var level = 1;

  /// Finished Levels
  var score = 0;

  /// Loop with delay for the entitymovement
  Timer moveTrigger;

  /// Loop with delay for detecting the end of the game
  Timer stateTrigger;

  /// Loop with delay for detecting collisions between entities
  Timer collisionTrigger;

  /// Loop with delay for handling turtles behavior
  Timer turtleTrigger;

  /// Loop with delay for handling ladyfrogs behavior
  Timer ladyfrogTrigger;

  /// Information about the areas of levels
  List<dynamic> levels = [];

  /// Information about the spawninglocation of Enemies
  List<dynamic> spawnings = [];

  /// Current State
  Symbol _state = #welcome;

  FroggerGameController() {
    loadJson();
    keyboard();
    view.createMessage('Welcome to Frogger', 'startButton', 'Start');
    mouse();
  }

  /// Lets the model check if player collided with enemies. If so, game ends
  void collisionDetection() {
    if (_state == #running) {
      if (model.frogIntersects() || model.isFroginRiver()) {
        gameOver();
      }
    }
  }

  /// Reads all information about levels from a json
  void loadJson() {
    var list = [];
    HttpRequest.getString('/parameter.json').then((myjson) {
      var parameters = jsonDecode(myjson);
      for (var element in parameters) {
        list = [];
        levels.add(Triple(
            element['LevelId'],
            List<String>.from(element['Area']),
            List<int>.from(element['Height'])));
        for (var entity in element['Entities']) {
          list.add(Quadruple(
              entity['Type'], entity['PosX'], entity['PosY'], entity['Left']));
        }
        spawnings.add(Tuple(element['LevelId'], list));
      }
    });
  }

  /// Starts the current level
  void startGame() {
    reset();
    var tuple = loadLevel();
    model.createGamefield(tuple.fst, tuple.snd);
    view.createGamefield(model.gamefield);
    spawnEntities();
    _state = #running;
    moveTrigger = Timer.periodic(
        Duration(milliseconds: loopDelay), (_) => moveEntity());
    collisionTrigger = Timer.periodic(
        Duration(milliseconds: loopDelay), (_) => collisionDetection());
    stateTrigger = Timer.periodic(
        Duration(milliseconds: loopDelay), (_) => checkState());
    turtleTrigger = Timer.periodic(
        const Duration(milliseconds: turleUpdateDelay), (_) => updateTurtles());
    ladyfrogTrigger = Timer.periodic(
        const Duration(milliseconds: ladyfrogSwitchDirectionDelay),
        (_) => model.switchLadyfrogDirection());
  }

  /// Resets model and view
  void reset() {
    model = FroggerGame();
    view.reset();
  }

  /// Stops the game (because of game lost) and lets the view show a message
  void gameOver() async {
    view.createMessage('Game Over', 'restartButton', 'Restart');
    mouse();
    moveTrigger.cancel();
    collisionTrigger.cancel();
    stateTrigger.cancel();
    turtleTrigger.cancel();
    ladyfrogTrigger.cancel();
    _state = #stopped;
  }

  /// Stops the game (because of game won) and lets the view show a message
  void gameWon() async {
    view.createMessage('Level finished', 'nextButton', 'Next Level');
    if (level < levels.length) {
      level++;
    } else if (loopDelay >= 2) {
      loopDelay--;
    }
    score++;
    mouse();
    moveTrigger.cancel();
    collisionTrigger.cancel();
    stateTrigger.cancel();
    turtleTrigger.cancel();
    ladyfrogTrigger.cancel();
    _state = #stopped;
  }

  /// Lets model move all entities and lets view update their position
  void moveEntity() {
    if (_state == #running) {
      model.moveEntities();
      var frogInList = <Frog>[];
      frogInList.add(model.frog);
      view.moveEntitys(frogInList);
      view.moveEntitys(model.trucks);
      view.moveEntitys(model.cars);
      view.moveEntitys(model.sportcars);
      view.moveEntitys(model.logs);
      view.moveEntitys(model.turtles);
      view.moveEntitys(model.ladyfrogs);
    }
  }

  /// Lets model and view create entities depending on current level
  void spawnEntities() {
    model.createFrog();
    view.createEntity(model.frog);

    for (Tuple tuple in spawnings) {
      if (tuple.fst == level) {
        for (Quadruple entity in tuple.snd) {
          if (entity.fst == 'Truck') {
            model.createTruck(entity.snd, entity.trd, entity.fth);
            view.createEntity(model.trucks.last);
          }
          if (entity.fst == 'Car') {
            model.createCar(entity.snd, entity.trd, entity.fth);
            view.createEntity(model.cars.last);
          }
          if (entity.fst == 'SportCar') {
            model.createSportcar(entity.snd, entity.trd, entity.fth);
            view.createEntity(model.sportcars.last);
          }
          if (entity.fst == 'Log') {
            model.createLog(entity.snd, entity.trd, entity.fth);
            view.createEntity(model.logs.last);
          }
          if (entity.fst == 'Turtle') {
            model.createTurtle(entity.snd, entity.trd, entity.fth);
            view.createEntity(model.turtles.last);
          }
          if (entity.fst == 'Log_Ladyfrog') {
            model.createLog(entity.snd, entity.trd, entity.fth);
            view.createEntity(model.logs.last);
            model.createLadyfrog(model.logs.last, false);
            view.createEntity(model.ladyfrogs.last);
          }
          if (entity.fst == 'Ladyfrog_Log') {
            model.createLog(entity.snd, entity.trd, entity.fth);
            view.createEntity(model.logs.last);
            model.createLadyfrog(model.logs.last, true);
            view.createEntity(model.ladyfrogs.last);
          }
        }
      }
    }
  }

  /// Lets model and view update turtles behavior
  void updateTurtles() {
    if (_state == #running) {
      model.updateTurtles();
      view.updateTurtles(model.turtles);
    }
  }

  /// Lets model check, if game is won
  void checkState() {
    if (_state == #running) {
      if (model.hasFrogWon()) {
        gameWon();
      }
    }
  }

  /// Reads and returns information about current Level
  Tuple loadLevel() {
    var tuple;
    for (Triple triple in levels) {
      if (triple.fst == level) {
        tuple = Tuple(triple.snd, triple.trd);
      }
    }
    return tuple;
  }

  /// Handles keyboard Inputs from user
  void keyboard() {
    window.onKeyDown.listen((KeyboardEvent event) {
      switch (event.keyCode) {
        case KeyCode.UP:
          model.frog.up = true;
          break;
        case KeyCode.DOWN:
          model.frog.down = true;
          break;
        case KeyCode.LEFT:
          model.frog.left = true;
          break;
        case KeyCode.RIGHT:
          model.frog.right = true;
          break;
        case KeyCode.K:
          gameWon();
          view.removeMessage();
          startGame();
          break;
      }
    });

    window.onKeyUp.listen((KeyboardEvent event) {
      switch (event.keyCode) {
        case KeyCode.UP:
          model.frog.up = false;
          break;
        case KeyCode.DOWN:
          model.frog.down = false;
          break;
        case KeyCode.LEFT:
          model.frog.left = false;
          break;
        case KeyCode.RIGHT:
          model.frog.right = false;
          break;
      }
    });
  }

  /// Handles mouse Inputs from user
  void mouse() {
    if (view.startButton != null) {
      view.startButton.onClick.listen((_) {
        view.removeMessage();
        startGame();
      });
    }
    if (view.restartButton != null) {
      view.restartButton.onClick.listen((_) {
        view.removeMessage();
        startGame();
      });
    }
    if (view.nextButton != null) {
      view.nextButton.onClick.listen((_) {
        view.removeMessage();
        startGame();
      });
    }
  }
}
