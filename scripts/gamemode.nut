/**
 * gamemode.nut
 *
 * �������� ���� �������� ������
 * @author Jonathan_Rosewood <jonathan-rosewood@yandex.ru>
 * @version 0.1 beta
 *
 * Callbacks:
 * @see OnScriptInit()
 * @see OnScriptExit()
 * @see OnPlayerConnect(playerid, playername, playerip, playerserial, bHasModdedGameFiles)
 * @see OnPlayerDisconnect(playerid, reason)
 * @see OnPlayerSpawn(playerid)
 * @see OnPlayerJoin(playerid)
 * @see OnPlayerDeath(playerid, killerid, killerweapon, killervehicle)
 * @see OnPlayerText(playerid, text)
 * @see OnPlayerCommand(playerid, command)
 * @see OnPlayerEnterCheckpoint(playerid, checkpointid)
 * @see OnPlayerLeaveCheckpoint(playerid, checkpointid)
 *
 * Commands:
 * @see /help
 *
 * Todo:
 * @todo Vehicle hud system(speed+fuel)
 * @todo House system(buy, sell, asell, lock)
 * @todo Player/House/Business/Vehicle inventory system(items/v items/b items/h items)
 * @todo House/Business/Vehicle keys system(givekey/takekey/dropkey)
 *
 */

/*

string.tostring() 				// ����������� string � ������ (������: SomeThing23)
string.tointeger()				// ����������� string � ����� (������: 23)
string.tofloat() 				// ����������� string � ����� � ��������� ������ (������: 1.599)
string.toupper() 				// ����������� string � ������� ������� (������: ivmp -> IVMP)
string.tolower() 				// ����������� string � ������ ������� (������: IVMP -> ivmp)
string.find(substr,[startidx])	// ���� �������� substr ������� � ������� startidx, ���������� ������ ������� ���������.
string.slice(start,[end]) 		// �������� ������, ���������� ���������� ������ ����� start � end.

fadePlayerScreenIn(playerid, 100);
fadePlayerScreenOut(playerid, 100);

*/

dofile("scripts/includes/mysql.nut");
sql <- mysql("localhost", "root", "", "ivmp_server");

// =================================================================================================================================

const COLOR_HEX_WHITE 	= 0xFFFFFFFF;	// 100% �����(hex)
const COLOR_RGBA_WHITE 	= "FFFFFFFF";	// 100% �����(rgba)
const COLOR_HEX_BLACK 	= 0x000000FF;	// 100% ������(hex)
const COLOR_RGBA_BLACK 	= "000000FF";	// 100% ������(rgba)

const COLOR_HEX_RED 	= 0xFF0000FF;	// 100% �������(hex)
const COLOR_RGBA_RED 	= "FF0000FF";	// 100% �������(rgba)
const COLOR_HEX_GREEN 	= 0x00FF00FF;	// 100% �������(hex)
const COLOR_RGBA_GREEN 	= "00FF00FF";	// 100% �������(rgba)
const COLOR_HEX_BLUE 	= 0x0000FFFF;	// 100% �����(hex)
const COLOR_RGBA_BLUE 	= "0000FFFF";	// 100% �����(rgba)

const COLOR_HEX_YELLOW 	= 0xFFFF00AA;	// 100% ������(hex)
const COLOR_RGBA_YELLOW	= "FFFF00FF";	// 100% ������(rgba)
const COLOR_HEX_CYAN	= 0x00FFFFAA;	// 100% ����(hex)
const COLOR_RGBA_CYAN	= "00FFFFFF";	// 100% ����(rgba)
const COLOR_HEX_PURPLE	= 0xFF00FFAA;	// 100% ���������(hex)
const COLOR_RGBA_PURPLE	= "FF00FFFF";	// 100% ���������(rgba)

const COLOR_HEX_ONLINE	= 0x00FF00FF;	// ���� ��� ���������������� �������
const COLOR_HEX_OFFLINE = 0xFF0000FF;	// ���� ��� �� ���������������� �������

const COLOR_HEX_USE 	= 0xDDDDDDAA;	// ���� ��� '�����������'
const COLOR_HEX_ERROR 	= 0xFF0000AA;	// ���� ��� '������'
const COLOR_HEX_INFO 	= 0xAAAAAAAA;	// ���� ��� '����������'
const COLOR_HEX_RPACT 	= 0xC2A2DAAA;	// ���� ��� 'AME/ME/ADO/DO'
const COLOR_HEX_ADMINACT= 0xFF6347AA;	// ���� ��� 'kick, mute, ban, ajail, warn'
const COLOR_HEX_REPORT	= 0xFF4500AA;	// ���� ��� ��������� �������������
const COLOR_HEX_ANSWER	= 0xFFFF00AA;	// ���� ��� ������� �������������
const COLOR_HEX_ADVERT	= 0x00D900C8;	// ���� ��� '/ad'
const COLOR_HEX_MAIN	= 0xB8860BFF;	// ���� ��� ������ OOC ����
const COLOR_HEX_WARNING	= 0xFFFF00AA;	// ���� ������ ��������� ��� �������������

const COLOR_HEX_FADE1 	= 0xE6E6E6E6;
const COLOR_HEX_FADE2 	= 0xC8C8C8C8;
const COLOR_HEX_FADE3 	= 0xAAAAAAAA;
const COLOR_HEX_FADE4 	= 0x8C8C8C8C;
const COLOR_HEX_FADE5 	= 0x6E6E6E6E;

// =================================================================================================================================

const DIALOG_STYLE_MSGBOX	= 0;
const DIALOG_STYLE_INPUT	= 1;
const DIALOG_STYLE_LIST		= 2;

const DIALOG_NONE			= 0;
const DIALOG_LOGIN			= 1;
const DIALOG_REGISTER		= 2;

// =================================================================================================================================

local PlayerInfo = {};

// =================================================================================================================================

local total_vehicles = -1;
local VehicleInfo = {};

// =================================================================================================================================

local total_businesses = -1;
local BusinessInfo = {};

const BUSINESS_TYPE_NONE		= 0;
const BUSINESS_TYPE_DEFAULT		= 1;
const BUSINESS_TYPE_BURGER		= 2;
const BUSINESS_TYPE_CLUCKINBELL	= 3;
const BUSINESS_TYPE_SUPERSTAR	= 4;

// =================================================================================================================================

local total_objects = -1;
local ObjectInfo = {};

// =================================================================================================================================

local date_info;
local timer_second;
local timer_minute;

// =================================================================================================================================

local WeaponNames = array(20, "");
WeaponNames = [ "None" , "Baseball Bat" , "Pool Cue" , "Knife" , "Grenade" , "Molotov" , "None" , "Glock" , "None" , "Deagle" , "Pump Shotgun" , "Remingthon" , "Micro-SMG" , "SMG" , "AK-47" , "M4A1" , "Sniper Rifle" , "Rifle" , "Rocket Launcher" , "Flamethrower" , "Minigun" ];

// =================================================================================================================================

function onScriptInit() {
	log("[Function] onScriptInit() called...");
	sql.connect();

/* Not working correctly.
	local config = getConfig();
	if(config.rawin("paynspray")) {
		log(" Pay'n'Spray: "+config["paynspray"]);
		togglePayAndSpray(config["paynspray"]);
	}
	else log(" Pay'n'Spray not configured at 'settings.xml' file.");

	if(config.rawin("autoaim")) {
		log(" Auto Aim: "+config["autoaim"]);
		toggleAutoAim(config["autoaim"]);
	}
	else log(" Auto Aim not configured at 'settings.xml' file.");
*/

	LoadObjects();
	LoadVehicles();
	LoadBusinesses();
	
	date_info = date();
	log(" Unix Time: "+time());
    log(" Server Time: "+date_info["hour"]+":"+date_info["min"]+":"+date_info["sec"]);
    log(" Server Date: "+date_info["day"]+"/"+(date_info["month"]+1)+"/"+date_info["year"]);
	switch(date_info["wday"]) {
		case 0: log(" Day of the week: Sunday"); break;
		case 1: log(" Day of the week: Monday"); break;
		case 2: log(" Day of the week: Tuesday"); break;
		case 3: log(" Day of the week: Wednesday"); break;
		case 4: log(" Day of the week: Thursday"); break;
		case 5: log(" Day of the week: Friday"); break;
		case 6: log(" Day of the week: Saturday"); break;
		default: log(" Day of the week: Unknown"); break;
	}
    log(" Day of the year: "+date_info["yday"]+"\n");
	setTime(date_info["hour"], date_info["min"]);
	setDayOfWeek(date_info["wday"]);

	timer_second = timer(TimerSecond, 1000, -1);
	timer_minute = timer(TimerMinute, 60000, -1);

	log(_version_);
	log("\nScript "+SCRIPT_NAME+" sucessfully loaded.");
    return true;
}
addEvent("scriptInit", onScriptInit);

// =================================================================================================================================

function onScriptExit() {
	log("[Function] onScriptExit() called...");
	SavePlayers();
	SaveObjects();
	SaveVehicles();
	SaveBusinesses();
	timer_second.kill();
	timer_minute.kill();
	sql.disconnect();
	log(_version_);
	log("Script "+SCRIPT_NAME+" sucessfully unloaded.");
    return true;
}
addEvent("scriptExit", onScriptExit);

// =================================================================================================================================

function onPlayerConnect(playerid, playername, playerip, playerserial, bHasModdedGameFiles) {
	log("[Function] onPlayerConnect("+playerid+", "+playername+", "+playerip+", "+playerserial+", "+bHasModdedGameFiles+") called by "+playername);

	PlayerInfo[playerid] <- {};
	PlayerInfo[playerid].Logged <- false;
	PlayerInfo[playerid].Registred <- false;
	PlayerInfo[playerid].UseModdedGame <- false;
	PlayerInfo[playerid].LoginTryes <- 0;
	PlayerInfo[playerid].InCheckpoint <- false;
	PlayerInfo[playerid].PhoneSpeakWith <- -1;
	PlayerInfo[playerid].ID <- 0;
	PlayerInfo[playerid].Nickname <- 0;
	PlayerInfo[playerid].Password <- 0;
	PlayerInfo[playerid].Email <- 0;
	PlayerInfo[playerid].Reg_IP <- 0;
	PlayerInfo[playerid].Last_IP <- 0;
	PlayerInfo[playerid].Sex <- 0;
	PlayerInfo[playerid].Age <- 0;
	PlayerInfo[playerid].Admin_Level <- 0;
	PlayerInfo[playerid].Faction <- 0;
	PlayerInfo[playerid].Played_Minutes <- 0;
	PlayerInfo[playerid].Played_Hours <- 0;
	PlayerInfo[playerid].Phone <- 0;
	PlayerInfo[playerid].Skin <- 0;
	PlayerInfo[playerid].Cash <- 0;
	PlayerInfo[playerid].Bank <- 0;
	PlayerInfo[playerid].Pos_X <- 0;
	PlayerInfo[playerid].Pos_Y <- 0;
	PlayerInfo[playerid].Pos_Z <- 0;
	PlayerInfo[playerid].Pos_FA <- 0;
	PlayerInfo[playerid].Vehicle_Key <- 0;
	PlayerInfo[playerid].Business_Key <- 0;

	if(bHasModdedGameFiles) {
		SendMessageToAdmin("[��������]: "+playername+"["+playerid+"] ���������� ���������������� ������ ����!", COLOR_HEX_WARNING);
		log("[Warning] "+playername+"[ip"+playerip+"] use modded game files.");
		PlayerInfo[playerid].UseModdedGame = true;
	}

	if(sql.query_assoc("SELECT * FROM `characters` WHERE `nickname` = '"+sql.escape(playername)+"' LIMIT 1;").len() == 1) {
		PlayerInfo[playerid].Registred = true;
		log("Player "+playername+" have account on the server!");
	} else {
		PlayerInfo[playerid].Registred = false;
		log("Player "+playername+" do not have account on the server!");
	}
	sendMessageToAll("����� '"+playername+"' ����������� � �������.", COLOR_HEX_WHITE, true);
	setPlayerColor(playerid, COLOR_HEX_OFFLINE);
	return 1;
}
addEvent("playerConnect", onPlayerConnect);

// =================================================================================================================================

function onPlayerJoin(playerid) {
	log("[Function] onPlayerJoin("+playerid+") called by "+getPlayerName(playerid));
	sendPlayerMessage(playerid, "����� ���������� �� [33CCFFFF]"+getHostname().tostring()+"!", COLOR_HEX_WHITE, true);
//	if(PlayerInfo[playerid].Registred == true)
//		sendPlayerMessage(playerid, "�����������: [33CCFFFF]/login [������]", COLOR_HEX_USE, true);
//	else
//		sendPlayerMessage(playerid, "�����������: [33CCFFFF]/register [������]", COLOR_HEX_USE, true);
	return false;
}
addEvent("playerJoin", onPlayerJoin);

// =================================================================================================================================

function onPlayerSpawn(playerid) {
	log("[Function] onPlayerSpawn("+playerid+") called by "+getPlayerName(playerid));
	if(PlayerInfo[playerid].Logged != true) {
		if(PlayerInfo[playerid].Registred == true)
			showPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Russian Role Play - Login", "Hello, "+getPlayerName(playerid)+"\nPlease type your password:", "Next");
		else
			showPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Russian Role Play - Registration", "Hello, "+getPlayerName(playerid)+"\nPlease type your password:", "Next");
		setPlayerCameraPos(playerid, -593.5, -590.5, 122.0);
		setPlayerCameraLookAt(playerid, -608.5, -744.5, 21.0);
		togglePlayerControls(playerid, false);
		return false;
	}
	setPlayerPosition(playerid, PlayerInfo[playerid].Pos_X, PlayerInfo[playerid].Pos_Y, PlayerInfo[playerid].Pos_Z);
	setPlayerHeading(playerid, PlayerInfo[playerid].Pos_FA);
	return true;
}
addEvent("playerSpawn", onPlayerSpawn);

// =================================================================================================================================

function onPlayerDeath(playerid, killerid, killerweapon, killervehicle) {
	log("[Function] onPlayerDeath("+playerid+", "+killerid+", "+killerweapon+", "+killervehicle+") called by "+getPlayerName(playerid));
	if(killerid != INVALID_PLAYER_ID)
	    sendMessageToAll("����� "+getPlayerName(playerid)+"["+playerid+"] ��� ���� ������� "+getPlayerName(killerid)+"["+killerid+"].", COLOR_HEX_WHITE, true);
	else
	    sendMessageToAll("����� "+getPlayerName(playerid)+"["+playerid+"] ����.", COLOR_HEX_WHITE, true);

	removePlayerWeapons(playerid);
	PlayerInfo[playerid].Pos_X = -341.36;
	PlayerInfo[playerid].Pos_Y = 1144.80;
	PlayerInfo[playerid].Pos_Z = 14.79;
	PlayerInfo[playerid].Pos_FA = 40.0;
	return true;
}
addEvent("playerDeath", onPlayerDeath);

// =================================================================================================================================

function onPlayerDisconnect(playerid, reason) {
	log("[Function] onPlayerDisconnect("+playerid+", "+reason+") called by "+getPlayerName(playerid));
	if(reason == 0)
		sendMessageToAll("����� '"+getPlayerName(playerid)+"' ���������� �� ������� [�����]", COLOR_HEX_WHITE, true);
	else
		sendMessageToAll("����� '"+getPlayerName(playerid)+"' ���������� �� ������� [�����]", COLOR_HEX_WHITE, true);
	SavePlayer(playerid);
	delete PlayerInfo[playerid];
	return true;
}
addEvent("playerDisconnect", onPlayerDisconnect);

// =================================================================================================================================

