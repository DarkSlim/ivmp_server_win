/**
 * client_script.nut
 *
 * Основной файл клиент-скрипта
 * @author Jonathan_Rosewood <jonathan-rosewood@yandex.ru>
 * @version 0.1 beta
 *
 * Callbacks:
 * @see OnClientScriptInit(playerid)
 * @see OnClientScriptExit(playerid)
 * @see onClientPlayerConnect(playerid)
 * @see onClientPlayerSpawn(playerid)
 * @see onClientPlayerCommand(playerid)
 * @see onClientFrameRender(playerid)
 * @see onClientKeyPress(playerid)
 *
 */
 
// =================================================================================================================================

local screen = guiGetScreenSize();

local girl_logo = GUIImage("girl_logo.png");
girl_logo.setPosition(screen[0]-500, screen[1]-300, false);
girl_logo.setVisible(false);
girl_logo.setSize(500.0, 300.0, false);

local speed_background = GUIImage("speed_background.png");
speed_background.setPosition(screen[0]-200, screen[1]-200, false);
speed_background.setVisible(false);
speed_background.setSize(200.0, 200.0, false);

local speed_arrow = GUIImage("speed_arrow.png");
speed_arrow.setPosition(screen[0]-200, screen[1]-200, false);
speed_arrow.setVisible(false);
speed_arrow.setSize(200.0, 200.0, false);

local fuel_background = GUIImage("fuel_background.png");
fuel_background.setPosition(screen[0]-100, screen[1]-100, false);
fuel_background.setVisible(false);
fuel_background.setSize(100.0, 100.0, false);

local fuel = 0;
local fuel_arrow = GUIImage("fuel_arrow.png");
fuel_arrow.setPosition(screen[0]-100, screen[1]-100, false);
fuel_arrow.setVisible(false);
fuel_arrow.setSize(100.0, 100.0, false);

// =================================================================================================================================

function onClientScriptInit() {
	triggerServerEvent("client_scriptinit");
    return 1;
}
addEvent("scriptInit", onClientScriptInit);

// =================================================================================================================================

function onClientScriptExit() {
	triggerServerEvent("client_scriptexit");
    return 1;
}
addEvent("scriptExit", onClientScriptExit);

// =================================================================================================================================

function onClientPlayerConnect() {
	triggerServerEvent("client_playerconnect");
    return 1;
}
addEvent("playerConnect", onClientPlayerConnect);

// =================================================================================================================================

function onClientPlayerSpawn() {
	triggerServerEvent("client_playerspawn");
    return 1;
}
addEvent("playerSpawn", onClientPlayerSpawn);

// =================================================================================================================================

function onClientPlayerCommand(command) {
	triggerServerEvent("client_playercommand", command);
	return true;
}
addEvent("playerCommand", onClientPlayerCommand);

// =================================================================================================================================

function onClientFrameRender() {
	triggerServerEvent("client_framerender");
	if(!isPlayerOnFoot(getLocalPlayer())) {
		girl_logo.setVisible(true);
		speed_background.setVisible(true);
		speed_arrow.setVisible(true);
		local speed = client_GetVehicleSpeed();
		if(speed > 260.0) speed = 260.0;
		speed_arrow.setRotation(0.0, 0.0, speed+1.0);

		fuel_background.setVisible(true);
		fuel_arrow.setVisible(true);
		if(fuel > 100) fuel = 100;
		fuel_arrow.setRotation(0.0, 0.0, fuel+1.0);
	} else {
		girl_logo.setVisible(false);
		speed_background.setVisible(false);
		speed_arrow.setVisible(false);
		fuel_background.setVisible(false);
		fuel_arrow.setVisible(false);
	}
}
addEvent("frameRender", onClientFrameRender);

// =================================================================================================================================

function onClientKeyPress(key, status) {
	triggerServerEvent("client_keypress", key, status);
	if(status == "down") {
		switch(key) {
			case "j":	// Двигатель
				triggerServerEvent("client_engine");
				break;
			case "h":	// Фары
				triggerServerEvent("client_lights");
				break;
			case "q":	// Левый поворотник
				triggerServerEvent("client_left_blink");
				break;
			case "e":	// Левый поворотник
				triggerServerEvent("client_right_blink");
				break;
			case "i":	// Инвентарь
				triggerServerEvent("client_toogle_inventory");
				break;
			case "alt":	// Действие/Вход/Выход
				triggerServerEvent("client_check_action");
				triggerServerEvent("client_check_enter");
				triggerServerEvent("client_check_exit");
				break;
			default:
				break;
		}
	}
}
addEvent("keyPress", onClientKeyPress);

// =================================================================================================================================

addEvent("server_updatefuel", function(data) { fuel = (data/100); }); 

// =================================================================================================================================

function client_GetVehicleSpeed() {
	local vehicleid = getPlayerVehicleId(getLocalPlayer());
	if(isVehicleValid(vehicleid)) {
		local velocity = getVehicleVelocity(vehicleid);
		local v = sqrt(velocity[0]*velocity[0] + velocity[1]*velocity[1]);
		v = v*10/2.755;
		return v.tofloat();
	}
	else return 0;
}

// =================================================================================================================================