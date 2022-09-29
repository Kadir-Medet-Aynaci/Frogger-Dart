part of dartfrogger;

class FroggerGame {
  /// Reference to player (frog)
  Frog frog;

  /// Available truck id
  var availableTruckId = 0;

  /// Available car id
  var availableCarId = 0;

  /// Available sportcar id
  var availableSportcarId = 0;

  /// Available log id
  var availableLogId = 0;

  /// Available turtle id
  var availableTurtleId = 0;

  /// Available ladyfrog id
  var availableLadyfrogId = 0;

  /// Symbol of entity (and #none), which collided with frog
  var colliderWithFrogType = #none;

  /// Entity, which collided with frog
  var colliderWithFrog;

  /// Shows, if frog is on neutral Entity
  var frogOnNonenemy = false;

  /// Shows, if frog is completly on river
  var frogOnRiver = false;

  /// List of all trucks
  List<Truck> trucks = [];

  ///  List of all cars
  List<Car> cars = [];

  /// List of all sportcars
  List<Sportcar> sportcars = [];

  /// List of all logs
  List<Log> logs = [];

  /// List of all turtles
  List<Turtle> turtles = [];

  /// List of all ladyfrogs
  List<Ladyfrog> ladyfrogs = [];

  ///  Information about areas in gamefield
  List<Triple> gamefield = [];

  /// Start- and endposition of all rivers in gamefield
  List<Tuple> rivers = [];

  /// Creates gamefield from parameters (send from controller)
  void createGamefield(List<String> areas, List<int> heights) {
    var currentHeight = 0;
    for (var i = 0; i < areas.length; i++) {
      if (areas.elementAt(i) == 'river') {
        rivers.add(Tuple(currentHeight, currentHeight + heights.elementAt(i)));
      }
      gamefield
          .add(Triple(areas.elementAt(i), currentHeight, heights.elementAt(i)));
      currentHeight += heights.elementAt(i);
    }
  }

  /// Creates the frog
  void createFrog() {
    frog = Frog(0, gamefieldwidth ~/ 2 - frogwidth ~/ 2,
        gamefieldheight - frogheight, frogheight, frogwidth, frogspeed);
  }

  /// Creates the truck
  void createTruck(var x, var y, var left) {
    trucks.add(Truck(
        availableTruckId, x, y, truckheight, truckwidth, truckspeed, left));
    availableTruckId++;
  }

  /// Creates the car
  void createCar(var x, var y, var left) {
    cars.add(Car(availableCarId, x, y, carheight, carwidth, carspeed, left));
    availableCarId++;
  }

  /// Creates the sportcar
  void createSportcar(var x, var y, var left) {
    sportcars.add(Sportcar(availableSportcarId, x, y, sportcarheight,
        sportcarwidth, sportcarspeed, left));
    availableSportcarId++;
  }

  /// Creates the log
  void createLog(var x, var y, var left) {
    logs.add(Log(availableLogId, x, y, logheight, logwidth, logspeed, left));
    availableLogId++;
  }

  /// Creates the turtle
  void createTurtle(var x, var y, var left) {
    turtles.add(Turtle(
        availableTurtleId, x, y, turtleheight, turtlewidth, turtlespeed, left));
    availableTurtleId++;
  }

  /// Creates the ladyfrog
  void createLadyfrog(var log, var left) {
    var x;
    var y = log.posY + logheight ~/ 2 - ladyfrogheight ~/ 2;
    if (left) {
      x = log.posX;
    } else {
      x = log.posX + logwidth - ladyfrogwidth;
    }
    ladyfrogs.add(Ladyfrog(availableLadyfrogId, x, y, ladyfrogheight,
        ladyfrogwidth, ladyfrogspeed, log));
    availableLadyfrogId++;
  }

  /// Lets all entities move
  void moveEntities() {
    frog.move();
    if (colliderWithFrogType == #log && frogOnNonenemy && frogOnRiver) {
      colliderWithFrog.moveFrog(frog);
    }
    if (colliderWithFrogType == #turtle && frogOnNonenemy && frogOnRiver) {
      colliderWithFrog.moveFrog(frog);
    }
    trucks.forEach((truck) {
      truck.move();
    });
    cars.forEach((car) {
      car.move();
    });

    sportcars.forEach((car) {
      car.move();
    });

    logs.forEach((log) {
      log.move();
    });

    turtles.forEach((turtle) {
      turtle.move();
    });

    ladyfrogs.forEach((ladyfrog) {
      ladyfrog.move();
    });
  }