function onPlayerText(playerid, text) {
	log("[Function] onPlayerText("+playerid+", "+text+") called by "+getPlayerName(playerid));
	if(PlayerInfo[playerid].Logged == false)
		return sendPlayerMessage(playerid, "������: �� �� ������������ ��� ������������� ����!", COLOR_HEX_ERROR, true);

	if(PlayerInfo[playerid].PhoneSpeakWith != -1) {
		PlayerChatPhoneIC(playerid, text);
		local speakwithid = PlayerInfo[playerid].PhoneSpeakWith;
		if(isPlayerConnected(speakwithid))
			if(PlayerInfo[speakwithid].PhoneSpeakWith == playerid)
				sendPlayerMessage(speakwithid, getPlayerName(playerid)+" ������� ���(�������): "+text, COLOR_HEX_WHITE, true);
	}
	else PlayerChatIC(playerid, text);
	return true;
}
addEvent("playerText", onPlayerText);

// =================================================================================================================================

function onPlayerCommand(playerid, command) {
	log("[Function] onPlayerCommand("+playerid+", "+command+") called by "+getPlayerName(playerid));
	local cmd = split(command.slice(1), " ");

	if(cmd[0].tolower() == "login") {
		if(PlayerInfo[playerid].Registred != true)
			return sendPlayerMessage(playerid, "������: �� �� ����������������!", COLOR_HEX_ERROR, true);
		if(PlayerInfo[playerid].Logged != false)
			return sendPlayerMessage(playerid, "������: �� ��� ��������������!", COLOR_HEX_ERROR, true);
		showPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Russian Role Play - Login", "Hello, "+getPlayerName(playerid)+"\nPlease type your password:", "Next");
/*
		if(cmd.len() != 2)
			return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/login [������]", COLOR_HEX_USE, true);
		if(LoadPlayer(playerid, command.slice(cmd[0].len()+2, command.len()))) {
			if(PlayerInfo[playerid].Admin_Level != 0)
				sendPlayerMessage(playerid, "�� ������� ���������������� ��� ������������� "+PlayerInfo[playerid].Admin_Level+" ������!", COLOR_HEX_INFO, true);
			else
				sendPlayerMessage(playerid, "�� ������� ����������������!", COLOR_HEX_INFO, true);
		}
*/
		return true;
	}

	else if(cmd[0].tolower() == "register") {
		if(PlayerInfo[playerid].Registred != false)
			return sendPlayerMessage(playerid, "������: �� ��� ����������������!", COLOR_HEX_ERROR, true);
		showPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Russian Role Play - Registration", "Hello, "+getPlayerName(playerid)+"\nPlease type your password:", "Next");
/*
		if(cmd.len() != 2)
			return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/register [������]", COLOR_HEX_USE, true);
		local character = sql.query("INSERT INTO `characters` (`nickname`,`password`,`email`,`reg_ip`) VALUES ('"+getPlayerName(playerid)+"','"+command.slice(cmd[0].len()+2, command.len())+"','no email','"+getPlayerIp(playerid)+"');");
		if(character) {
			PlayerInfo[playerid].Registred = true;
			sendPlayerMessage(playerid, "�����������! �� ������� ������������������.", COLOR_HEX_INFO);
			sendPlayerMessage(playerid, "�����������: [33CCFFFF]/login [������]", COLOR_HEX_USE, true);
		} else {
			sendPlayerMessage(playerid, "������: �� ������� ������������������, ��������� � ������� ���������������!", COLOR_HEX_ERROR);
			sendPlayerMessage(playerid, "Skype: [33CCFFFF]ivan_ameno", COLOR_HEX_INFO);
		}
*/
		return true;
	}

	if(PlayerInfo[playerid].Logged != true)
		return sendPlayerMessage(playerid, "������: �� �� ������������ ��� ������������� ���� �������!", COLOR_HEX_ERROR, true);

	switch(cmd[0].tolower()) {

		case "dialog":
			switch(cmd[1].tointeger()) {
				case 0:
					showPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "Russian Role Play - Welcome", "Hello, "+getPlayerName(playerid)+".", "Next", "Exit");
					break;
				case 1:
					showPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "Russian Role Play - Welcome one button", "Hello, "+getPlayerName(playerid)+".", "Next");
					break;
				case 2:
					showPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_INPUT, "Russian Role Play - Login", "Enter your password:", "Next", "Cancel");
					break;
				case 3:
					showPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_INPUT, "Russian Role Play - Login one button", "Enter your password:", "Next");
					break;
				case 4:
					showPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_LIST, "Russian Role Play - City Selection", "First City\nSecond City\nThird City", "Select", "Cancel"); 
					break;
				case 5:
					showPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_LIST, "Russian Role Play - City Selection one button", "First City\nSecond City\nThird City", "Select"); 
					break;
				default:
					sendPlayerMessage(playerid, "������: �������� ��������!", COLOR_HEX_ERROR);
					break;
			}
			break;

		case "mypos":
			local position = getPlayerCoordinates(playerid);
			local heading = getPlayerHeading(playerid);
			log("Coords are x"+position[0]+", y"+position[1]+", z"+position[2]+", fa"+heading+"");
			sendPlayerMessage(playerid, "���� ����������: x"+position[0]+", y"+position[1]+", z"+position[2]+", fa"+heading+"", COLOR_HEX_WHITE, true);
			break;

		case "enter":
			onPlayerCheckEnterPoint(playerid);
			break;

		case "exit":
			onPlayerCheckExitPoint(playerid);
			break;

		case "buyphone":
			if(PlayerInfo[playerid].Phone != 0)
				return sendPlayerMessage(playerid, "������: �� ��� ������ �������!", COLOR_HEX_ERROR);
			PlayerInfo[playerid].Phone = 100000+PlayerInfo[playerid].ID.tointeger();
			sendPlayerMessage(playerid, "�� ������� ������ �������. ��� �����: "+PlayerInfo[playerid].Phone+".", COLOR_HEX_INFO);
			break;

		case "sms":
			if(PlayerInfo[playerid].Phone == 0)
				return sendPlayerMessage(playerid, "������: �� �� ������ ��������!", COLOR_HEX_ERROR);
			if(cmd.len() < 3)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/sms [����� ��������] [�����]", COLOR_HEX_USE, true);
			if(PlayerInfo[playerid].Phone == cmd[1].tointeger())
				return sendPlayerMessage(playerid, "������: ������ �������� ������ ����!", COLOR_HEX_ERROR);
			local query = sql.query_assoc("SELECT * FROM `characters` WHERE `phone` = '"+cmd[1].tointeger()+"' LIMIT 1;");
			if(!query || query.len() < 1)
				return sendPlayerMessage(playerid, "������: ����� �� ����������.", COLOR_HEX_ERROR);
			local text = command.slice(cmd[0].len()+cmd[1].len()+3, command.len());
			sendPlayerMessage(playerid, "[SMS] �� ��������� ��������� �� ����� "+cmd[1].tointeger(), COLOR_HEX_WHITE);
			sendPlayerMessage(playerid, "[SMS] �����: "+text, COLOR_HEX_INFO);
			sql.query("INSERT INTO `phone_sms` (`sender`, `taker`, `text`) VALUES ('"+PlayerInfo[playerid].Phone+"', '"+cmd[1].tointeger()+"', '"+text+"');");
			foreach(id, player in getPlayers()) {
				if(PlayerInfo[id].Logged != true)
					continue;
				if(PlayerInfo[id].Phone != cmd[1].tointeger())
					continue;
				displayHudNotification(id, 1, "UNREAD_MESSAGES");
				displayPlayerInfoText(id, "~w~You have ~g~new~w~ unreaded messages!", 5000);
				sendPlayerMessage(playerid, "[SMS] ��������� ����������.", COLOR_HEX_INFO);
				return true;
			}
			sendPlayerMessage(playerid, "[SMS] ��������� ����� ���������� ����� ������� ����� � ����.", COLOR_HEX_INFO);
			break;

		case "inbox":
			if(PlayerInfo[playerid].Phone == 0)
				return sendPlayerMessage(playerid, "������: �� �� ������ ��������!", COLOR_HEX_ERROR);
			local sms = sql.query_assoc("SELECT * FROM `phone_sms` WHERE `taker` = '"+PlayerInfo[playerid].Phone+"';");
			if(!sms || sms.len() < 1)
				return sendPlayerMessage(playerid, "��� ���������.", COLOR_HEX_INFO);
			sendPlayerMessage(playerid, "�������� ���������:", COLOR_HEX_WHITE);
			foreach(smsid, data in sms) {
				if(data.status == 0)
					sendPlayerMessage(playerid, "[�� ���������] "+(smsid+1)+". �����: "+data.sender+". �����: "+data.text, COLOR_HEX_INFO);
				else
					sendPlayerMessage(playerid, "[���������] "+(smsid+1)+". �����: "+data.sender+". �����: "+data.text, COLOR_HEX_INFO);
			}
			sql.query("UPDATE `phone_sms` SET `status` = '1' WHERE `taker` = '"+PlayerInfo[playerid].Phone+"' LIMIT "+sms.len()+";");
			break;

		case "outbox":
			if(PlayerInfo[playerid].Phone == 0)
				return sendPlayerMessage(playerid, "������: �� �� ������ ��������!", COLOR_HEX_ERROR);
			local sms = sql.query_assoc("SELECT * FROM `phone_sms` WHERE `sender` = '"+PlayerInfo[playerid].Phone+"';");
			if(!sms || sms.len() < 1)
				return sendPlayerMessage(playerid, "��� ���������.", COLOR_HEX_INFO);
			sendPlayerMessage(playerid, "��������� ���������:", COLOR_HEX_WHITE);
			foreach(smsid, data in sms) {
				if(data.status == 0)
					sendPlayerMessage(playerid, "[�� ����������] "+(smsid+1)+". �����: "+data.taker+". �����: "+data.text, COLOR_HEX_INFO);
				else
					sendPlayerMessage(playerid, "[����������] "+(smsid+1)+". �����: "+data.taker+". �����: "+data.text, COLOR_HEX_INFO);
			}
			break;

		case "call":
			if(PlayerInfo[playerid].Phone == 0)
				return sendPlayerMessage(playerid, "������: �� �� ������ ��������!", COLOR_HEX_ERROR);
			if(PlayerInfo[playerid].PhoneSpeakWith != -1)
				return sendPlayerMessage(playerid, "������: �� ��� �������� � ��� ���� �� ��������!", COLOR_HEX_ERROR);
			if(cmd.len() != 2)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/call [����� ��������]", COLOR_HEX_USE, true);
			if(PlayerInfo[playerid].Phone == cmd[1].tointeger())
				return sendPlayerMessage(playerid, "������: ������ ��������� ������ ����!", COLOR_HEX_ERROR);
			local query = sql.query_assoc("SELECT * FROM `characters` WHERE `phone` = '"+cmd[1].tointeger()+"' LIMIT 1;");
			if(!query || query.len() < 1)
				return sendPlayerMessage(playerid, "������: ����� �� ����������.", COLOR_HEX_ERROR);
			foreach(id, player in getPlayers()) {
				if(PlayerInfo[id].Logged != true)
					continue;
				if(PlayerInfo[id].Phone != cmd[1].tointeger())
					continue;
				if(PlayerInfo[id].PhoneSpeakWith != -1)
					return sendPlayerMessage(playerid, "������.", COLOR_HEX_INFO);
				PlayerInfo[playerid].PhoneSpeakWith = id;
				setPlayerUseMobilePhone(playerid, true);
				sendPlayerMessage(playerid, "[CALL] �� ��������� �� ������ "+PlayerInfo[id].Phone+", �������� ������ �� ������.", COLOR_HEX_INFO);
				sendPlayerMessage(id, "[CALL] ��� �������� ����� "+PlayerInfo[playerid].Phone+", ����������� '/p' ����� �������� ��� '/h' ����� ���������.", COLOR_HEX_INFO);
				return true;
			}
			date_info = date();
			local time = format("%02d.%02d.%02d %02d:%02d", date_info["day"], date_info["month"]+1, date_info["year"], date_info["hour"], date_info["min"]);
			sql.query("INSERT INTO `phone_sms` (`sender`,`taker`,`text`) VALUES ('"+PlayerInfo[playerid].Phone+"','"+cmd[1].tointeger()+"','���� ������� ������� ��� ��������� � "+time+".');");
			sendPlayerMessage(playerid, "[CALL] ������� �������� ��������.", COLOR_HEX_INFO);
			break;

		case "p":
			if(PlayerInfo[playerid].Phone == 0)
				return sendPlayerMessage(playerid, "������: �� �� ������ ��������!", COLOR_HEX_ERROR);
			if(PlayerInfo[playerid].PhoneSpeakWith != -1)
				return sendPlayerMessage(playerid, "������: �� ��� �������� � ��� ���� �� ��������!", COLOR_HEX_ERROR);
			foreach(id, player in getPlayers()) {
				if(PlayerInfo[id].PhoneSpeakWith != playerid)
					continue;
				PlayerInfo[playerid].PhoneSpeakWith = id;
				setPlayerUseMobilePhone(playerid, true);
				sendPlayerMessage(id, "���������� ������� �� ������.", COLOR_HEX_INFO);
				return true;
			}
			sendPlayerMessage(playerid, "������: ��� ����� �� ������!", COLOR_HEX_ERROR);
			break;

		case "h":
			if(PlayerInfo[playerid].Phone == 0)
				return sendPlayerMessage(playerid, "������: �� �� ������ ��������!", COLOR_HEX_ERROR);
			foreach(id, player in getPlayers()) {
				if(PlayerInfo[id].PhoneSpeakWith != playerid)
					continue;
				PlayerInfo[id].PhoneSpeakWith = -1;
				setPlayerUseMobilePhone(id, false);
				sendPlayerMessage(id, "���������� ������� ������.", COLOR_HEX_INFO);

				PlayerInfo[playerid].PhoneSpeakWith = -1;
				setPlayerUseMobilePhone(playerid, false);
				sendPlayerMessage(playerid, "�� �������� ������.", COLOR_HEX_INFO);
				return true;
			}
			if(PlayerInfo[playerid].PhoneSpeakWith == -1)
				return sendPlayerMessage(playerid, "������: �� �� �������� � ��� ���� �� ��������!", COLOR_HEX_ERROR);
			sendPlayerMessage(PlayerInfo[playerid].PhoneSpeakWith, "������� ������� ������.", COLOR_HEX_INFO);
			PlayerInfo[playerid].PhoneSpeakWith = -1;
			setPlayerUseMobilePhone(playerid, false);
			sendPlayerMessage(playerid, "�� �������� ������.", COLOR_HEX_INFO);
			break;

		case "stats":
			sendPlayerMessage(playerid, "|______________________________[FFFFFFFF]����������[33AA33FF]______________________________|", 0x33AA33FF, true);
			sendPlayerMessage(playerid, "| ��������: ��� [none], ������� ["+PlayerInfo[playerid].Age+"], ������ [none], ����� �������� ["+PlayerInfo[playerid].Phone+"].", 0x33AA33FF, true);
			sendPlayerMessage(playerid, "| ������: �������� [$"+PlayerInfo[playerid].Cash+"], ���������� ���� [$"+PlayerInfo[playerid].Bank+"], �������� [none].", 0x33AA33FF, true);
			sendPlayerMessage(playerid, "| ���������: ��� [0 ��.], ������ ["+GetPlayerBusinessCount(playerid)+" ��.], ��������� ["+GetPlayerVehicleCount(playerid)+" ��.].", 0x33AA33FF, true);
			sendPlayerMessage(playerid, "| �������: ����� ["+PlayerInfo[playerid].ID+"], ����� � ���� ["+PlayerInfo[playerid].Played_Hours+"], ���� [id"+PlayerInfo[playerid].Skin+"].", 0x33AA33FF, true);
			sendPlayerMessage(playerid, "|______________________________________________________________________|", 0x33AA33FF, true);
			break;

		case "biz":
			if(cmd.len() < 2) {
				sendPlayerMessage(playerid, "�����������: [33CCFFFF]/biz [��������]", COLOR_HEX_USE, true);
				sendPlayerMessage(playerid, "���������: buy, sell, actor, blip.", COLOR_HEX_INFO);
				if(PlayerInfo[playerid].Admin_Level != 0)
					sendPlayerMessage(playerid, "���������[A]: to, asell.", COLOR_HEX_INFO);
				return true;
			}
			switch(cmd[1]) {

				case "buy":
					local businessid = GetPlayerNearestBusiness(playerid, 15.0);
					if(businessid == -1)
						return sendPlayerMessage(playerid, "������: ����� � ���� ���� �������!", COLOR_HEX_ERROR);
					if(GetBusinessOwner(businessid) != false)
						return sendPlayerMessage(playerid, "������: ���� ������ ��� ������!", COLOR_HEX_ERROR);
					if(GetPlayerMoneyLegal(playerid) < BusinessInfo[businessid].Price)
						return sendPlayerMessage(playerid, "������: ������������ ����� ��� �������! ��������� $"+BusinessInfo[businessid].Price+".", COLOR_HEX_ERROR);
					SetBusinessOwner(businessid, getPlayerName(playerid));
					GivePlayerMoneyLegal(playerid, -BusinessInfo[businessid].Price);
					sendPlayerMessage(playerid, "�� ������� ������ ������ "+BusinessInfo[businessid].Name+" �� $"+BusinessInfo[businessid].Price+".", COLOR_HEX_INFO, true);
					break;

				case "sell":
					local businessid = GetPlayerNearestBusiness(playerid, 15.0);
					if(businessid == -1)
						return sendPlayerMessage(playerid, "������: �� ������� ������ �� �������!", COLOR_HEX_ERROR);
					if(!IsPlayerBusinessOwner(playerid, businessid))
						return sendPlayerMessage(playerid, "������: �� �� �������� ����� �������!", COLOR_HEX_ERROR);
					SetBusinessOwner(businessid, "None");
					GivePlayerMoneyLegal(playerid, BusinessInfo[businessid].Price);
					sendPlayerMessage(playerid, "�� ������� ������� ������ "+BusinessInfo[businessid].Name+" �� $"+BusinessInfo[businessid].Price+".", COLOR_HEX_INFO, true);
					break;

				case "asell":
					if(PlayerInfo[playerid].Admin_Level == 0)
						return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
					local businessid = GetPlayerNearestBusiness(playerid, 15.0);
					if(businessid == -1)
						return sendPlayerMessage(playerid, "������: �� ������� ������ �� �������!", COLOR_HEX_ERROR);
					if(GetBusinessOwner(businessid) == false)
						return sendPlayerMessage(playerid, "������: ���� ������ �� ����� ���������!", COLOR_HEX_ERROR);
					SetBusinessOwner(businessid, "None");
					sendPlayerMessage(playerid, "�� ������� ������� ������ "+BusinessInfo[businessid].Name+"["+businessid+"].", COLOR_HEX_INFO, true);
					break;

				case "actor":
					local businessid = GetPlayerNearestBusiness(playerid, 15.0);
					if(businessid == -1)
						return sendPlayerMessage(playerid, "������: �� ������� ������ �� �������!", COLOR_HEX_ERROR);
					if(!IsPlayerBusinessOwner(playerid, businessid))
						return sendPlayerMessage(playerid, "������: �� �� �������� ����� �������!", COLOR_HEX_ERROR);
					if(BusinessInfo[businessid].Actor_skin == -1)
						return sendPlayerMessage(playerid, "������: � ���� ������� ����������� �����!", COLOR_HEX_ERROR);
					if(cmd.len() < 3) {
						sendPlayerMessage(playerid, "�����������: [33CCFFFF]/biz actor [��������]", COLOR_HEX_USE, true);
						sendPlayerMessage(playerid, "���������: name, skin.", COLOR_HEX_INFO);
						return true;
					}
					switch(cmd[2]) {
						case "name": {
							if(cmd.len() < 4)
								return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/biz actor name [���]", COLOR_HEX_USE, true);
							if(cmd[3].len() > 32)
								return sendPlayerMessage(playerid, "������: ������������ ������ ����� - 32 �������!", COLOR_HEX_ERROR);
							BusinessInfo[businessid].Actor_name = cmd[3].tostring();
							setActorName(businessid, BusinessInfo[businessid].Actor_name);
							sendPlayerMessage(playerid, "�� ������� ������� ��� ������ �� '"+BusinessInfo[businessid].Actor_name+"'.", COLOR_HEX_INFO);
							break;
						}
						case "skin": {
							if(cmd.len() < 4)
								return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/biz actor skin [id �����]", COLOR_HEX_USE, true);
							if((cmd[3].tointeger() < 0) || (cmd[3].tointeger() > 345))
								return sendPlayerMessage(playerid, "������: �������� �������� id �����!", COLOR_HEX_ERROR);
							BusinessInfo[businessid].Actor_skin = cmd[3].tointeger();
							sendPlayerMessage(playerid, "�� ������� ������� ���� ������ �� '"+BusinessInfo[businessid].Actor_skin+"'.", COLOR_HEX_INFO);
							sendPlayerMessage(playerid, "��������� ������� � ���� ����� �������� �������.", COLOR_HEX_INFO);
							break;
						}
						default: {
							sendPlayerMessage(playerid, "�����������: [33CCFFFF]/biz actor [��������]", COLOR_HEX_USE, true);
							sendPlayerMessage(playerid, "���������: name, skin.", COLOR_HEX_INFO);
							break;
						}
					}
					break;

				case "blip":
					local businessid = GetPlayerNearestBusiness(playerid, 15.0);
					if(businessid == -1)
						return sendPlayerMessage(playerid, "������: �� ������� ������ �� �������!", COLOR_HEX_ERROR);
					if(!IsPlayerBusinessOwner(playerid, businessid))
						return sendPlayerMessage(playerid, "������: �� �� �������� ����� �������!", COLOR_HEX_ERROR);
					if(BusinessInfo[businessid].Blip_id == -1)
						return sendPlayerMessage(playerid, "������: � ���� ������� ����������� ������!", COLOR_HEX_ERROR);
						
					if(cmd.len() < 3) {
						sendPlayerMessage(playerid, "�����������: [33CCFFFF]/biz blip [��������]", COLOR_HEX_USE, true);
						sendPlayerMessage(playerid, "������ ������������ �� ����� � �������.", COLOR_HEX_INFO);
						sendPlayerMessage(playerid, "���������: name, model.", COLOR_HEX_INFO);
						return true;
					}
					switch(cmd[2]) {
						case "name":
							if(cmd.len() < 4)
								return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/biz blip name [��������]", COLOR_HEX_USE, true);
							BusinessInfo[businessid].Blip_name = cmd[3].tostring();
							setBlipName(businessid, BusinessInfo[businessid].Blip_name);
							sendPlayerMessage(playerid, "�� ������� ������� �������� ������ �� '"+BusinessInfo[businessid].Blip_name+"'.", COLOR_HEX_INFO);
							break;
						case "model":
							if(cmd.len() < 4)
								return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/biz blip model [id ������]", COLOR_HEX_USE, true);
							if((cmd[3].tointeger() < 0) || (cmd[3].tointeger() > 94))
								return sendPlayerMessage(playerid, "������: �������� �������� id ������!", COLOR_HEX_ERROR);
							BusinessInfo[businessid].Blip_id = cmd[3].tointeger();
							sendPlayerMessage(playerid, "�� ������� ������� id ������ �� '"+BusinessInfo[businessid].Blip_id+"'.", COLOR_HEX_INFO);
							sendPlayerMessage(playerid, "��������� ������� � ���� ����� �������� �������.", COLOR_HEX_INFO);
							break;
						default:
							sendPlayerMessage(playerid, "�����������: [33CCFFFF]/biz blip [��������]", COLOR_HEX_USE, true);
							sendPlayerMessage(playerid, "���������: name, model.", COLOR_HEX_INFO);
							break;
					}
					break;

				case "to":
					if(PlayerInfo[playerid].Admin_Level == 0)
						return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
					if(cmd.len() != 3)
						return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/biz to [id �������]", COLOR_HEX_USE, true);
					local businessid = cmd[2].tointeger();
					if((businessid < 0) || (businessid > total_businesses))
						return sendPlayerMessage(playerid, "������: �������� �������� id �������!", COLOR_HEX_ERROR);
					setPlayerPosition(playerid, BusinessInfo[businessid].Actor_pos_x, BusinessInfo[businessid].Actor_pos_y, BusinessInfo[businessid].Actor_pos_z+2);
					setPlayerHeading(playerid, BusinessInfo[businessid].Actor_pos_fa);
					setCameraBehindPlayer(playerid);
					sendPlayerMessage(playerid, "�� ��������������� ���� � ������� "+BusinessInfo[businessid].Name+"["+businessid+"].", COLOR_HEX_INFO, true);
					sendPlayerMessage(playerid, "��������: "+BusinessInfo[businessid].Owner+". ����: "+BusinessInfo[businessid].Price+"", COLOR_HEX_INFO, true);
					break;

				default:
					onPlayerCommand(playerid, "/"+cmd[0]);
					break;
			}
			break;

		case "v":
			if(cmd.len() < 2) {
				sendPlayerMessage(playerid, "�����������: [33CCFFFF]/v [��������]", COLOR_HEX_USE, true);
				sendPlayerMessage(playerid, "���������: buy, sell, scrap, fix, givekey, takekey, dropkey.", COLOR_HEX_INFO);
				sendPlayerMessage(playerid, "���������: lock, engine, lights, blinks, lblink, rblink.", COLOR_HEX_INFO);
				sendPlayerMessage(playerid, "���������: fix, fill, wash, color.", COLOR_HEX_INFO);
				if(PlayerInfo[playerid].Admin_Level != 0)
					sendPlayerMessage(playerid, "���������[A]: to, asell.", COLOR_HEX_INFO);
				return true;
			}
			switch(cmd[1]) {
				case "lock":
					onPlayerTurnVehicleLock(playerid);
					break;
				case "engine":
					onPlayerTurnVehicleEngine(playerid);
					break;
				case "lights":
					onPlayerTurnVehicleLights(playerid);
					break;
				case "blinks":
					onPlayerTurnVehicleBlinks(playerid);
					break;
				case "lblink":
					onPlayerTurnVehicleLeftBlink(playerid);
					break;
				case "rblink":
					onPlayerTurnVehicleRightBlink(playerid);
					break;

				case "fix":
					if(!isPlayerInAnyVehicle(playerid))
						return sendPlayerMessage(playerid, "������: ������� ����� ������������ ������ � ����������!", COLOR_HEX_ERROR);
					local vehicleid = getPlayerVehicleId(playerid);
					sendPlayerMessage(playerid, "�� ������� �������� ��� ���������!", COLOR_HEX_INFO);
					sendPlayerMessage(playerid, "[Debug] ���� "+getVehicleHealth(vehicleid)+", ����� 1000 ������ ��������.", COLOR_HEX_INFO);
					setVehicleHealth(vehicleid, 1000);
					repairVehicleWindows(vehicleid);
					repairVehicleWheels(vehicleid);
					break;

				case "fill":
					if(!isPlayerInAnyVehicle(playerid))
						return sendPlayerMessage(playerid, "������: ������� ����� ������������ ������ � ����������!", COLOR_HEX_ERROR);
					local vehicleid = getPlayerVehicleId(playerid);
					sendPlayerMessage(playerid, "�� ������� ��������� ��� ���������!", COLOR_HEX_INFO);
					sendPlayerMessage(playerid, "[Debug] ���� "+VehicleInfo[vehicleid].Fuel+", ����� 10000 ������ �������.", COLOR_HEX_INFO);
					VehicleInfo[vehicleid].Fuel = 10000;
					break;

				case "wash":
					if(!isPlayerInAnyVehicle(playerid))
						return sendPlayerMessage(playerid, "������: ������� ����� ������������ ������ � ����������!", COLOR_HEX_ERROR);
					local vehicleid = getPlayerVehicleId(playerid);
					sendPlayerMessage(playerid, "�� ������� ������ ��� ���������!", COLOR_HEX_INFO);
					sendPlayerMessage(playerid, "[Debug] ���� "+getVehicleDirtLevel(vehicleid)+", ����� 0.0 ������ �����.", COLOR_HEX_INFO);
					setVehicleDirtLevel(vehicleid, 0.0);
					break;

				case "color":
					if(!isPlayerInAnyVehicle(playerid))
						return sendPlayerMessage(playerid, "������: ������� ����� ������������ ������ � ����������!", COLOR_HEX_ERROR);
					local vehicleid = getPlayerVehicleId(playerid);
					if(cmd.len() != 6)
						return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/v color [����1] [����2] [����3] [����4]", COLOR_HEX_USE, true);
					if((cmd[2].tointeger() < 0) || (cmd[2].tointeger() > 136)) return sendPlayerMessage(playerid, "������: �������� �������� ������� �����!", COLOR_HEX_ERROR);
					if((cmd[3].tointeger() < 0) || (cmd[3].tointeger() > 136)) return sendPlayerMessage(playerid, "������: �������� �������� ������� �����!", COLOR_HEX_ERROR);
					if((cmd[4].tointeger() < 0) || (cmd[4].tointeger() > 136)) return sendPlayerMessage(playerid, "������: �������� �������� �������� �����!", COLOR_HEX_ERROR);
					if((cmd[5].tointeger() < 0) || (cmd[5].tointeger() > 136)) return sendPlayerMessage(playerid, "������: �������� �������� ���������� �����!", COLOR_HEX_ERROR);
					sendPlayerMessage(playerid, "�� ������� ����������� ��� ���������!", COLOR_HEX_INFO);
					setVehicleColor(vehicleid, cmd[2].tointeger(), cmd[3].tointeger(), cmd[4].tointeger(), cmd[5].tointeger());
					break;

				case "buy":
					sendPlayerMessage(playerid, "������: ������� ��������� � ����������!", COLOR_HEX_ERROR);
					break;
				case "sell":
					sendPlayerMessage(playerid, "������: ������� ��������� � ����������!", COLOR_HEX_ERROR);
					break;
				case "scrap":
					sendPlayerMessage(playerid, "������: ������� ��������� � ����������!", COLOR_HEX_ERROR);
					break;
				case "givekey":
					sendPlayerMessage(playerid, "������: ������� ��������� � ����������!", COLOR_HEX_ERROR);
					break;
				case "takekey":
					sendPlayerMessage(playerid, "������: ������� ��������� � ����������!", COLOR_HEX_ERROR);
					break;
				case "dropkey":
					sendPlayerMessage(playerid, "������: ������� ��������� � ����������!", COLOR_HEX_ERROR);
					break;

				case "to":
					if(PlayerInfo[playerid].Admin_Level == 0)
						return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
					sendPlayerMessage(playerid, "������: ������� ��������� � ����������!", COLOR_HEX_ERROR);
					break;
				case "asell":
					if(PlayerInfo[playerid].Admin_Level == 0)
						return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
					sendPlayerMessage(playerid, "������: ������� ��������� � ����������!", COLOR_HEX_ERROR);
					break;
				default:
					onPlayerCommand(playerid, "/"+cmd[0]);
					break;
			}
			break;

		case "eject":
			if(!isPlayerInAnyVehicle(playerid))
				return sendPlayerMessage(playerid, "������: ������� ����� ������������ ������ � ����������!", COLOR_HEX_ERROR);
			if(cmd.len() != 2)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/eject [id ������]", COLOR_HEX_USE, true);
			if(!isPlayerConnected(cmd[1].tointeger()))
				return sendPlayerMessage(playerid, "������: �������� id ������!", COLOR_HEX_ERROR);
			if(cmd[1].tointeger() == playerid)
				return sendPlayerMessage(playerid, "������: ������ �������� ������ ����!", COLOR_HEX_ERROR);
			if(!isPlayerInVehicle(cmd[1].tointeger(), getPlayerVehicleId(playerid)))
				return sendPlayerMessage(playerid, "������: ��������� ����� �� � ����� ����������!", COLOR_HEX_ERROR);
			PlayerBigAction(playerid, "������� "+getPlayerName(cmd[1].tointeger())+" �� ����������");
			removePlayerFromVehicle(cmd[1].tointeger(), true);
			break;

		case "b":
			if(cmd.len() < 2)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/b [�����]", COLOR_HEX_USE, true);
			PlayerChatOOC(playerid, command.slice(cmd[0].len()+2, command.len()));
			break;

		case "w":
			if(cmd.len() < 2)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/w [�����]", COLOR_HEX_USE, true);
			PlayerChatWhisper(playerid, command.slice(cmd[0].len()+2, command.len()));
			break;

		case "s":
			if(cmd.len() < 2)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/s [�����]", COLOR_HEX_USE, true);
			PlayerChatShout(playerid, command.slice(cmd[0].len()+2, command.len()));
			break;

		case "me":
			if(cmd.len() < 2)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/me [��������]", COLOR_HEX_USE, true);
			PlayerBigAction(playerid, command.slice(cmd[0].len()+2, command.len()));
			break;

		case "do":
			if(cmd.len() < 2)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/do [��������]", COLOR_HEX_USE, true);
			PlayerBigAction3rd(playerid, command.slice(cmd[0].len()+2, command.len()));
			break;

		case "ad":
			if(cmd.len() < 2)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/ad [�����]", COLOR_HEX_USE, true);
			local text = command.slice(cmd[0].len()+2, command.len());
			local payout = text.len() * 10;
			if(GetPlayerMoneyLegal(playerid) < payout)
				return sendPlayerMessage(playerid, "������: ������������ ����� ��� ������! ��������� $"+payout+".", COLOR_HEX_ERROR);
			GivePlayerMoneyLegal(playerid, -payout);
			sendMessageToAll("����������: "+text+". �������: none.", COLOR_HEX_ADVERT, true);
			SendMessageToAdmin("�����: "+getPlayerName(playerid)+"["+playerid+"]", COLOR_HEX_INFO);
			break;

		case "pay":
			if(PlayerInfo[playerid].Played_Hours <= 6)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ����� ����� ����� ����!", COLOR_HEX_ERROR);
			if(cmd.len() != 3)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/pay [id ������] [�����]", COLOR_HEX_USE, true);
			if(!isPlayerConnected(cmd[1].tointeger()))
				return sendPlayerMessage(playerid, "������: �������� id ������!", COLOR_HEX_ERROR);
			if(GetDistanceBetweenPlayers(playerid, cmd[1].tointeger()) > 20.0)
				return sendPlayerMessage(playerid, "������: ����� ������� ������ �� ���!", COLOR_HEX_ERROR);
			if((cmd[2].tointeger() < 1) || (cmd[2].tointeger() > GetPlayerMoneyLegal(playerid)))
				return sendPlayerMessage(playerid, "������: �������� �������� ����� �����!", COLOR_HEX_ERROR);
			sendPlayerMessage(cmd[1].tointeger(), "�� �������� $"+cmd[2].tointeger()+" �� ������ "+getPlayerName(playerid)+"["+playerid+"].", COLOR_HEX_INFO, true);
			sendPlayerMessage(playerid, "�� �������� $"+cmd[2].tointeger()+" ������ "+getPlayerName(cmd[1].tointeger())+"["+cmd[1].tointeger()+"].", COLOR_HEX_INFO, true);
			PlayerBigAction(playerid, "������� ������ � ���� "+getPlayerName(cmd[1].tointeger()));
			GivePlayerMoneyLegal(cmd[1].tointeger(), cmd[2].tointeger());
			GivePlayerMoneyLegal(playerid, -cmd[2].tointeger());
			break;

		case "makeadmin":
			if(PlayerInfo[playerid].Admin_Level != 10)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������� ������������� ������� �������!", COLOR_HEX_ERROR);
			if(cmd.len() != 3)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/makeadmin [id ������] [�������]", COLOR_HEX_USE, true);
			if(!isPlayerConnected(cmd[1].tointeger()))
				return sendPlayerMessage(playerid, "������: �������� id ������!", COLOR_HEX_ERROR);
			if((cmd[2].tointeger() < 0) || (cmd[2].tointeger() > 10))
				return sendPlayerMessage(playerid, "������: �������� �������� ������ ��������������!", COLOR_HEX_ERROR);
			sendPlayerMessage(cmd[1].tointeger(), "������������� "+getPlayerName(playerid)+"["+playerid+"] ������� ��� ������� �������������� �� "+cmd[2].tointeger()+".", COLOR_HEX_INFO, true);
			sendPlayerMessage(playerid, "�� �������� ������� �������������� ������ "+getPlayerName(cmd[1].tointeger())+"["+cmd[1].tointeger()+"] �� "+cmd[2].tointeger()+".", COLOR_HEX_INFO, true);
			PlayerInfo[cmd[1].tointeger()].Admin_Level = cmd[2].tointeger();
			break;

		case "a":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			if(cmd.len() < 2)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/a [�����]", COLOR_HEX_USE, true);
			SendMessageToAdmin("Administrator "+getPlayerName(playerid)+"["+playerid+"]: "+command.slice(cmd[0].len()+2, command.len())+"", COLOR_HEX_INFO);
			break;

		case "o":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			if(cmd.len() < 2)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/o [�����]", COLOR_HEX_USE, true);
			sendMessageToAll("�������������� "+getPlayerName(playerid)+": "+command.slice(cmd[0].len()+2, command.len())+"", COLOR_HEX_MAIN, true);
			break;

		case "report":
			if(cmd.len() < 2)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/report [�����]", COLOR_HEX_USE, true);
			if(GetOnlineAdminsCount() <= 0)
				return sendPlayerMessage(playerid, "������: ���� ��������������� ������!", COLOR_HEX_ERROR);
			SendMessageToAdmin("��������� �� "+getPlayerName(playerid)+"["+playerid+"]: "+command.slice(cmd[0].len()+2, command.len())+"", COLOR_HEX_REPORT);
			sendPlayerMessage(playerid, "���� ��������� ���� ���������� �������������.", COLOR_HEX_INFO);
			break;

		case "answer":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			if(cmd.len() < 3)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/answer [id ������] [�����]", COLOR_HEX_USE, true);
			if(!isPlayerConnected(cmd[1].tointeger()))
				return sendPlayerMessage(playerid, "������: �������� id ������!", COLOR_HEX_ERROR);
			local text = command.slice(cmd[0].len()+cmd[1].len()+3, command.len());
			sendPlayerMessage(cmd[1].tointeger(), "������������� "+getPlayerName(playerid)+"["+playerid+"] ��������: "+text+"", COLOR_HEX_ANSWER, true);
			SendMessageToAdmin("������������� "+getPlayerName(playerid)+"["+playerid+"] ������� "+getPlayerName(cmd[1].tointeger())+"["+cmd[1].tointeger()+"]: "+text+"", COLOR_HEX_ANSWER);
			break;

		case "cc":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			for(local i = 1; i <= 40; i++) {
				sendMessageToAll("", COLOR_HEX_WHITE);
			}
			sendMessageToAll("��� ��� ������ ��������������� "+getPlayerName(playerid)+"["+playerid+"].", COLOR_HEX_ADMINACT, true);
			break;

		case "ip":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			if(cmd.len() != 2)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/ip [id ������]", COLOR_HEX_USE, true);
			if(!isPlayerConnected(cmd[1].tointeger()))
				return sendPlayerMessage(playerid, "������: �������� id ������!", COLOR_HEX_ERROR);
			sendPlayerMessage(playerid, ""+getPlayerName(cmd[1].tointeger())+"["+cmd[1].tointeger()+"] - "+getPlayerIp(cmd[1].tointeger())+"", COLOR_HEX_INFO, true);
			break;

		case "to":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			if(cmd.len() != 2)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/to [id ������]", COLOR_HEX_USE, true);
			if(!isPlayerConnected(cmd[1].tointeger()))
				return sendPlayerMessage(playerid, "������: �������� id ������!", COLOR_HEX_ERROR);
			local position = getPlayerCoordinates(cmd[1].tointeger());
			setPlayerPosition(playerid, position[0], position[1], position[2]+2);
			setPlayerInterior(playerid, getPlayerInterior(cmd[1].tointeger()));
			sendPlayerMessage(playerid, "�� ��������������� ���� � ������ "+getPlayerName(cmd[1].tointeger())+"["+cmd[1].tointeger()+"].", COLOR_HEX_INFO, true);
			break;

		case "tp":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			if(cmd.len() != 2)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/tp [id ������]", COLOR_HEX_USE, true);
			if(!isPlayerConnected(cmd[1].tointeger()))
				return sendPlayerMessage(playerid, "������: �������� id ������!", COLOR_HEX_ERROR);
			local position = getPlayerCoordinates(playerid);
			setPlayerPosition(cmd[1].tointeger(), position[0], position[1], position[2]+2);
			setPlayerInterior(cmd[1].tointeger(), getPlayerInterior(playerid));
			sendPlayerMessage(cmd[1].tointeger(), "������������� "+getPlayerName(playerid)+"["+playerid+"] �������������� ��� � ����.", COLOR_HEX_INFO, true);
			sendPlayerMessage(playerid, "�� ��������������� � ���� ������ "+getPlayerName(cmd[1].tointeger())+"["+cmd[1].tointeger()+"].", COLOR_HEX_INFO, true);
			break;

		case "hp":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			if(cmd.len() != 3)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/hp [id ������] [����������]", COLOR_HEX_USE, true);
			if(!isPlayerConnected(cmd[1].tointeger()))
				return sendPlayerMessage(playerid, "������: �������� id ������!", COLOR_HEX_ERROR);
			if((cmd[2].tointeger() < -1) || (cmd[2].tointeger() > 100))
				return sendPlayerMessage(playerid, "������: �������� �������� ���������� ������!", COLOR_HEX_ERROR);
			sendPlayerMessage(cmd[1].tointeger(), "������������� "+getPlayerName(playerid)+"["+playerid+"] ������� ���������� ����� ������ �� "+cmd[2].tointeger()+" ������.", COLOR_HEX_INFO, true);
			sendPlayerMessage(playerid, "�� �������� ���������� ������ ������ "+getPlayerName(cmd[1].tointeger())+"["+cmd[1].tointeger()+"] �� "+cmd[2].tointeger()+" ������.", COLOR_HEX_INFO, true);
			setPlayerHealth(cmd[1].tointeger(), cmd[2].tointeger());
			break;

		case "arm":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			if(cmd.len() != 3)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/arm [id ������] [����������]", COLOR_HEX_USE, true);
			if(!isPlayerConnected(cmd[1].tointeger()))
				return sendPlayerMessage(playerid, "������: �������� id ������!", COLOR_HEX_ERROR);
			if((cmd[2].tointeger() < 0) || (cmd[2].tointeger() > 100))
				return sendPlayerMessage(playerid, "������: �������� �������� ���������� �����!", COLOR_HEX_ERROR);
			sendPlayerMessage(cmd[1].tointeger(), "������������� "+getPlayerName(playerid)+"["+playerid+"] ������� ���������� ����� ����� �� "+cmd[2].tointeger()+" ������.", COLOR_HEX_INFO, true);
			sendPlayerMessage(playerid, "�� �������� ���������� ����� ������ "+getPlayerName(cmd[1].tointeger())+"["+cmd[1].tointeger()+"] �� "+cmd[2].tointeger()+" ������.", COLOR_HEX_INFO, true);
			setPlayerArmour(cmd[1].tointeger(), cmd[2].tointeger());
			break;

		case "gun":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			if(cmd.len() != 4) {
				sendPlayerMessage(playerid, "�����������: [33CCFFFF]/gun [id ������] [id ������] [���-�� ��������]", COLOR_HEX_USE, true);
				sendPlayerMessage(playerid, "Baseball Bat(1), Pool Cue(2), Knife(3), Grenade(4), Molotov(5)", COLOR_HEX_INFO);
				sendPlayerMessage(playerid, "Glock(7), Deagle(9), Pump Shotgun(10), Remingthon(11), Micro-SMG(12), SMG(13)", COLOR_HEX_INFO);
				sendPlayerMessage(playerid, "AK-47(14), M4A1(15), Sniper Rifle(16), Rifle(17), Rocket Launcher(18)", COLOR_HEX_INFO);
				return 1;
			}
			if(!isPlayerConnected(cmd[1].tointeger()))
				return sendPlayerMessage(playerid, "������: �������� id ������!", COLOR_HEX_ERROR);
			if((cmd[2].tointeger() < 1) || (cmd[2].tointeger() > 18) || (cmd[2].tointeger() == 6) || (cmd[2].tointeger() == 8))
				return sendPlayerMessage(playerid, "������: �������� �������� id ������!", COLOR_HEX_ERROR);
			if((cmd[3].tointeger() < 0) || (cmd[3].tointeger() > 9999))
				return sendPlayerMessage(playerid, "������: �������� �������� ���������� ��������!", COLOR_HEX_ERROR);
			sendPlayerMessage(cmd[1].tointeger(), "������������� "+getPlayerName(playerid)+"["+playerid+"] ��� ��� ������ "+WeaponNames[cmd[2].tointeger()]+"("+cmd[3].tointeger()+"��).", COLOR_HEX_INFO, true);
			sendPlayerMessage(playerid, "�� ���� ������ "+getPlayerName(cmd[1].tointeger())+"["+cmd[1].tointeger()+"] ������ "+WeaponNames[cmd[2].tointeger()]+"("+cmd[3].tointeger()+"��).", COLOR_HEX_INFO, true);
			givePlayerWeapon(cmd[1].tointeger(), cmd[2].tointeger(), cmd[3].tointeger());
			break;

		case "car":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			if(isPlayerInAnyVehicle(playerid))
				return sendPlayerMessage(playerid, "������: ������ ������������ ��� ������� �������� � ����������!", COLOR_HEX_ERROR);
			if(cmd.len() != 6)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/car [id ������] [����1] [����2] [����3] [����4]", COLOR_HEX_USE, true);
			if((cmd[1].tointeger() < 0) || (cmd[1].tointeger() > 123) || (cmd[1].tointeger() == 41) || (cmd[1].tointeger() == 96) || (cmd[1].tointeger() == 107) || (cmd[1].tointeger() == 111))
				return sendPlayerMessage(playerid, "������: �������� �������� id ������!", COLOR_HEX_ERROR);
			if((cmd[2].tointeger() < 0) || (cmd[2].tointeger() > 136)) return sendPlayerMessage(playerid, "������: �������� �������� ������� �����!", COLOR_HEX_ERROR);
			if((cmd[3].tointeger() < 0) || (cmd[3].tointeger() > 136)) return sendPlayerMessage(playerid, "������: �������� �������� ������� �����!", COLOR_HEX_ERROR);
			if((cmd[4].tointeger() < 0) || (cmd[4].tointeger() > 136)) return sendPlayerMessage(playerid, "������: �������� �������� �������� �����!", COLOR_HEX_ERROR);
			if((cmd[5].tointeger() < 0) || (cmd[5].tointeger() > 136)) return sendPlayerMessage(playerid, "������: �������� �������� ���������� �����!", COLOR_HEX_ERROR);
			local position = getPlayerCoordinates(playerid);
			local heading = getPlayerHeading(playerid);
			local vehicle = createVehicle(cmd[1].tointeger(), position[0], position[1], position[2], 0.0, 0.0, heading, cmd[2].tointeger(),cmd[3].tointeger(),cmd[4].tointeger(),cmd[5].tointeger());
			if(vehicle != INVALID_VEHICLE_ID)
				warpPlayerIntoVehicle(playerid, vehicle);
			sendPlayerMessage(playerid, "�� ������� ��������� - "+getVehicleName(cmd[1].tointeger())+"["+vehicle+"].", COLOR_HEX_INFO);
			break;

		case "skin":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			if(cmd.len() != 3)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/skin [id ������] [id �����]", COLOR_HEX_USE, true);
			if(!isPlayerConnected(cmd[1].tointeger()))
				return sendPlayerMessage(playerid, "������: �������� id ������!", COLOR_HEX_ERROR);
			if((cmd[2].tointeger() < 0) || (cmd[2].tointeger() > 345))
				return sendPlayerMessage(playerid, "������: �������� �������� id �����!", COLOR_HEX_ERROR);
			sendPlayerMessage(cmd[1].tointeger(), "������������� "+getPlayerName(playerid)+"["+playerid+"] ������� ��� ���� �� id"+cmd[2].tointeger()+".", COLOR_HEX_INFO, true);
			sendPlayerMessage(playerid, "�� �������� ���� ������ "+getPlayerName(cmd[1].tointeger())+"["+cmd[1].tointeger()+"] �� id"+cmd[2].tointeger()+".", COLOR_HEX_INFO, true);
			PlayerInfo[cmd[1].tointeger()].Skin = cmd[2].tointeger();
			setPlayerModel(cmd[1].tointeger(), PlayerInfo[cmd[1].tointeger()].Skin);
			break;

		case "kick":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			if(cmd.len() < 2)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/kick [id ������] [�������]", COLOR_HEX_USE, true);
			if(!isPlayerConnected(cmd[1].tointeger()))
				return sendPlayerMessage(playerid, "������: �������� id ������!", COLOR_HEX_ERROR);

			if(cmd.len() == 2) {
				sendMessageToAll("������������� "+getPlayerName(playerid)+"["+playerid+"] ������ ������ "+getPlayerName(cmd[1].tointeger())+"["+cmd[1].tointeger()+"].", COLOR_HEX_ADMINACT, true);
				kickPlayer(cmd[1].tointeger(), true);
			}
			else if(cmd.len() == 3) {
				sendMessageToAll("������������� "+getPlayerName(playerid)+"["+playerid+"] ������ ������ "+getPlayerName(cmd[1].tointeger())+"["+cmd[1].tointeger()+"]. �������: "+command.slice(cmd[0].len()+cmd[1].len()+3, command.len())+".", COLOR_HEX_ADMINACT, true);
				kickPlayer(cmd[1].tointeger(), true);
			}
			break;

		case "banip":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			if(cmd.len() < 2)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/banip [id ������] [���-�� ����] [�������]", COLOR_HEX_USE, true);
			if(!isPlayerConnected(cmd[1].tointeger()))
				return sendPlayerMessage(playerid, "������: �������� id ������!", COLOR_HEX_ERROR);

			if(cmd.len() == 2) {
				sendMessageToAll("������������� "+getPlayerName(playerid)+"["+playerid+"] ������� ip ������ "+getPlayerName(cmd[1].tointeger())+"["+getPlayerIp(cmd[1].tointeger())+"].", COLOR_HEX_ADMINACT, true);
				banPlayer(cmd[1].tointeger(), 0);
			}
			else if(cmd.len() == 3) {
				if(cmd[2].tointeger() < 0)
					return sendPlayerMessage(playerid, "������: �������� �������� ���������� ����!", COLOR_HEX_ERROR);
				sendMessageToAll("������������� "+getPlayerName(playerid)+"["+playerid+"] ������� ip ������ "+getPlayerName(cmd[1].tointeger())+"["+getPlayerIp(cmd[1].tointeger())+"] �� "+cmd[2].tointeger()+" ����.", COLOR_HEX_ADMINACT, true);
				banPlayer(cmd[1].tointeger(), (cmd[2].tointeger() * 86400));
			}
			else if(cmd.len() == 4) {
				if(cmd[2].tointeger() < 0)
					return sendPlayerMessage(playerid, "������: �������� �������� ���������� ����!", COLOR_HEX_ERROR);
				sendMessageToAll("������������� "+getPlayerName(playerid)+"["+playerid+"] ������� ip ������ "+getPlayerName(cmd[1].tointeger())+"["+getPlayerIp(cmd[1].tointeger())+"] �� "+cmd[2].tointeger()+" ����. �������: "+cmd[3].tostring()+".", COLOR_HEX_ADMINACT, true);
				banPlayer(cmd[1].tointeger(), (cmd[2].tointeger() * 86400));
			}
			break;

		case "money":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			if(cmd.len() != 3)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/money [id ������] [���-��]", COLOR_HEX_USE, true);
			if(!isPlayerConnected(cmd[1].tointeger()))
				return sendPlayerMessage(playerid, "������: �������� id ������!", COLOR_HEX_ERROR);
			sendPlayerMessage(cmd[1].tointeger(), "������������� "+getPlayerName(playerid)+"["+playerid+"] ������� ���������� ����� ����� �� $"+cmd[2].tointeger()+".", COLOR_HEX_INFO);
			sendPlayerMessage(playerid, "�� �������� ���������� ����� ������ "+getPlayerName(cmd[1].tointeger())+"["+cmd[1].tointeger()+"] �� $"+cmd[2].tointeger()+".", COLOR_HEX_INFO);
			ResetPlayerMoneyLegal(cmd[1].tointeger());
			GivePlayerMoneyLegal(cmd[1].tointeger(), cmd[2].tointeger() );
			break;

		case "weather":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			if(cmd.len() != 2)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/weather [id ������]", COLOR_HEX_USE, true);
			if((cmd[1].tointeger() < 1) || (cmd[1].tointeger() > 10))
				return sendPlayerMessage(playerid, "������: �������� id ������!", COLOR_HEX_ERROR);
			sendPlayerMessage(playerid, "�� �������� ������ �� id"+cmd[1].tointeger()+".", COLOR_HEX_INFO, true);
			setWeather(cmd[1].tointeger());
			break;

		case "interior":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			if(cmd.len() != 2) {
				sendPlayerMessage(playerid, "�����������: [33CCFFFF]/interior [����� ���������]", COLOR_HEX_USE, true);
				sendPlayerMessage(playerid, "Brucie's Apartment(1), Church(2), Druzilla Restarunt(3), Faustin Basement(4), Police Station(5)", COLOR_HEX_INFO);
				sendPlayerMessage(playerid, "Hospital(6), Comedy Club(7), Comareds Bar(8), Lawyers Office(9), Dwanye Appartment(10)", COLOR_HEX_INFO);
				sendPlayerMessage(playerid, "Sprunk WareHouse(11), Appartment(12), Roman Cab Office(13), Office(14), Appartment(15)", COLOR_HEX_INFO);
				sendPlayerMessage(playerid, "Perestroika Club(16), Mr Fux Rice Box(17), Honkers StripClub(18), Appartment(19), Brucie's Garage(20)", COLOR_HEX_INFO);
				sendPlayerMessage(playerid, "Office(21), Prison(22), Elizabeta's Appartment(23), Faustin House(24), Office(25)", COLOR_HEX_INFO);
				sendPlayerMessage(playerid, "LJ Appartment(26), McReary House(27), Appartment(28), Appartment(29), Community Building(30)", COLOR_HEX_INFO);
				sendPlayerMessage(playerid, "Michelle's Appartment(31), Pegorino's House(32).", COLOR_HEX_INFO);
				return true;
			}
			switch(cmd[1].tointeger()) {
				case 1:
					setPlayerCoordinates(playerid, 807.045654, 146.646866, 29.242722);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Brucie's Apartment", 5000);
					break;
				case 2:
					setPlayerCoordinates(playerid, -286.717987, -282.356995, 15.631811);
					displayPlayerText(playerid, 0.3, 0.8, "~y~Church", 5000);
					break;
				case 3:
					setPlayerCoordinates(playerid, -113.032639, -261.945282, 13.102515);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Druzilla Restarunt", 5000);
					break;
				case 4:
					setPlayerCoordinates(playerid, 1304.384521, -855.959045, 5.489887);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Faustin Basement", 5000);
					break;
				case 5:
					setPlayerCoordinates(playerid, -406.440399, 287.515106, 13.681234);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Police Station", 5000);
					break;
				case 6:
					setPlayerCoordinates(playerid, 1241.307251, 192.980057, 33.553371);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Hospital", 5000);
					break;
				case 7:
					setPlayerCoordinates(playerid, -334.515991, 175.104080, 19.079556);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Comedy Club", 5000);
					break;
				case 8:
					setPlayerCoordinates(playerid, 935.394714, -492.142120, 15.489682);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Comareds Bar", 5000);
					break;
				case 9:
					setPlayerCoordinates(playerid, 98.025024, -682.845154, 14.771731);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Lawyers Office", 5000);
					break;
				case 10:
					setPlayerCoordinates(playerid, -129.627701, 1497.820190, 22.782167);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Dwanye Appartment", 5000);
					break;
				case 11:
					setPlayerCoordinates(playerid, 724.560120, 1458.814331, 14.852851);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Sprunk WareHouse", 5000);
					break;
				case 12:
					setPlayerCoordinates(playerid, -137.309143, 1382.047974, 32.801914);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Appartment", 5000);
					break;
				case 13:
					setPlayerCoordinates(playerid, 819.386, -259.157, 15.3428);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Roman Cab Office", 5000);
					break;
				case 14:
					setPlayerCoordinates(playerid, -84.7422, 51.461, 75.9529);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Office", 5000);
					break;
				case 15:
					setPlayerCoordinates(playerid, 98.691, 855.138, 45.051);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Appartment", 5000);
					break;
				case 16:
					setPlayerCoordinates(playerid, 956.784, -276.903, 18.129);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Perestroika Club", 5000);
					break;
				case 17:
					setPlayerCoordinates(playerid, -1239.96, 1074.79, 19.7854);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Mr Fux Rice Box", 5000);
					break;
				case 18:
					setPlayerCoordinates(playerid, -1579.35, 17.9494, 10.0153);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Honkers StripClub", 5000);
					break;
				case 19:
					setPlayerCoordinates(playerid, 1371.47, 207.525, 35.6886);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Appartment", 5000);
					break;
				case 20:
					setPlayerCoordinates(playerid, 878.024, -113.133, 6.0054);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Brucie's Garage", 5000);
					break;
				case 21:
					setPlayerCoordinates(playerid, -1153.35, 417.445, 5.57775);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Office", 5000);
					break;
				case 22:
					setPlayerCoordinates(playerid, -1084.55, -362.672, 7.4039);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Prison", 5000);
					break;
				case 23:
					setPlayerCoordinates(playerid, 356.262, 1519.36, 21.4326);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Elizabeta's Appartment", 5000);
					break;
				case 24:
					setPlayerCoordinates(playerid, 1314.93, -846.035, 8.87375);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Faustin House", 5000);
					break;
				case 25:
					setPlayerCoordinates(playerid, -407.671, 286.244, 18.5921);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Office", 5000);
					break;
				case 26:
					setPlayerCoordinates(playerid, 1331.4, 126.6, 36.558);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~LJ Appartment", 5000);
					break;
				case 27:
					setPlayerCoordinates(playerid, 1385.54, 618.12, 35.8574);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~McReary House", 5000);
					break;
				case 28:
					setPlayerCoordinates(playerid, -1246.62, 1543.05, 26.0688);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Appartment", 5000);
					break;
				case 29:
					setPlayerCoordinates(playerid, -547.07, 1245.06, 97.5396);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Appartment", 5000);
					break;
				case 30:
					setPlayerCoordinates(playerid, 390.665, 1485.81, 11.8339);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Community Building", 5000);
					break;
				case 31:
					setPlayerCoordinates(playerid, 932.744, -189.285, 35.1431);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Michelle's Appartment", 5000);
					break;
				case 32:
					setPlayerCoordinates(playerid, -1395.83, 1478.13, 26.4474);    
					displayPlayerText(playerid, 0.3, 0.8, "~y~Pegorino's House", 5000);
					break;
				default:
					onPlayerCommand(playerid, "/"+cmd[0]);
					break;
			}
			break;

		case "dimension":
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "������: ������� �������� ������ ������������� �������!", COLOR_HEX_ERROR);
			if(cmd.len() != 3)
				return sendPlayerMessage(playerid, "�����������: [33CCFFFF]/dimension [id ������] [����� ���������]", COLOR_HEX_USE, true);
			if(!isPlayerConnected(cmd[1].tointeger()))
				return sendPlayerMessage(playerid, "������: �������� id ������!", COLOR_HEX_ERROR);
			if((cmd[2].tointeger() < 0) || (cmd[2].tointeger() > 100))
				return sendPlayerMessage(playerid, "������: �������� �������� ������ ���������!", COLOR_HEX_ERROR);
			sendPlayerMessage(cmd[1].tointeger(), "������������� "+getPlayerName(playerid)+"["+playerid+"] ������� ����� ������ ��������� �� "+cmd[2].tointeger()+".", COLOR_HEX_INFO, true);
			sendPlayerMessage(playerid, "�� �������� ����� ��������� ������ "+getPlayerName(cmd[1].tointeger())+"["+cmd[1].tointeger()+"] �� "+cmd[2].tointeger()+".", COLOR_HEX_INFO, true);
			setPlayerDimension(cmd[1].tointeger(), cmd[2].tointeger());
			break;

		default:
			sendPlayerMessage(playerid, "������: ������� '"+cmd[0]+"' �� ����������!", COLOR_HEX_ERROR, true);
			break;
	}
	return true;
}
addEvent("playerCommand", onPlayerCommand);

