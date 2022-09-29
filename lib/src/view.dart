part of dartfrogger;

class FroggerView {
  /// Returns the button (HTML-CSS) which starts the game
  HtmlElement get startButton => querySelector('#startButton');

  /// Returns the button (HTML-CSS) which restarts the game
  HtmlElement get restartButton => querySelector('#restartButton');

  /// Returns the button (HTML-CSS) which starts the new level
  HtmlElement get nextButton => querySelector('#nextButton');

  /// Updates the Position and direction of entities (HTML-CSS)
  void moveEntitys(List<Entity> entitys) {
    entitys.forEach((entity) {
      var entityElement =
          document.querySelector('#${entity.getName()}${entity.id}');
      entityElement.style?.top = '${entity.posY}px';
      entityElement.style?.left = '${entity.posX}px';

      if (entity.type == #ladyfrog) {
        if (entity.left) {
          entityElement.style?.transform = 'rotate(0deg)';
        } else {
          entityElement.style?.transform = 'rotate(180deg)';
        }
      }
      if (entity.type == #frog) {
        if (entity.left) {
          entityElement.style?.backgroundImage = 'url("img/frog_left.png")';
        }
        if ((entity as Frog).up) {
          entityElement.style?.backgroundImage = 'url("img/frog.png")';
        }
        if (entity.right) {
          entityElement.style?.backgroundImage = 'url("img/frog_right.png")';
        }
        if ((entity as Frog).down) {
          entityElement.style?.backgroundImage = 'url("img/frog_down.png")';
        }
      }
    });
  }

  /// Creates the gamefield (HTML-CSS) depending on current level (parameter)
  void createGamefield(List<Triple> gamefield) {
    var gamefieldDiv = DivElement();
    gamefieldDiv.id = 'gamefield';
    gamefieldDiv.className = 'centering';
    document.querySelector('body').children.add(gamefieldDiv);
    var createGamefield = document.querySelector('#gamefield');
    createGamefield.style?.width = '${gamefieldwidth}px';
    createGamefield.style?.height = '${gamefieldheight}px';
    for (Triple triple in gamefield) {
      var areaDiv = DivElement();
      areaDiv.className = '${triple.fst}';
      document.querySelector('#gamefield').children.add(areaDiv);
      createGamefield = document.querySelector('.${triple.fst}:last-child');
      createGamefield.style?.top = '${triple.snd}px';
      createGamefield.style?.height = '${triple.trd}px';
    }
  }

  /// Creates an entity (HTML-CSS)
  void createEntity(Entity entity) {
    var entityDiv = DivElement();
    entityDiv.id = '${entity.getName()}${entity.id}';
    entityDiv.className = '${entity.getName()} entity';

    entityDiv.style?.left = '${entity.posX}px';
    entityDiv.style?.width = '${entity.width}px';
    entityDiv.style?.height = '${entity.height}px';
    if (entity.type != #frog) {
      if (entity.left) {
        entityDiv.style?.transform = 'rotate(0deg)';
      } else {
        entityDiv.style?.transform = 'rotate(180deg)';
      }
    }
    document.querySelector('#gamefield').children.add(entityDiv);
  }

  /// Creates a window with text and button (HTML-CSS)
  void createMessage(String headline, String buttonId, String buttonText) {
    var messageDiv = DivElement();

    messageDiv.className = 'message centering';
    document.querySelector('body').children.add(messageDiv);
    var levelTitle = HeadingElement.h1();
    levelTitle.appendText(headline);
    messageDiv.append(levelTitle);

    var button = AnchorElement();
    button.id = buttonId;
    button.className = 'button';
    button.appendText(buttonText);
    button.style.top = '50%';
    messageDiv.children.add(button);
  }

  /// Removes a window with text and button (HTML-CSS)
  void removeMessage() {
    document.querySelector('.message').remove();
  }

  /// Removes all elements (HTML-CSS) in body
  void reset() {
    document.querySelector('body').innerHtml = "";
  }

  /// Updates the turtles bahavior (HTML-CSS)
  void updateTurtles(List<Turtle> turtles) {
    var turtleElement;
    for (Turtle turtle in turtles) {
      turtleElement = document.querySelector('#turtle${turtle.id}');
      if (turtle.state == #visible) {
        turtleElement.style?.opacity = '0.7';
        turtleElement.style?.visibility = 'visible';
      } else if (turtle.state == #jumping) {
        turtleElement.style?.opacity = '0.5';
      } else if (turtle.state == #inwater) {
        turtleElement.style?.opacity = '0.3';
      } else {
        turtleElement.style?.visibility = 'hidden';
      }
    }
  }
}