  /// Lets the frog check, if collision with other entities happened
  bool frogIntersects() {
    var temp = false;
    frogOnNonenemy = false;
    logs.forEach((element) {
      if (frog.intersects(element)) {
        colliderWithFrogType = element.type;
        colliderWithFrog = element;
        frogOnNonenemy = true;
      }
    });
    turtles.forEach((element) {
      if (frog.intersects(element) && element.state != #invisible) {
        colliderWithFrogType = element.type;
        colliderWithFrog = element;
        frogOnNonenemy = true;
      }
    });
    trucks.forEach((element) {
      if (frog.intersects(element)) {
        colliderWithFrogType = element.type;
        temp = true;
      }
    });
    cars.forEach((element) {
      if (frog.intersects(element)) {
        colliderWithFrogType = element.type;
        temp = true;
      }
    });
    sportcars.forEach((element) {
      if (frog.intersects(element)) {
        colliderWithFrogType = element.type;
        temp = true;
      }
    });
    ladyfrogs.forEach((element) {
      if (frog.intersects(element)) {
        colliderWithFrogType = element.type;
        temp = true;
      }
    });
    if (!temp && !frogOnNonenemy) {
      colliderWithFrog = null;
      colliderWithFrogType = #none;
    }
    return temp;
  }

  /// Checks and return, if frog has reached finish
  bool hasFrogWon() {
    return (frog.posY + frog.height <= gamefield.first.trd);
  }

  /// Checks and return, if frog is in water (not on water by using log etc.)
  bool isFroginRiver() {
    var inRiver = false;
    for (var river in rivers) {
      if (frog.posY >= river.fst && frog.posY + frog.height <= river.snd) {
        inRiver = true;
        frogOnRiver = true;
      } else {
        frogOnRiver = false;
      }
    }
    if (colliderWithFrogType == #log || colliderWithFrogType == #turtle) {
      return false;
    } else {
      return inRiver;
    }
  }

  /// Lets all turtles update for their behavior
  void updateTurtles() {
    for (var turtle in turtles) {
      turtle.addTick();
    }
  }

  /// Lets all ladyfrogs switch directions
  void switchLadyfrogDirection() {
    for (var ladyfrog in ladyfrogs) {
      ladyfrog.switchDirection();
    }
  }
}

class Tuple {
  /// First element in tuple
  var fst;

  /// Second element in tuple
  var snd;

  Tuple(this.fst, this.snd);

  /// Returns all tupleelements as string
  @override
  String toString() {
    return '$fst, $snd';
  }
}

class Triple {
  /// First element in triple
  var fst;

  /// Second element in triple
  var snd;

  /// Third element in triple
  var trd;

  Triple(this.fst, this.snd, this.trd);

  /// Returns all tripleelements as string
  @override
  String toString() {
    return '$fst, $snd, $trd';
  }
}

class Quadruple {
  /// First element in quadruple
  var fst;

  /// Second element in quadruple
  var snd;

  /// Third element in quadruple
  var trd;

  /// Fourth element in quadruple
  var fth;

  Quadruple(var fst, var snd, var trd, var fth) {
    this.fst = fst;
    this.snd = snd;
    this.trd = trd;
    this.fth = fth;
  }

  /// Returns all quadrupleelements as string
  @override
  String toString() {
    return '$fst, $snd, $trd, $fth';
  }
}

class Entity {
  /// ID of entity
  int id;

  /// The x-coordinate (distance to left border of gamefield)
  int posX;

  /// The y-coordinate (distance to top border of gamefield)
  int posY;

  /// Height of entity
  int height;

  /// Width of entity
  int width;

  /// Steplenght of entity
  int speed;

  /// Shows, if entity is moving left
  var left = false;

  /// Shows, if entity is moving right
  var right = false;

  /// Symbol of entity
  var type;

  /// Shows if entity is neutral (not enemy)
  var neutral;

  Entity(int id, int x, int y, int height, int width, int speed, bool left,
      Symbol type, bool neutral) {
    this.id = id;
    posX = x;
    posY = y;
    this.height = height;
    this.width = width;
    this.speed = speed;
    this.left = left;
    right = !left;
    this.type = type;
    this.neutral = neutral;
  }

  /// Moves the entity in a direction and teleports to other side of gamefield, if entity leaves gamefield
  void move() {
    if (left) {
      posX -= speed;
      if (posX < 0 - width) {
        posX = gamefieldwidth + width;
      }
    }
    if (right) {
      if (posX < gamefieldwidth + width) {
        posX += speed;
      } else {
        posX = -width;
      }
    }
  }