// =================================================================================================================================

function onPlayerEnterCheckpoint(playerid, checkpointid) {
	log("[Function] onPlayerEnterCheckpoint("+playerid+", "+checkpointid+") called by "+getPlayerName(playerid));
	PlayerInfo[playerid].InCheckpoint = true;
	sendPlayerMessage(playerid, "Enter Checkpoint id"+checkpointid, COLOR_HEX_GREEN, true);
	return true;
}
addEvent("playerEnterCheckpoint", onPlayerEnterCheckpoint);

// =================================================================================================================================

function onPlayerLeaveCheckpoint(playerid, checkpointid) {
	log("[Function] onPlayerLeaveCheckpoint("+playerid+", "+checkpointid+") called by "+getPlayerName(playerid));
	PlayerInfo[playerid].InCheckpoint = false;
	sendPlayerMessage(playerid, "Leave Checkpoint id"+checkpointid, COLOR_HEX_GREEN, true);
	return true;
}
addEvent("playerLeaveCheckpoint", onPlayerLeaveCheckpoint);

// =================================================================================================================================

function onPlayerChangeState(playerid, oldstate, newstate) {
	log("[Function] onPlayerChangeState("+playerid+", "+oldstate+", "+newstate+") called by "+getPlayerName(playerid));
    return 1;
}
addEvent("playerChangeState", onPlayerChangeState);

