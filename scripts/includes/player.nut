/*
player.login(password);
player.logout(password);
player.logout(password);

date_info = date();
log(" Server Time: "+date_info["hour"]+":"+date_info["min"]+":"+date_info["sec"]);
log(" Server Date: "+date_info["day"]+"/"+(date_info["month"]+1)+"/"+date_info["year"]);
log(" Day of the week: "+date_info["wday"]);
log(" Day of the year: "+date_info["yday"]+"\n");

Player <- CPlayer(playerid, "Jonathan_Rosewood", "localhost");
log(Player.nickname);
log(Player.password);
*/

/*
// onPlayerConnect	
	PlayerInfo[playerid].SpectateID <- -1;
	PlayerInfo[playerid].SpectateType <- -1;

// onPlayerCommand
		case "sp": {
			if(PlayerInfo[playerid].Admin_Level == 0)
				return sendPlayerMessage(playerid, "Ошибка: Команда доступна только администрации сервера!", COLOR_HEX_ERROR);
			if(cmd.len() != 2) {
				if(PlayerInfo[playerid].SpectateID != -1 && PlayerInfo[playerid].SpectateType != -1) {
					PlayerInfo[playerid].SpectateID = -1;
					PlayerInfo[playerid].SpectateType = -1;
					resetPlayerCamera(playerid);
//					setCameraBehindPlayer(playerid);
					sendPlayerMessage(playerid, "Вы закончили наблюдать за игроком!", COLOR_HEX_INFO, true);
				}
				else sendPlayerMessage(playerid, "Используйте: [33CCFFFF]/sp [id игрока]", COLOR_HEX_USE, true);
				return true;
			}
			if(!isPlayerConnected(cmd[1].tointeger()))
				return sendPlayerMessage(playerid, "Ошибка: Неверный id игрока!", COLOR_HEX_ERROR);
			else if(!isPlayerInAnyVehicle(cmd[1].tointeger())) {
				PlayerInfo[playerid].SpectateID = cmd[1].tointeger();
				PlayerInfo[playerid].SpectateType = 1;
				attachPlayerCameraToPlayer(playerid, cmd[1].tointeger());
				sendPlayerMessage(playerid, "Вы закончили наблюдать за персонажем игрока!", COLOR_HEX_INFO, true);
			} else {
				PlayerInfo[playerid].SpectateID = cmd[1].tointeger();
				PlayerInfo[playerid].SpectateType = 2;
				attachPlayerCameraToVehicle(playerid, getPlayerVehicleId(cmd[1].tointeger()));
				sendPlayerMessage(playerid, "Вы закончили наблюдать за транспортом игрока!", COLOR_HEX_INFO, true);
			}
			break;
		}
*/

class CPlayer
{
	connected = false;
	registred = false;
	logged = false;

	playerid = -1;
	nickname = "";
	playerip = "";

	constructor(playerid, nickname, playerip) {
		class_log(nickname+"["+playerid+"] connected with ip "+playerip+".");
		this.connected = true;
		this.playerid = playerid;
		this.nickname = nickname;
		this.playerip = playerip;
		return true;
	}

	function class_log(text) {
		log(format("[Player %02d:%02d:%02d] %s", date()["hour"], date()["min"], date()["sec"], text));
	}

	function login(password) {
		class_log(nickname+"["+playerid+"] trying to login with password '"+password+"'.");
		if(this.registred == true)
			this.logged = true;
	}
	
	function logout() {
		if(this.logged == true)
			this.logged = false;
	}
	
}