  /// If entity is neutral, it moves the frog with itself
  void moveFrog(Frog frog) {
    if (neutral) {
      if (left) {
        frog.posX -= speed;
        if (frog.posX < 0) {
          frog.posX = 0;
        }
      }
      if (right) {
        frog.posX += speed;
        if (frog.posX > gamefieldwidth - frog.width) {
          frog.posX = gamefieldwidth - frog.width;
        }
      }
    }
  }

  /// Returns the type of entity as string
  String getName() {
    var s = type.toString();
    return s.substring(8, s.length - 2);
  }
}

class Log extends Entity {
  Log(int id, int x, int y, int height, int width, int speed, bool left)
      : super(id, x, y, height, width, speed, left, #log, true);
}

class Frog extends Entity {
  /// Shows, if frog is moving up
  var up = false;

  /// Shows, if frog is moving down
  var down = false;

  Frog(int id, int x, int y, int height, int width, int speed)
      : super(id, x, y, height, width, speed, false, #frog, true) {
    right = false;
  }

  /// Moves the frog in all 4 directions
  @override
  void move() {
    if (up) {
      posY -= speed;
      if (posY < 0) {
        posY = 0;
      }
    }
    if (down) {
      posY += speed;
      if (posY > gamefieldheight - height) {
        posY = gamefieldheight - height;
      }
    }
    if (left) {
      posX -= speed;
      if (posX < 0) {
        posX = 0;
      }
    }
    if (right) {
      posX += speed;
      if (posX > gamefieldwidth - width) {
        posX = gamefieldwidth - width;
      }
    }
  }

  /// Checks and returns, if frog is colliding with other entity
  bool intersects(Entity other) {
    var left = posX;
    var right = posX + width;
    var top = posY;
    var bottom = posY + height;

    var oLeft = other.posX;
    var oRight = other.posX + other.width;
    var oTop = other.posY;
    var oBottom = other.posY + other.height;
    return !(left > oRight || right < oLeft || top > oBottom || bottom < oTop);
  }
}

class Ladyfrog extends Entity {
  /// Reference of log, on which the ladyfrog is
  Log log;

  /// Distance of ladyfrog to left border of log
  var distanceToLeftBorder;

  Ladyfrog(int id, int x, int y, int height, int width, int speed, Log log)
      : super(id, x, y, height, width, speed, log.left, #ladyfrog, false) {
    this.log = log;
    distanceToLeftBorder = posX - this.log.posX;
  }

  /// Moves with and on log, depending on direction
  @override
  void move() {
    posX = this.log.posX + distanceToLeftBorder;

    if (left) {
      distanceToLeftBorder -= speed;
      if (distanceToLeftBorder < 0) {
        distanceToLeftBorder = 0;
      }
    }
    if (right) {
      distanceToLeftBorder += speed;
      if (distanceToLeftBorder > log.width - width) {
        distanceToLeftBorder = log.width - width;
      }
    }
  }

  /// Switches the direction of ladyfrog on log
  void switchDirection() {
    left = !left;
    right = !right;
  }
}

class Car extends Entity {
  Car(int id, int x, int y, int height, int width, int speed, bool left)
      : super(id, x, y, height, width, speed, left, #car, false);
}

class Sportcar extends Entity {
  Sportcar(int id, int x, int y, int height, int width, int speed, bool left)
      : super(id, x, y, height, width, speed, left, #sportcar, false);
}

class Truck extends Entity {
  Truck(int id, int x, int y, int height, int width, int speed, bool left)
      : super(id, x, y, height, width, speed, left, #truck, false);
}

class Turtle extends Entity {
  /// Symbol showing the visabilitystatus of turtle
  var state;

  /// Counter for handeling visabilitystate
  var stateTick;

  Turtle(int id, int x, int y, int height, int width, int speed, bool left)
      : super(id, x, y, height, width, speed, left, #turtle, true) {
    stateTick = 0;
    state = #visible;
  }

  /// Updates tick and visabilitystate
  void addTick() {
    stateTick++;
    if (stateTick > maxturtleticks) {
      stateTick = 0;
    }
    if (stateTick >= maxturtleticks - turleinvisbleticks) {
      state = #invisible;
    } else if (stateTick == (maxturtleticks - turleinvisbleticks) - 1) {
      state = #inwater;
    } else if (stateTick == (maxturtleticks - turleinvisbleticks) - 2) {
      state = #jumping;
    } else {
      state = #visible;
    }
  }
}