// =================================================================================================================================

function onVehicleCreate(vehicleid) {
	log("[Function] onVehicleCreate("+vehicleid+") called...");
	VehicleInfo[vehicleid] <- {};
	VehicleInfo[vehicleid].Owner <- " ";
	VehicleInfo[vehicleid].Price <- 0;
	VehicleInfo[vehicleid].Fuel <- 5000;
	VehicleInfo[vehicleid].LeftBlink <- false;
	VehicleInfo[vehicleid].RightBlink <- false;
	VehicleInfo[vehicleid].Model <- getVehicleModel(vehicleid);
	return true;
}
addEvent("vehicleCreate", onVehicleCreate);

// =================================================================================================================================

function onVehicleEntryRequest(playerid, vehicleid, seatid) {
	log("[Function] onVehicleEntryRequest("+playerid+", "+vehicleid+", "+seatid+") called by "+getPlayerName(playerid));
    return 1;
}
addEvent("vehicleEntryRequest", onVehicleEntryRequest);

// =================================================================================================================================

function onPlayerCancelVehicleEntry(playerid, vehicleid, seatid) {
	log("[Function] onPlayerCancelVehicleEntry("+playerid+", "+vehicleid+", "+seatid+") called by "+getPlayerName(playerid));
    return 1;
}
addEvent("vehicleEntryCancelled", onPlayerCancelVehicleEntry);

