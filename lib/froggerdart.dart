library dartfrogger;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

part 'src/model.dart';
part 'src/control.dart';
part 'src/view.dart';

var loopDelay = 15;

const int gamefieldwidth = 600;
const int gamefieldheight = 800;

const int frogwidth = 40;
const int frogheight = 40;
const int frogspeed = 4;

const int truckwidth = 200;
const int truckheight = 50;
const int truckspeed = 2;

const int carwidth = 75;
const int carheight = 50;
const int carspeed = 7;

const int sportcarwidth = 50;
const int sportcarheight = 50;
const int sportcarspeed = 10;

const int logwidth = 200;
const int logheight = 50;
const int logspeed = 3;

const int turtlewidth = 50;
const int turtleheight = 50;
const int turtlespeed = 2;
const int maxturtleticks = 15;
const int turleinvisbleticks = 2;
const int turleUpdateDelay = 600;

const int ladyfrogwidth = 50;
const int ladyfrogheight = 50;
const int ladyfrogspeed = 1;
const int ladyfrogSwitchDirectionDelay = 5000;