// =================================================================================================================================

function onVehicleEntryComplete(playerid, vehicleid, seatid) {
	log("[Function] onVehicleEntryComplete("+playerid+", "+vehicleid+", "+seatid+") called by "+getPlayerName(playerid));
	if(PlayerInfo[playerid].Played_Hours <= 6)
		sendPlayerMessage(playerid, "����� �������/��������� ��������� ����������� ������� '/v engine'.", COLOR_HEX_INFO);
    return 1;
}
addEvent("vehicleEntryComplete", onVehicleEntryComplete);

// =================================================================================================================================

function onVehicleExitRequest(playerid, vehicleid, seatid) {
	log("[Function] onVehicleExitRequest("+playerid+", "+vehicleid+", "+seatid+") called by "+getPlayerName(playerid));
    return 1;
}
addEvent("vehicleExitRequest", onVehicleExitRequest);

// =================================================================================================================================

function onVehicleForcefulExit(playerid, vehicleid, seatid) {
	log("[Function] onVehicleForcefulExit("+playerid+", "+vehicleid+", "+seatid+") called by "+getPlayerName(playerid));
    return 1;
}
addEvent("vehicleForcefulExit", onVehicleForcefulExit);

// =================================================================================================================================

function onVehicleExitComplete(playerid, vehicleid, seatid) {
	log("[Function] onVehicleExitComplete("+playerid+", "+vehicleid+", "+seatid+") called by "+getPlayerName(playerid));
	SaveVehicle(vehicleid);
    return 1;
}
addEvent("vehicleExitComplete", onVehicleExitComplete);

// =================================================================================================================================

function onPlayerRequestNameChange(playerid, newnick) {
	log("[Function] onPlayerRequestNameChange("+playerid+", "+newnick+") called by "+getPlayerName(playerid));
	return false;
}
addEvent("playerRequestNameChange", onPlayerRequestNameChange);

// =================================================================================================================================

function TimerSecond() {
//	log("[Function] TimerSecond() called...");
	CheckFuel();
	CheckMoney();
}

// =================================================================================================================================

function TimerMinute() {
	log("[Function] TimerMinute() called...");
	date_info = date();
	setTime(date_info["hour"], date_info["min"]);
	setDayOfWeek(date_info["wday"]);

	PayDay();
	SavePlayers();
	SaveObjects();
	SaveVehicles();
	SaveBusinesses();
}

// =================================================================================================================================

function CheckMoney() {
	foreach(playerid, player in getPlayers()) {
		if(getPlayerMoney(playerid) > GetPlayerMoneyLegal(playerid)) {
			resetPlayerMoney(playerid);
			givePlayerMoney(playerid, GetPlayerMoneyLegal(playerid));
			SendMessageToAdmin("[��������]: "+getPlayerName(playerid)+"["+playerid+"] ������������� � ������������� ���� �� ������!", COLOR_HEX_WARNING);
		}
	}
	return true;
}

// =================================================================================================================================

function GetPlayerMoneyLegal(playerid) return PlayerInfo[playerid].Cash;
function GivePlayerMoneyLegal(playerid, amount) {
	PlayerInfo[playerid].Cash += amount;
	givePlayerMoney(playerid, amount);
	return true;
}

// =================================================================================================================================

function ResetPlayerMoneyLegal(playerid) {
	PlayerInfo[playerid].Cash = 0;
	resetPlayerMoney(playerid);
	return true;
}

// =================================================================================================================================

function GetOnlineAdminsCount() {
	local count = 0;
	foreach(id, player in getPlayers()) {
		if(PlayerInfo[id].Logged != true)
			continue;
		if(PlayerInfo[id].Admin_Level <= 0)
			continue;
		count++;
	}
	return count;
}

// =================================================================================================================================

function LoadPlayer(id, password) {
	local query = sql.query_assoc("SELECT * FROM `characters` WHERE `nickname` = '"+getPlayerName(id)+"' AND `password` = '"+sql.escape(password)+"' LIMIT 1;");
	if(query) {
		if(query.len() > 0) {
			foreach(data in query) {
				PlayerInfo[id].ID = data.id.tointeger();
				PlayerInfo[id].Nickname = data.nickname.tostring();
				PlayerInfo[id].Password = data.password.tostring();
				PlayerInfo[id].Email = data.email.tostring();				
				PlayerInfo[id].Reg_IP = data.reg_ip.tostring();
				PlayerInfo[id].Last_IP = data.last_ip.tostring();
				PlayerInfo[id].Sex = data.sex.tointeger();
				PlayerInfo[id].Age = data.age.tointeger();
				PlayerInfo[id].Skin = data.skin.tointeger();
				PlayerInfo[id].Cash = data.cash.tointeger();
				PlayerInfo[id].Bank = data.bank.tointeger();
				PlayerInfo[id].Phone = data.phone.tointeger();
				PlayerInfo[id].Faction = data.faction.tointeger();
				PlayerInfo[id].Admin_Level = data.admin_level.tointeger();
				PlayerInfo[id].Played_Minutes = data.played_minutes.tointeger();
				PlayerInfo[id].Played_Hours = data.played_hours.tointeger();
				PlayerInfo[id].Pos_X = data.pos_x.tofloat();
				PlayerInfo[id].Pos_Y = data.pos_y.tofloat();
				PlayerInfo[id].Pos_Z = data.pos_z.tofloat();
				PlayerInfo[id].Pos_FA = data.pos_fa.tofloat();
				PlayerInfo[id].Vehicle_Key = data.vehicle_key.tointeger();
				PlayerInfo[id].Business_Key = data.business_key.tointeger();
				givePlayerWeapon(id, data.gun.tointeger(), data.ammo.tointeger());
				setPlayerDimension(id, data.pos_dimension.tointeger());
			}
			setPlayerSpawnLocation(id, PlayerInfo[id].Pos_X, PlayerInfo[id].Pos_Y, PlayerInfo[id].Pos_Z, PlayerInfo[id].Pos_FA);
			setPlayerPosition(id, PlayerInfo[id].Pos_X, PlayerInfo[id].Pos_Y, PlayerInfo[id].Pos_Z);
			setPlayerHeading(id, PlayerInfo[id].Pos_FA);
			setPlayerModel(id, PlayerInfo[id].Skin);
			setPlayerColor(id, COLOR_HEX_ONLINE);
			setCameraBehindPlayer(id);
			resetPlayerMoney(id);
			givePlayerMoney(id, GetPlayerMoneyLegal(id));
			togglePlayerControls(id, true);
			PlayerInfo[id].Logged = true;

			local query = sql.query_assoc("SELECT * FROM `phone_sms` WHERE `taker` = '"+PlayerInfo[id].Phone+"' AND `status` = '0';");
			if(query && query.len() > 0) {
				displayHudNotification(id, 1, "UNREAD_MESSAGES");
				displayPlayerInfoText(id, "~w~You have ~g~"+query.len()+"~w~ unreaded messages!", 10000);
			}
			return true;
		}
	}
	return false;
}

// =================================================================================================================================

function SavePlayers() { foreach(playerid, player in getPlayers()) SavePlayer(playerid); }
function SavePlayer(id) {
	if(PlayerInfo[id].Logged == true || PlayerInfo[id].Registred == true) {
		local position = getPlayerCoordinates(id);
		local heading = getPlayerHeading(id);
		sql.query("UPDATE `characters` SET `nickname`='"+PlayerInfo[id].Nickname+"',`password`='"+PlayerInfo[id].Password+"',`email`='"+PlayerInfo[id].Email+"',`reg_ip`='"+PlayerInfo[id].Reg_IP+"',`last_ip`='"+getPlayerIp(id)+"',`admin_level`='"+PlayerInfo[id].Admin_Level+"',`cash`='"+PlayerInfo[id].Cash+"',`bank`='"+PlayerInfo[id].Bank+"',`played_minutes`='"+PlayerInfo[id].Played_Minutes+"',`played_hours`='"+PlayerInfo[id].Played_Hours+"',`sex`='"+PlayerInfo[id].Sex+"',`age`='"+PlayerInfo[id].Age+"',`skin`='"+PlayerInfo[id].Skin+"',`vehicle_key`='"+PlayerInfo[id].Vehicle_Key+"',`business_key`='"+PlayerInfo[id].Business_Key+"',`pos_x`='"+position[0]+"',`pos_y`='"+position[1]+"',`pos_z`='"+position[2]+"',`pos_fa`='"+heading+"',`pos_dimension`='"+getPlayerDimension(id)+"',`phone`='"+PlayerInfo[id].Phone+"',`faction`='"+PlayerInfo[id].Faction+"',`gun`='"+getPlayerWeapon(id)+"',`ammo`='"+getPlayerAmmo(id)+"' WHERE `id`='"+PlayerInfo[id].ID+"' LIMIT 1;");
		return true;
	}
	return false;
}

// =================================================================================================================================

function PlayerChatPhoneIC(playerid, message) {
	local action = format("%s[%d] �������(�������): %s", getPlayerName(playerid), playerid, message);
	SendNearestPlayerMessage(playerid, action, 20.0, COLOR_HEX_FADE1, COLOR_HEX_FADE2, COLOR_HEX_FADE3, COLOR_HEX_FADE4, COLOR_HEX_FADE5);
	return true;
}

// =================================================================================================================================
/*
function ActorChatPhoneIC(actorid, message) {
	local actor_position = getActorCoordinates(actorid);
	local action = format("%s[Actor] �������(�������): %s", getActorName(actorid), message);
	SendNearestCoordinatesMessage(actor_position[0], actor_position[1], actor_position[2], action, 20.0, COLOR_HEX_FADE1, COLOR_HEX_FADE2, COLOR_HEX_FADE3, COLOR_HEX_FADE4, COLOR_HEX_FADE5);
	return true;
}
*/
// =================================================================================================================================

function PlayerChatIC(playerid, message) {
	local action = format("%s ������(-�): %s", getPlayerName(playerid), message);
	SendNearestPlayerMessage(playerid, action, 20.0, COLOR_HEX_FADE1, COLOR_HEX_FADE2, COLOR_HEX_FADE3, COLOR_HEX_FADE4, COLOR_HEX_FADE5);
	return true;
}

// =================================================================================================================================

function ActorChatIC(actorid, message) {
	local actor_position = getActorCoordinates(actorid);
	local action = format("%s[Actor] ������(-�): %s", getActorName(actorid), message);
	SendNearestCoordinatesMessage(actor_position[0], actor_position[1], actor_position[2], action, 20.0, COLOR_HEX_FADE1, COLOR_HEX_FADE2, COLOR_HEX_FADE3, COLOR_HEX_FADE4, COLOR_HEX_FADE5);
	return true;
}

// =================================================================================================================================

function PlayerChatOOC(playerid, message) {
	local action = format("(( %s[%d]: %s ))", getPlayerName(playerid), playerid, message);
	SendNearestPlayerMessage(playerid, action, 20.0, COLOR_HEX_FADE1, COLOR_HEX_FADE2, COLOR_HEX_FADE3, COLOR_HEX_FADE4, COLOR_HEX_FADE5);
	return true;
}

// =================================================================================================================================

function ActorChatOOC(actorid, message) {
	local actor_position = getActorCoordinates(actorid);
	local action = format("(( %s[Actor]: %s ))", getActorName(actorid), message);
	SendNearestCoordinatesMessage(actor_position[0], actor_position[1], actor_position[2], action, 20.0, COLOR_HEX_FADE1, COLOR_HEX_FADE2, COLOR_HEX_FADE3, COLOR_HEX_FADE4, COLOR_HEX_FADE5);
	return true;
}

// =================================================================================================================================

function PlayerChatWhisper(playerid, message) {
	local action = format("%s[%d] [00ccccFF]�������[ffffffFF]: %s", getPlayerName(playerid), playerid, message);
	SendNearestPlayerMessage(playerid, action, 2.0);
	return true;
}

// =================================================================================================================================

function ActorChatWhisper(actorid, message) {
	local actor_position = getActorCoordinates(actorid);
	local action = format("%s[Actor] [00ccccFF]�������[ffffffFF]: %s", getActorName(actorid), message);
	SendNearestCoordinatesMessage(actor_position[0], actor_position[1], actor_position[2], action, 2.0);
	return true;
}

// =================================================================================================================================

function PlayerChatShout(playerid, message) {
	local action = format("%s[%d] [ff0000FF]������[ffffffFF]: %s", getPlayerName(playerid), playerid, message);
	SendNearestPlayerMessage(playerid, action, 40.0);
	return true;
}

// =================================================================================================================================

function ActorChatShout(actorid, message) {
	local actor_position = getActorCoordinates(actorid);
	local action = format("%s[Actor] [ff0000FF]������[ffffffFF]: %s", getActorName(actorid), message);
	SendNearestCoordinatesMessage(actor_position[0], actor_position[1], actor_position[2], action, 40.0);
	return true;
}

// =================================================================================================================================

function PlayerBigAction(playerid, message) {
	local action = format("* %s %s.", getPlayerName(playerid), message);
	SendNearestPlayerMessage(playerid, action, 20.0, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT);
	return true;
}

// =================================================================================================================================

function ActorBigAction(actorid, message) {
	local actor_position = getActorCoordinates(actorid);
	local action = format("* %s[Actor] %s.", getActorName(actorid), message);
	SendNearestCoordinatesMessage(actor_position[0], actor_position[1], actor_position[2], action, 20.0, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT);
	return true;
}

// =================================================================================================================================

function PlayerBigAction3rd(playerid, message) {
	local action = format("* %s (( %s[%d] ))", message, getPlayerName(playerid), playerid);
	SendNearestPlayerMessage(playerid, action, 20.0, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT);
	return true;
}

// =================================================================================================================================

function ActorBigAction3rd(actorid, message) {
	local actor_position = getActorCoordinates(actorid);
	local action = format("* %s (( %s[Actor] ))", message, getActorName(actorid));
	SendNearestCoordinatesMessage(actor_position[0], actor_position[1], actor_position[2], action, 20.0, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT);
	return true;
}

// =================================================================================================================================

function SendPlayerMessageWithID(account_id, message, color = COLOR_HEX_WHITE) {
	foreach(id, player in getPlayers()) {
		if(PlayerInfo[id].Logged == true && PlayerInfo[id].ID == account_id) {
			sendPlayerMessage(id, message, color);
			return true;
		}
	}
	return false;
}

// =================================================================================================================================

function SendMessageToAdmin(message, color = COLOR_HEX_WHITE, admin_level = 1) {
	local count = 0;
	foreach(id, player in getPlayers()) {
		if(PlayerInfo[id].Logged == true && PlayerInfo[id].Admin_Level >= admin_level) {
			sendPlayerMessage(id, message, color);
			count++;
		}
	}
	return count;
}

// =================================================================================================================================

function PayDay() {
	foreach(playerid, player in getPlayers()) {
		if(PlayerInfo[playerid].Logged != true) continue;
		PlayerInfo[playerid].Played_Minutes++;
		if(PlayerInfo[playerid].Played_Minutes >= 60) {
			PlayerInfo[playerid].Played_Minutes = 0;
			PlayerInfo[playerid].Played_Hours++;

			sendPlayerMessage(playerid, "��������", COLOR_HEX_WHITE);
			local bank_percent = PlayerInfo[playerid].Bank / 100;
			PlayerInfo[playerid].Bank += bank_percent;
			sendPlayerMessage(playerid, "�������: +$"+bank_percent, COLOR_HEX_INFO);
			sendPlayerMessage(playerid, "����: $"+PlayerInfo[playerid].Bank, COLOR_HEX_INFO);
		}
	}
	return true;
}

// =================================================================================================================================

function SendNearestPlayerMessage(playerid, message, range, col1 = COLOR_HEX_WHITE, col2 = COLOR_HEX_WHITE, col3 = COLOR_HEX_WHITE, col4 = COLOR_HEX_WHITE, col5 = COLOR_HEX_WHITE) {
	foreach(i, player in getPlayers()) {
		local distanse = GetDistanceBetweenPlayers(playerid, i);
		if((range.tofloat() / 16) > distanse)
			sendPlayerMessage(i, message, col1, true);
		else if((range.tofloat() / 8) > distanse)
			sendPlayerMessage(i, message, col2, true);
		else if((range.tofloat() / 4) > distanse)
			sendPlayerMessage(i, message, col3, true);
		else if((range.tofloat() / 2) > distanse)
			sendPlayerMessage(i, message, col4, true);
		else if(range.tofloat() > distanse)
			sendPlayerMessage(i, message, col5, true);
	}
	return true;
}

// =================================================================================================================================

function SendNearestVehicleMessage(vehicleid, message, range, col1 = COLOR_HEX_WHITE, col2 = COLOR_HEX_WHITE, col3 = COLOR_HEX_WHITE, col4 = COLOR_HEX_WHITE, col5 = COLOR_HEX_WHITE) {
	local vehicle_position = getVehiclePosition(vehicleid);
	foreach(playerid, player in getPlayers()) {
		local player_position = getPlayerCoordinates(playerid);
		local distanse = getDistanceBetweenPoints3D(player_position[0], player_position[1], player_position[2], vehicle_position[0], vehicle_position[1], vehicle_position[2]);
		if((range.tofloat() / 16) > distanse)
			sendPlayerMessage(playerid, message, col1, true);
		else if((range.tofloat() / 8) > distanse)
			sendPlayerMessage(playerid, message, col2, true);
		else if((range.tofloat() / 4) > distanse)
			sendPlayerMessage(playerid, message, col3, true);
		else if((range.tofloat() / 2) > distanse)
			sendPlayerMessage(playerid, message, col4, true);
		else if(range.tofloat() > distanse)
			sendPlayerMessage(playerid, message, col5, true);
	}
	return true;
}

// =================================================================================================================================

function SendNearestCoordinatesMessage(x, y, z, message, range, col1 = COLOR_HEX_WHITE, col2 = COLOR_HEX_WHITE, col3 = COLOR_HEX_WHITE, col4 = COLOR_HEX_WHITE, col5 = COLOR_HEX_WHITE) {
	foreach(playerid, player in getPlayers()) {
		local player_position = getPlayerCoordinates(playerid);
		local distanse = getDistanceBetweenPoints3D(player_position[0], player_position[1], player_position[2], x, y, z);
		if((range.tofloat() / 16) > distanse)
			sendPlayerMessage(playerid, message, col1, true);
		else if((range.tofloat() / 8) > distanse)
			sendPlayerMessage(playerid, message, col2, true);
		else if((range.tofloat() / 4) > distanse)
			sendPlayerMessage(playerid, message, col3, true);
		else if((range.tofloat() / 2) > distanse)
			sendPlayerMessage(playerid, message, col4, true);
		else if(range.tofloat() > distanse)
			sendPlayerMessage(playerid, message, col5, true);
	}
	return true;
}

// =================================================================================================================================

function GetDistanceBetweenPlayers(firstid, secondid) {
    if(!isPlayerConnected(firstid) || !isPlayerConnected(secondid)) return null;
    local pos = array(2,0);
    pos[0] = getPlayerCoordinates(firstid);
    pos[1] = getPlayerCoordinates(secondid);
    return getDistanceBetweenPoints3D(pos[0][0],pos[0][1],pos[0][2],pos[1][0],pos[1][1],pos[1][2]);
}

// =================================================================================================================================

function GetPlayerNearestVehicle(playerid, range) {
	local player_position = getPlayerCoordinates(playerid);
	for(local vehicleid = 0; vehicleid < MAX_VEHICLES; vehicleid++) {
		if(!isVehicleValid(vehicleid)) continue;
		local vehicle_position = getVehiclePosition(vehicleid);
		if(isPointInBall(player_position[0].tofloat(), player_position[1].tofloat(), player_position[2].tofloat(), vehicle_position[0].tofloat(), vehicle_position[1].tofloat(), vehicle_position[2].tofloat(), range.tofloat())) {
			return vehicleid;
		}
	}
	return -1;
}

// =================================================================================================================================

function GetCoordinatesNearestVehicle(playerid, x, y, z, range) {
	for(local vehicleid = 0; vehicleid < MAX_VEHICLES; vehicleid++) {
		if(!isVehicleValid(vehicleid)) continue;
		local vehicle_position = getVehiclePosition(vehicleid);
		if(isPointInBall(x.tofloat(), y.tofloat(), z.tofloat(), vehicle_position[0].tofloat(), vehicle_position[1].tofloat(), vehicle_position[2].tofloat(), range.tofloat())) {
			return vehicleid;
		}
	}
	return -1;
}

// =================================================================================================================================

function LoadBusinesses() {
	log("\n=============================================================\n");
	log("Start Loading Businesses...\n");
	local businesses = sql.query_assoc("SELECT * FROM `businesses`");
	if(businesses) {
		if(businesses.len() > 0) {
			foreach(id, data in businesses) {
				total_businesses++;
				BusinessInfo[id] <- {};
				BusinessInfo[id].ID <- data.id.tointeger();
				BusinessInfo[id].Type <- data.type.tointeger();
				BusinessInfo[id].Name <- data.name.tostring();
				BusinessInfo[id].Owner <- data.owner.tostring();
				BusinessInfo[id].Price <- data.price.tointeger();
				log((id+1)+". Name: "+data.name.tostring()+". Owner: "+data.owner.tostring()+".");
				log("   Type: "+data.type.tointeger()+". Price: $"+data.price.tointeger()+".");

				BusinessInfo[id].Cp_type <- data.cp_type.tointeger();
				BusinessInfo[id].Cp_pos_x <- data.cp_pos_x.tofloat();
				BusinessInfo[id].Cp_pos_y <- data.cp_pos_y.tofloat();
				BusinessInfo[id].Cp_pos_z <- data.cp_pos_z.tofloat();
				BusinessInfo[id].Cp_nextpos_x <- data.cp_nextpos_x.tofloat();
				BusinessInfo[id].Cp_nextpos_y <- data.cp_nextpos_y.tofloat();
				BusinessInfo[id].Cp_nextpos_z <- data.cp_nextpos_z.tofloat();
				BusinessInfo[id].Cp_radius <- data.cp_radius.tofloat();
				if(data.cp_type.tointeger() != -1) {
					createCheckpoint(data.cp_type.tointeger(),data.cp_pos_x.tofloat(),data.cp_pos_y.tofloat(),data.cp_pos_z.tofloat(),data.cp_nextpos_x.tofloat(),data.cp_nextpos_y.tofloat(),data.cp_nextpos_z.tofloat(),data.cp_radius.tofloat());
					showCheckpointForAll(id);
					log("   Checkpoint type: "+data.cp_type.tostring()+".");
					log("   Checkpoint position: x"+data.cp_pos_x.tofloat()+", y"+data.cp_pos_y.tofloat()+", z"+data.cp_pos_z.tofloat()+".");
					log("   Checkpoint position: nx"+data.cp_nextpos_x.tofloat()+", ny"+data.cp_nextpos_y.tofloat()+", nz"+data.cp_nextpos_z.tofloat()+".");
				}
				else log("   Checkpoint disabled.");

				BusinessInfo[id].Blip_id <- data.blip_id.tointeger();
				BusinessInfo[id].Blip_name <- data.blip_name.tostring();
				BusinessInfo[id].Blip_pos_x <- data.blip_pos_x.tofloat();
				BusinessInfo[id].Blip_pos_y <- data.blip_pos_y.tofloat();
				BusinessInfo[id].Blip_pos_z <- data.blip_pos_z.tofloat();
				if(data.blip_id.tointeger() != -1) {
					createBlip(data.blip_id.tointeger(), data.blip_pos_x.tofloat(), data.blip_pos_y.tofloat(), data.blip_pos_z.tofloat(), true);
					setBlipName(id, data.blip_name.tostring());
					log("   Blip name: "+data.blip_name.tostring()+". Blip model: id"+data.blip_id.tointeger()+".");
					log("   Blip position: x"+data.blip_pos_x.tofloat()+", y"+data.blip_pos_y.tofloat()+", z"+data.blip_pos_z.tofloat()+".");
				}
				else log("   Blip disabled.");

				BusinessInfo[id].Actor_name <- data.actor_name.tostring();
				BusinessInfo[id].Actor_skin <- data.actor_skin.tointeger();
				BusinessInfo[id].Actor_pos_x <- data.actor_pos_x.tofloat();
				BusinessInfo[id].Actor_pos_y <- data.actor_pos_y.tofloat();
				BusinessInfo[id].Actor_pos_z <- data.actor_pos_z.tofloat();
				BusinessInfo[id].Actor_pos_fa <- data.actor_pos_fa.tofloat();
				if(data.actor_skin.tointeger() != -1) {
					createActor(data.actor_skin.tointeger(), data.actor_pos_x.tofloat(), data.actor_pos_y.tofloat(), data.actor_pos_z.tofloat(), data.actor_pos_fa.tofloat());
					setActorName(id, data.actor_name.tostring());
					toggleActorNametag(id, true);
					toggleActorHelmet(id, false);
					toggleActorFrozen(id, true);
					toggleActorBlip(id, false);
					log("   Actor name: "+data.actor_name.tostring()+". Actor skin: id"+data.actor_skin.tointeger()+".");
					log("   Actor position: x"+data.actor_pos_x.tofloat()+", y"+data.actor_pos_y.tofloat()+", z"+data.actor_pos_z.tofloat()+", fa"+data.actor_pos_fa.tofloat()+".\n");
				}
				else log("   Actor disabled.\n");
			}
			log("Total Businesses Loaded: "+(total_businesses+1)+".");
		}
		else log("Businesses Not Found!");
	}
	log("\n=============================================================\n");
	return true;
}

// =================================================================================================================================

function SaveBusinesses() { for(local id = 0; id <= total_businesses; id++) SaveBusiness(id); }
function SaveBusiness(id) {
	if(id > total_businesses) return false;
	sql.query("UPDATE `businesses` SET `type`='"+BusinessInfo[id].Type+"',`name`='"+BusinessInfo[id].Name+"',`owner`='"+BusinessInfo[id].Owner+"',`price`='"+BusinessInfo[id].Price+"',`blip_id`='"+BusinessInfo[id].Blip_id+"',`blip_name`='"+BusinessInfo[id].Blip_name+"',`blip_pos_x`='"+BusinessInfo[id].Blip_pos_x+"',`blip_pos_y`='"+BusinessInfo[id].Blip_pos_y+"',`blip_pos_z`='"+BusinessInfo[id].Blip_pos_z+"' WHERE `id`='"+BusinessInfo[id].ID+"' LIMIT 1;");
	sql.query("UPDATE `businesses` SET `actor_name`='"+BusinessInfo[id].Actor_name+"',`actor_skin`='"+BusinessInfo[id].Actor_skin+"',`actor_pos_x`='"+BusinessInfo[id].Actor_pos_x+"',`actor_pos_y`='"+BusinessInfo[id].Actor_pos_y+"',`actor_pos_z`='"+BusinessInfo[id].Actor_pos_z+"',`actor_pos_fa`='"+BusinessInfo[id].Actor_pos_fa+"' WHERE `id`='"+BusinessInfo[id].ID+"' LIMIT 1;");
	return true;
}

// =================================================================================================================================

function GetPlayerNearestBusiness(playerid, range) {
	local player_position = getPlayerCoordinates(playerid);
	for(local businessid = 0; businessid <= total_businesses; businessid++) {
		if(isPointInBall(player_position[0].tofloat(), player_position[1].tofloat(), player_position[2].tofloat(), BusinessInfo[businessid].Blip_pos_x, BusinessInfo[businessid].Blip_pos_y, BusinessInfo[businessid].Blip_pos_z, range.tofloat())) {
			return businessid;
		}
	}
	return -1;
}

// =================================================================================================================================

function GetPlayerBusinessCount(playerid) {
	local count = 0;
	local player_name = getPlayerName(playerid).tostring();
	for(local businessid = 0; businessid < total_businesses; businessid++)
		if(GetBusinessOwner(businessid) == player_name)
			count++;
	return count;
}

// =================================================================================================================================

function SetBusinessOwner(businessid, owner) {
	if(businessid > total_businesses) return false;
	BusinessInfo[businessid].Owner = owner.tostring();
	return true;
}

// =================================================================================================================================

function GetBusinessOwner(businessid) {
	if(businessid > total_businesses) return false;
	if(BusinessInfo[businessid].Owner.tostring() == "None") return false;
	return BusinessInfo[businessid].Owner.tostring();
}

// =================================================================================================================================

function IsPlayerHaveBusinessKeys(playerid, businessid) {
	if(businessid > total_businesses) return true;
	if(GetBusinessOwner(businessid) == getPlayerName(playerid)) return true;
	if(PlayerInfo[playerid].Business_Key == BusinessInfo[businessid].ID) return true;
	return false;
}

// =================================================================================================================================

function IsPlayerBusinessOwner(playerid, businessid) {
	if(businessid > total_businesses) return false;
	if(GetBusinessOwner(businessid) == getPlayerName(playerid)) return true;
	return false;
}

// =================================================================================================================================

function LoadVehicles() {
	log("\n=============================================================\n");
	log("Start Loading Vehicles...\n");
	local vehicles = sql.query_assoc("SELECT * FROM `vehicles`");
	if(vehicles) {
		if(vehicles.len() > 0) {
			foreach(id, data in vehicles) {
				createVehicle(data.model.tointeger(), data.pos_x.tofloat(), data.pos_y.tofloat(), data.pos_z.tofloat(), data.pos_rx.tofloat(), data.pos_ry.tofloat(), data.pos_rz.tofloat(), data.color1.tointeger(), data.color2.tointeger(), data.color3.tointeger(), data.color4.tointeger());
				setVehicleHealth(id, data.health.tointeger());
				setVehicleDirtLevel(id, data.dirt.tofloat());
				setVehicleLocked(id, data.lock.tointeger());
				setVehicleDimension(id, data.pos_dimension.tointeger());
				total_vehicles++;

				VehicleInfo[id].ID <- data.id.tointeger();
				VehicleInfo[id].Owner = data.owner.tostring();
				VehicleInfo[id].Price = data.price.tointeger();
				VehicleInfo[id].Fuel = data.fuel.tointeger();
				VehicleInfo[id].Model = data.model.tointeger();
//				VehicleInfo[id].Pos_X <- data.pos_x.tofloat();
//				VehicleInfo[id].Pos_Y <- data.pos_y.tofloat();
//				VehicleInfo[id].Pos_Z <- data.pos_z.tofloat();
//				VehicleInfo[id].Pos_rX <- data.pos_rx.tofloat();
//				VehicleInfo[id].Pos_rY <- data.pos_ry.tofloat();
//				VehicleInfo[id].Pos_rZ <- data.pos_rz.tofloat();
//				VehicleInfo[id].Pos_Dimension <- data.pos_dimension.tointeger();
//				VehicleInfo[id].Color1 <- data.color1.tointeger();
//				VehicleInfo[id].Color2 <- data.color2.tointeger();
//				VehicleInfo[id].Color3 <- data.color3.tointeger();
//				VehicleInfo[id].Color4 <- data.color4.tointeger();

				log((id+1)+". Name: "+getVehicleName(VehicleInfo[id].Model)+"[id"+VehicleInfo[id].Model+"]. Owner: "+VehicleInfo[id].Owner+".");
				log("   Health: "+data.health.tointeger()+". Fuel: "+VehicleInfo[id].Fuel+". Price: $"+VehicleInfo[id].Price+".");
				log("   Position: x"+data.pos_x.tofloat()+", y"+data.pos_y.tofloat()+", z"+data.pos_z.tofloat()+", dimension"+data.pos_dimension.tointeger()+".");
				log("   Rotation: x"+data.pos_rx.tofloat()+", y"+data.pos_ry.tofloat()+", z"+data.pos_rz.tofloat()+".");
				log("   Colors: "+data.color1.tointeger()+", "+data.color2.tointeger()+", "+data.color3.tointeger()+", "+data.color4.tointeger()+".\n");
			}
			log("Total Vehicles Loaded: "+(total_vehicles+1)+".");
		}
		else log("Vehicles Not Found!");
	}
	log("\n=============================================================\n");
	return true;
}

// =================================================================================================================================

function SaveVehicles() { for(local id = 0; id <= total_vehicles; id++) SaveVehicle(id); }
function SaveVehicle(id) {
	if(id > total_vehicles) return false;
	local position = getVehiclePosition(id);
	local rotation = getVehicleRotation(id);
	local color = getVehicleColor(id);
	local health = getVehicleHealth(id);
	local dirt = getVehicleDirtLevel(id);
	local lock = getVehicleLocked(id);
	sql.query("UPDATE `vehicles` SET `owner`='"+VehicleInfo[id].Owner+"',`model`='"+VehicleInfo[id].Model+"',`price`='"+VehicleInfo[id].Price+"',`health`='"+health+"',`dirt`='"+dirt+"',`fuel`='"+VehicleInfo[id].Fuel+"',`lock`='"+lock+"' WHERE `id`='"+VehicleInfo[id].ID+"' LIMIT 1;");
	sql.query("UPDATE `vehicles` SET `pos_x`='"+position[0]+"',`pos_y`='"+position[1]+"',`pos_z`='"+position[2]+"',`pos_rx`='"+rotation[0]+"',`pos_ry`='"+rotation[1]+"',`pos_rz`='"+rotation[2]+"',`pos_dimension`='"+getVehicleDimension(id)+"',`color1`='"+color[0]+"',`color2`='"+color[1]+"',`color3`='"+color[2]+"',`color4`='"+color[3]+"' WHERE `id`='"+VehicleInfo[id].ID+"' LIMIT 1;");
	return true;
}

// =================================================================================================================================

function CheckFuel() {
	for(local vehicleid = 0; vehicleid < MAX_VEHICLES; vehicleid++) {
		if(getVehicleEngineState(vehicleid)) {
			VehicleInfo[vehicleid].Fuel -= 1;
			if(VehicleInfo[vehicleid].Fuel <= 0) {
				VehicleInfo[vehicleid].Fuel = 0;
				setVehicleEngineState(vehicleid, false);
				local action = format("* ��������� ������ (( %s ))", getVehicleName(getVehicleModel(vehicleid)));
				SendNearestVehicleMessage(vehicleid, action, 20.0, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT);
			}
			foreach(playerid, player in getPlayers()) {
				if(isPlayerInVehicle(playerid, vehicleid)) {
					triggerClientEvent(playerid, "server_updatefuel", VehicleInfo[vehicleid].Fuel);
				}
			}
		}
	}
	return true;
}

// =================================================================================================================================

function GetPlayerVehicleCount(playerid) {
	local count = 0;
	local player_name = getPlayerName(playerid).tostring();
	for(local vehicleid = 0; vehicleid < total_vehicles; vehicleid++)
		if(GetVehicleOwner(vehicleid) == player_name)
			count++;
	return count;
}

// =================================================================================================================================

function SetVehicleOwner(vehicleid, owner) {
	if(vehicleid > total_vehicles) return false;
	VehicleInfo[vehicleid].Owner = owner.tostring();
	return true;
}

// =================================================================================================================================

function GetVehicleOwner(vehicleid) {
	if(vehicleid > total_vehicles) return false;
	if(VehicleInfo[vehicleid].Owner.tostring() == "None") return false;
	return VehicleInfo[vehicleid].Owner.tostring();
}

// =================================================================================================================================

function IsPlayerHaveVehicleKeys(playerid, vehicleid) {
	if(vehicleid > total_vehicles) return true;
	if(GetVehicleOwner(vehicleid) == getPlayerName(playerid)) return true;
	if(PlayerInfo[playerid].Vehicle_Key == VehicleInfo[vehicleid].ID) return true;
	return false;
}

// =================================================================================================================================

function IsPlayerVehicleOwner(playerid, vehicleid) {
	if(vehicleid > total_vehicles) return false;
	if(GetVehicleOwner(vehicleid) == getPlayerName(playerid)) return true;
	return false;
}

// =================================================================================================================================

function LoadObjects() {
	log("\n=============================================================\n");
	log("Start Loading Objects...\n");
	local objects = sql.query_assoc("SELECT * FROM `objects`");
	if(objects) {
		if(objects.len() > 0) {
			foreach(objectid, data in objects) {

				createObject(data.model_hash.tointeger(), data.pos_x.tofloat(), data.pos_y.tofloat(), data.pos_z.tofloat(), data.pos_rx.tofloat(), data.pos_ry.tofloat(), data.pos_rz.tofloat());
//				SetDimension(objectid, data.dimension.tointeger());
				total_objects++;

				ObjectInfo[objectid] <- {};
				ObjectInfo[objectid].ID <- data.id.tointeger();
				ObjectInfo[objectid].Model <- data.model_hash.tostring();
//				ObjectInfo[objectid].Pos_X <- data.pos_x.tofloat();
//				ObjectInfo[objectid].Pos_Y <- data.pos_y.tofloat();
//				ObjectInfo[objectid].Pos_Z <- data.pos_z.tofloat();
//				ObjectInfo[objectid].Pos_rX <- data.pos_rx.tofloat();
//				ObjectInfo[objectid].Pos_rY <- data.pos_ry.tofloat();
//				ObjectInfo[objectid].Pos_rZ <- data.pos_rz.tofloat();

				log((objectid+1)+". ModelHash: "+ObjectInfo[objectid].Model+"[id"+getObjectModel(objectid)+"].");
				log("   Position: x"+data.pos_x.tofloat()+", y"+data.pos_y.tofloat()+", z"+data.pos_z.tofloat()+".");
				log("   Rotation: x"+data.pos_rx.tofloat()+", y"+data.pos_ry.tofloat()+", z"+data.pos_rz.tofloat()+".\n");
			}
			log("Total Objects Loaded: "+(total_objects+1)+".");
		}
		else log("Objects Not Found!");
	}
	log("\n=============================================================\n");
	return true;
}

// =================================================================================================================================

function SaveObjects() { for(local objectid = 0; objectid <= total_objects; objectid++) SaveObject(objectid); }
function SaveObject(objectid) {
	if(objectid > total_objects) return false;
	local modelid = getObjectModel(objectid);
//	local dimension = getObjectDimension(objectid); `dimension`='"+dimension+"'
	local position = getObjectCoordinates(objectid);
	local rotation = getObjectRotation(objectid);
	sql.query("UPDATE `objects` SET `model_hash`='"+ObjectInfo[objectid].Model+"',`pos_x`='"+position[0]+"',`pos_y`='"+position[1]+"',`pos_z`='"+position[2]+"',`pos_rx`='"+rotation[0]+"',`pos_ry`='"+rotation[1]+"',`pos_rz`='"+rotation[2]+"' WHERE `id`='"+ObjectInfo[objectid].ID+"' LIMIT 1;");
	return true;
}

// =================================================================================================================================

function onPlayerTurnVehicleLock(playerid) {
	local vehicleid = GetPlayerNearestVehicle(playerid, 3.5);
	if(vehicleid == -1 || !IsPlayerHaveVehicleKeys(playerid, vehicleid))
		return sendPlayerMessage(playerid, "������: ����� � ���� ��� ���������� �� �������� � ��� ���� �����!", COLOR_HEX_ERROR);
	if(getVehicleLocked(vehicleid)) {
		setVehicleLocked(vehicleid, 0);
		local action = format("* ����� ������ ��������(���������) (( %s ))", getVehicleName(getVehicleModel(vehicleid)));
		SendNearestVehicleMessage(vehicleid, action, 20.0, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT);
	} else {
		setVehicleLocked(vehicleid, 1);
		local action = format("* ����� ������ ��������(���������) (( %s ))", getVehicleName(getVehicleModel(vehicleid)));
		SendNearestVehicleMessage(vehicleid, action, 20.0, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT);
	}
}
addEvent("client_lock", onPlayerTurnVehicleLock);

// =================================================================================================================================

function onPlayerTurnVehicleEngine(playerid) {
	if(!isPlayerInAnyVehicle(playerid)) return false;
	local action;
	local vehicleid = getPlayerVehicleId(playerid);
	if(getVehicleEngineState(vehicleid))
		setVehicleEngineState(vehicleid, false);
	else {
		if(VehicleInfo[vehicleid].Fuel <= 0)
			SendNearestVehicleMessage(vehicleid, "* ��������� �� ��������� (( "+getVehicleName(getVehicleModel(vehicleid))+" ))", 20.0, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT, COLOR_HEX_RPACT);
		else
			setVehicleEngineState(vehicleid, true);
	}
}
addEvent("client_engine", onPlayerTurnVehicleEngine);

// =================================================================================================================================

function onPlayerTurnVehicleLights(playerid) {
	if(!isPlayerInAnyVehicle(playerid)) return false;
	local vehicleid = getPlayerVehicleId(playerid);
	if(getVehicleLights(vehicleid))
		setVehicleLights(vehicleid, false);
	else
		setVehicleLights(vehicleid, true);
}
addEvent("client_lights", onPlayerTurnVehicleLights);

// =================================================================================================================================

function onPlayerTurnVehicleBlinks(playerid) {
	if(!isPlayerInAnyVehicle(playerid)) return false;
	local vehicleid = getPlayerVehicleId(playerid);

	if((VehicleInfo[vehicleid].LeftBlink == true) && (VehicleInfo[vehicleid].RightBlink = true)) {
		VehicleInfo[vehicleid].LeftBlink = false;
		VehicleInfo[vehicleid].RightBlink = false;
		setVehicleIndicators(vehicleid, false, false, false, false);
		return false;
	} else {
		VehicleInfo[vehicleid].LeftBlink = true;
		VehicleInfo[vehicleid].RightBlink = true;
		setVehicleIndicators(vehicleid, true, true, true, true);
		return true;
	}
}
addEvent("client_blinks", onPlayerTurnVehicleBlinks);

// =================================================================================================================================

function onPlayerTurnVehicleLeftBlink(playerid) {
	if(!isPlayerInAnyVehicle(playerid)) return false;
	local vehicleid = getPlayerVehicleId(playerid);

	if(VehicleInfo[vehicleid].LeftBlink == true) {
		VehicleInfo[vehicleid].LeftBlink = false;
		VehicleInfo[vehicleid].RightBlink = false;
		setVehicleIndicators(vehicleid, false, false, false, false);
		return false;
	} else {
		VehicleInfo[vehicleid].LeftBlink = true;
		VehicleInfo[vehicleid].RightBlink = false;
		setVehicleIndicators(vehicleid, true, false, true, false);
		return true;
	}
}
addEvent("client_left_blink", onPlayerTurnVehicleLeftBlink);

// =================================================================================================================================

function onPlayerTurnVehicleRightBlink(playerid) {
	if(!isPlayerInAnyVehicle(playerid)) return false;
	local vehicleid = getPlayerVehicleId(playerid);

	if(VehicleInfo[vehicleid].RightBlink == true) {
		VehicleInfo[vehicleid].LeftBlink = false;
		VehicleInfo[vehicleid].RightBlink = false;
		setVehicleIndicators(vehicleid, false, false, false, false);
		return false;
	} else {
		VehicleInfo[vehicleid].LeftBlink = false;
		VehicleInfo[vehicleid].RightBlink = true;
		setVehicleIndicators(vehicleid, false, true, false, true);
		return true;
	}
}
addEvent("client_right_blink", onPlayerTurnVehicleRightBlink);

// =================================================================================================================================

function onPlayerTooglePlayerInventory(playerid, targetid = -1) {
	if(targetid == -1) targetid = playerid;
}
addEvent("client_toogle_inventory", onPlayerTooglePlayerInventory);

// =================================================================================================================================

function onPlayerCheckActionPoint(playerid) {
	local businessid = GetPlayerNearestBusiness(playerid, 15.0);
	if(businessid != -1) {
		sendPlayerMessage(playerid, "Bussiness Name: "+BusinessInfo[businessid].Name+"["+businessid+"].", COLOR_HEX_INFO);
		sendPlayerMessage(playerid, "Bussiness Owner: "+BusinessInfo[businessid].Owner+". Bussiness Price: $"+BusinessInfo[id].Price+".", COLOR_HEX_INFO);
		switch(BusinessInfo[businessid].Type) {
			case BUSINESS_TYPE_NONE:
				sendPlayerMessage(playerid, "Bussiness Type: NONE", COLOR_HEX_INFO);
				break;

			case BUSINESS_TYPE_DEFAULT:
				sendPlayerMessage(playerid, "Bussiness Type: DEFAULT", COLOR_HEX_INFO);
				break;

			case BUSINESS_TYPE_BURGER:
				sendPlayerMessage(playerid, "Bussiness Type: BURGER", COLOR_HEX_INFO);
				break;

			case BUSINESS_TYPE_CLUCKINBELL:
				sendPlayerMessage(playerid, "Bussiness Type: CLUCKINBELL", COLOR_HEX_INFO);
				break;

			case BUSINESS_TYPE_SUPERSTAR:
				sendPlayerMessage(playerid, "Bussiness Type: SUPERSTAR", COLOR_HEX_INFO);
				break;

			default:
				break;
		}
	}
}
addEvent("client_check_action", onPlayerCheckActionPoint);

// =================================================================================================================================

function onPlayerCheckEnterPoint(playerid) {
}
addEvent("client_check_enter", onPlayerCheckEnterPoint);

// =================================================================================================================================

function onPlayerCheckExitPoint(playerid) {
}
addEvent("client_check_exit", onPlayerCheckExitPoint);

// =================================================================================================================================

function showPlayerDialog(playerid, dialogid, type, windowtext, maintext, firstbuttontext, secondbuttontext = "") {
	log("[Function] showPlayerDialog("+playerid+", "+dialogid+", "+type+", "+windowtext+", "+maintext+", "+firstbuttontext+", "+secondbuttontext+") called by "+getPlayerName(playerid));
    triggerClientEvent(playerid, "server_show_dialog", dialogid, type, windowtext, maintext, firstbuttontext, secondbuttontext);
    togglePlayerControls(playerid, false);
    return true;
}

// =================================================================================================================================

function onDialogResponse(playerid, dialogid, response, listitem, inputtext) {
	log("[Function] onDialogResponse("+playerid+", "+dialogid+", "+response+", "+listitem+", "+inputtext+") called by "+getPlayerName(playerid));
    togglePlayerControls(playerid, true);
	sendPlayerMessage(playerid, "Dialog "+dialogid+". Response "+response+". Listitem "+listitem+". Inputtext "+inputtext+".", COLOR_HEX_INFO);
	switch(dialogid) {

		case DIALOG_NONE:
			break;

		case DIALOG_LOGIN:
			if(PlayerInfo[playerid].Registred != true)
				return sendPlayerMessage(playerid, "������: �� �� ����������������!", COLOR_HEX_ERROR, true);
			if(PlayerInfo[playerid].Logged != false)
				return sendPlayerMessage(playerid, "������: �� ��� ��������������!", COLOR_HEX_ERROR, true);
			if(!LoadPlayer(playerid, inputtext)) {
				PlayerInfo[playerid].LoginTryes++;
				showPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Russian Role Play - Login", "Incorrect password ("+PlayerInfo[playerid].LoginTryes+"/3).\nPlease try again:", "Next");
				if(PlayerInfo[playerid].LoginTryes >= 3) {
					showPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "Russian Role Play - Kick", "You have been kicked for an incorrect password three times!", "Cancel");
					kickPlayer(playerid, true);
				}
				return true;
			}
			if(PlayerInfo[playerid].Admin_Level != 0)
				sendPlayerMessage(playerid, "�� ������� ���������������� ��� ������������� "+PlayerInfo[playerid].Admin_Level+" ������!", COLOR_HEX_INFO, true);
			else
				sendPlayerMessage(playerid, "�� ������� ����������������!", COLOR_HEX_INFO, true);
			break;

		case DIALOG_REGISTER:
			if(PlayerInfo[playerid].Registred != false)
				return sendPlayerMessage(playerid, "������: �� ��� ����������������!", COLOR_HEX_ERROR, true);
			if(!sql.query("INSERT INTO `characters` (`nickname`,`password`,`email`,`reg_ip`) VALUES ('"+getPlayerName(playerid)+"','"+sql.escape(inputtext)+"','no email','"+getPlayerIp(playerid)+"');"))
				return sendPlayerMessage(playerid, "������: �� ������� ������������������, ��������� � ������� ���������������!", COLOR_HEX_ERROR);
			PlayerInfo[playerid].Registred = true;
			showPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Russian Role Play - Register", "Congratulations! You have successfully registered!\nBut now type your password:", "Login");
			break;
	}
    return true;
}
addEvent("client_dialog_response", onDialogResponse); 

// =================================================================================================================================
