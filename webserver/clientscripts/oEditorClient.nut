/**
 * oEditor - object editor
 *
 * @author Fafu <fafu.rb@gmail.com>
 * @version 2.0
 */

local ctrlPressed = false;

local objList = [];
triggerServerEvent("loadObjectsClient");

local currentWindow = "";

local GUI = {};
local screen = guiGetScreenSize();
GUI.objListWindow <- GUIWindow();
GUI.objListWindow.setPosition(screen[0]-200, screen[1]-600.0, false);
GUI.objListWindow.setSize(200.0, 600.0, false);
GUI.objListWindow.setText("Select category");
GUI.objListWindow.setVisible(false);

GUI.item <- {};
local itemsPerPage = 30;
local currentItem = 0;
local currentPage = 1;
local numPages = 1;
local currentCat = "";
local currentCatItems = {};
local currentPageItems = {};

local y = 8.0;
local let = "";
for(local i = 0; i < itemsPerPage; i++) {
	GUI.item[i] <- GUIText();
	GUI.item[i].setParent(GUI.objListWindow.getName());
	GUI.item[i].setPosition(10.0, y, false);
	GUI.item[i].setText("");
	GUI.item[i].setProperty("Font", "tahoma#8#1");
	if(i == 0) GUI.item[i].setProperty("TextColours", "FFFF9900");
	y += 15.0;
}
y+= 7.0;
GUI.prevButton <- GUIButton();
GUI.prevButton.setParent(GUI.objListWindow.getName());
GUI.prevButton.setPosition(10.0, y, false);
GUI.prevButton.setSize(30.0, 30.0, false);
GUI.prevButton.setText("Prev");

GUI.nextButton <- GUIButton();
GUI.nextButton.setParent(GUI.objListWindow.getName());
GUI.nextButton.setPosition(50.0, y, false);
GUI.nextButton.setSize(30.0, 30.0, false);
GUI.nextButton.setText("Next");

GUI.prevpButton <- GUIButton();
GUI.prevpButton.setParent(GUI.objListWindow.getName());
GUI.prevpButton.setPosition(90.0, y, false);
GUI.prevpButton.setSize(40.0, 30.0, false);
GUI.prevpButton.setText("Prev Page");

GUI.nextpButton <- GUIButton();
GUI.nextpButton.setParent(GUI.objListWindow.getName());
GUI.nextpButton.setPosition(140.0, y, false);
GUI.nextpButton.setSize(40.0, 30.0, false);
GUI.nextpButton.setText("Next Page");

y += 40;

GUI.categoriesButton <- GUIButton();
GUI.categoriesButton.setParent(GUI.objListWindow.getName());
GUI.categoriesButton.setPosition(10.0, y, false);
GUI.categoriesButton.setSize(70.0, 30.0, false);
GUI.categoriesButton.setText("Categories");

GUI.firstpButton <- GUIButton();
GUI.firstpButton.setParent(GUI.objListWindow.getName());
GUI.firstpButton.setPosition(90.0, y, false);
GUI.firstpButton.setSize(40.0, 30.0, false);
GUI.firstpButton.setText("First Page");

GUI.lastpButton <- GUIButton();
GUI.lastpButton.setParent(GUI.objListWindow.getName());
GUI.lastpButton.setPosition(140.0, y, false);
GUI.lastpButton.setSize(40.0, 30.0, false);
GUI.lastpButton.setText("Last Page");

y += 40;

GUI.searchButton <- GUIButton();
GUI.searchButton.setParent(GUI.objListWindow.getName());
GUI.searchButton.setPosition(10.0, y, false);
GUI.searchButton.setSize(70.0, 30.0, false);
GUI.searchButton.setText("Search");

GUI.undoButton <- GUIButton();
GUI.undoButton.setParent(GUI.objListWindow.getName());
GUI.undoButton.setPosition(90.0, y, false);
GUI.undoButton.setSize(40.0, 30.0, false);
GUI.undoButton.setText("Undo");

GUI.selectButton <- GUIButton();
GUI.selectButton.setParent(GUI.objListWindow.getName());
GUI.selectButton.setPosition(140.0, y, false);
GUI.selectButton.setSize(40.0, 30.0, false);
GUI.selectButton.setText("Select");

GUI.searchWindow <- GUIWindow();
GUI.searchWindow.setPosition(screen[0]/2 - 230/2, screen[1]/2 - 85/2, false);
GUI.searchWindow.setSize(230.0, 85.0, false);
GUI.searchWindow.setText("Search");
GUI.searchWindow.setVisible(false);

GUI.searchEditBox <- GUIEditBox();
GUI.searchEditBox.setParent(GUI.searchWindow.getName());
GUI.searchEditBox.setPosition(5.0, 8.0, false);
GUI.searchEditBox.setSize(212.0, 20.0, false);
GUI.searchEditBox.setText(""); 

GUI.searchSubmitButton <- GUIButton();
GUI.searchSubmitButton.setParent(GUI.searchWindow.getName());
GUI.searchSubmitButton.setPosition(56.0, 35.0, false);
GUI.searchSubmitButton.setSize(50.0, 20.0, false);
GUI.searchSubmitButton.setText("Submit");

GUI.searchCloseButton <- GUIButton();
GUI.searchCloseButton.setParent(GUI.searchWindow.getName());
GUI.searchCloseButton.setPosition(116.0, 35.0, false);
GUI.searchCloseButton.setSize(50.0, 20.0, false);
GUI.searchCloseButton.setText("Close");


GUI.loopGeneratorWindow <- GUIWindow();
GUI.loopGeneratorWindow.setPosition(screen[0]-195, screen[1]-185.0, false);
GUI.loopGeneratorWindow.setSize(195.0, 185.0, false);
GUI.loopGeneratorWindow.setText("Loop generator");
GUI.loopGeneratorWindow.setVisible(false);

GUI.loopGeneratorText <- {};
GUI.loopGeneratorEditBox <- {};
y = 8.0;
GUI.loopGeneratorText[0] <- GUIText();
GUI.loopGeneratorText[0].setParent(GUI.loopGeneratorWindow.getName());
GUI.loopGeneratorText[0].setPosition(5.0, y, false);
GUI.loopGeneratorText[0].setText("Object ID");
GUI.loopGeneratorText[0].setProperty("Font", "tahoma#8#1");

GUI.loopGeneratorText[1] <- GUIText();
GUI.loopGeneratorText[1].setParent(GUI.loopGeneratorWindow.getName());
GUI.loopGeneratorText[1].setPosition(100.0, y, false);
GUI.loopGeneratorText[1].setText("Radius");
GUI.loopGeneratorText[1].setProperty("Font", "tahoma#8#1");

y += 15.0;

GUI.loopGeneratorEditBox[0] <- GUIEditBox();
GUI.loopGeneratorEditBox[0].setParent(GUI.loopGeneratorWindow.getName());
GUI.loopGeneratorEditBox[0].setPosition(5.0, y, false);
GUI.loopGeneratorEditBox[0].setSize(80.0, 20.0, false);
GUI.loopGeneratorEditBox[0].setText("0"); 

GUI.loopGeneratorEditBox[1] <- GUIEditBox();
GUI.loopGeneratorEditBox[1].setParent(GUI.loopGeneratorWindow.getName());
GUI.loopGeneratorEditBox[1].setPosition(100.0, y, false);
GUI.loopGeneratorEditBox[1].setSize(80.0, 20.0, false);
GUI.loopGeneratorEditBox[1].setText("15"); 

y += 25.0;

GUI.loopGeneratorText[2] <- GUIText();
GUI.loopGeneratorText[2].setParent(GUI.loopGeneratorWindow.getName());
GUI.loopGeneratorText[2].setPosition(5.0, y, false);
GUI.loopGeneratorText[2].setText("Axis (x,y,-x,-y)");
GUI.loopGeneratorText[2].setProperty("Font", "tahoma#8#1");

GUI.loopGeneratorText[3] <- GUIText();
GUI.loopGeneratorText[3].setParent(GUI.loopGeneratorWindow.getName());
GUI.loopGeneratorText[3].setPosition(100.0, y, false);
GUI.loopGeneratorText[3].setText("Loops");
GUI.loopGeneratorText[3].setProperty("Font", "tahoma#8#1");

y += 15.0;

GUI.loopGeneratorEditBox[2] <- GUIEditBox();
GUI.loopGeneratorEditBox[2].setParent(GUI.loopGeneratorWindow.getName());
GUI.loopGeneratorEditBox[2].setPosition(5.0, y, false);
GUI.loopGeneratorEditBox[2].setSize(80.0, 20.0, false);
GUI.loopGeneratorEditBox[2].setText("-y"); 

GUI.loopGeneratorEditBox[3] <- GUIEditBox();
GUI.loopGeneratorEditBox[3].setParent(GUI.loopGeneratorWindow.getName());
GUI.loopGeneratorEditBox[3].setPosition(100.0, y, false);
GUI.loopGeneratorEditBox[3].setSize(80.0, 20.0, false);
GUI.loopGeneratorEditBox[3].setText("1"); 

y += 25.0;

GUI.loopGeneratorText[4] <- GUIText();
GUI.loopGeneratorText[4].setParent(GUI.loopGeneratorWindow.getName());
GUI.loopGeneratorText[4].setPosition(5.0, y, false);
GUI.loopGeneratorText[4].setText("Offset");
GUI.loopGeneratorText[4].setProperty("Font", "tahoma#8#1");

GUI.loopGeneratorText[5] <- GUIText();
GUI.loopGeneratorText[5].setParent(GUI.loopGeneratorWindow.getName());
GUI.loopGeneratorText[5].setPosition(100.0, y, false);
GUI.loopGeneratorText[5].setText("Pieces");
GUI.loopGeneratorText[5].setProperty("Font", "tahoma#8#1");

y += 15.0;

GUI.loopGeneratorEditBox[4] <- GUIEditBox();
GUI.loopGeneratorEditBox[4].setParent(GUI.loopGeneratorWindow.getName());
GUI.loopGeneratorEditBox[4].setPosition(5.0, y, false);
GUI.loopGeneratorEditBox[4].setSize(80.0, 20.0, false);
GUI.loopGeneratorEditBox[4].setText("20"); 

GUI.loopGeneratorEditBox[5] <- GUIEditBox();
GUI.loopGeneratorEditBox[5].setParent(GUI.loopGeneratorWindow.getName());
GUI.loopGeneratorEditBox[5].setPosition(100.0, y, false);
GUI.loopGeneratorEditBox[5].setSize(80.0, 20.0, false);
GUI.loopGeneratorEditBox[5].setText("40"); 

y += 30.0;

GUI.loopSubmitButton <- GUIButton();
GUI.loopSubmitButton.setParent(GUI.loopGeneratorWindow.getName());
GUI.loopSubmitButton.setPosition(5.0, y, false);
GUI.loopSubmitButton.setSize(80.0, 20.0, false);
GUI.loopSubmitButton.setText("Generate");

GUI.loopUndoButton <- GUIButton();
GUI.loopUndoButton.setParent(GUI.loopGeneratorWindow.getName());
GUI.loopUndoButton.setPosition(100.0, y, false);
GUI.loopUndoButton.setSize(80.0, 20.0, false);
GUI.loopUndoButton.setText("Undo");

GUI.editObjectWindow <- GUIWindow();
GUI.editObjectWindow.setPosition(screen[0]-270, screen[1]-145.0, false);
GUI.editObjectWindow.setSize(270.0, 145.0, false);
GUI.editObjectWindow.setText("Edit object");
GUI.editObjectWindow.setVisible(false);

GUI.editObjectText <- {};
GUI.editObjectEditBox <- {};
y = 8.0;
GUI.editObjectText[0] <- GUIText();
GUI.editObjectText[0].setParent(GUI.editObjectWindow.getName());
GUI.editObjectText[0].setPosition(5.0, y, false);
GUI.editObjectText[0].setText("Position");
GUI.editObjectText[0].setProperty("Font", "tahoma#8#1");

y += 15.0;

GUI.editObjectEditBox[0] <- GUIEditBox();
GUI.editObjectEditBox[0].setParent(GUI.editObjectWindow.getName());
GUI.editObjectEditBox[0].setPosition(5.0, y, false);
GUI.editObjectEditBox[0].setSize(80.0, 20.0, false);
GUI.editObjectEditBox[0].setText("0.0");

GUI.editObjectEditBox[1] <- GUIEditBox();
GUI.editObjectEditBox[1].setParent(GUI.editObjectWindow.getName());
GUI.editObjectEditBox[1].setPosition(90.0, y, false);
GUI.editObjectEditBox[1].setSize(80.0, 20.0, false);
GUI.editObjectEditBox[1].setText("0.0");

GUI.editObjectEditBox[2] <- GUIEditBox();
GUI.editObjectEditBox[2].setParent(GUI.editObjectWindow.getName());
GUI.editObjectEditBox[2].setPosition(175.0, y, false);
GUI.editObjectEditBox[2].setSize(80.0, 20.0, false);
GUI.editObjectEditBox[2].setText("0.0"); 

y += 25.0;

GUI.editObjectText[1] <- GUIText();
GUI.editObjectText[1].setParent(GUI.editObjectWindow.getName());
GUI.editObjectText[1].setPosition(5.0, y, false);
GUI.editObjectText[1].setText("Rotation:");
GUI.editObjectText[1].setProperty("Font", "tahoma#8#1");

y += 15.0;

GUI.editObjectEditBox[3] <- GUIEditBox();
GUI.editObjectEditBox[3].setParent(GUI.editObjectWindow.getName());
GUI.editObjectEditBox[3].setPosition(5.0, y, false);
GUI.editObjectEditBox[3].setSize(80.0, 20.0, false);
GUI.editObjectEditBox[3].setText("0.0");

GUI.editObjectEditBox[4] <- GUIEditBox();
GUI.editObjectEditBox[4].setParent(GUI.editObjectWindow.getName());
GUI.editObjectEditBox[4].setPosition(90.0, y, false);
GUI.editObjectEditBox[4].setSize(80.0, 20.0, false);
GUI.editObjectEditBox[4].setText("0.0");

GUI.editObjectEditBox[5] <- GUIEditBox();
GUI.editObjectEditBox[5].setParent(GUI.editObjectWindow.getName());
GUI.editObjectEditBox[5].setPosition(175.0, y, false);
GUI.editObjectEditBox[5].setSize(80.0, 20.0, false);
GUI.editObjectEditBox[5].setText("0.0");
 
y += 30.0;

GUI.editObjectSetButton <- GUIButton();
GUI.editObjectSetButton.setParent(GUI.editObjectWindow.getName());
GUI.editObjectSetButton.setPosition(50.0, y, false);
GUI.editObjectSetButton.setSize(80.0, 20.0, false);
GUI.editObjectSetButton.setText("Set");

GUI.editObjectCloseButton <- GUIButton();
GUI.editObjectCloseButton.setParent(GUI.editObjectWindow.getName());
GUI.editObjectCloseButton.setPosition(140.0, y, false);
GUI.editObjectCloseButton.setSize(80.0, 20.0, false);
GUI.editObjectCloseButton.setText("Close");

function onKeyPress(key, status) {
	local movingKeys = (key == "w" || key == "s" || key == "a" || key == "d" || key == "arrow_up" || key == "arrow_down");
	
	if(key == "ctrl") ctrlPressed = (status == "down");
	if(!ctrlPressed || (status == "up" && movingKeys)) triggerServerEvent("stopMovingObject");
	
	if(status == "down") {
		if(key == "space") {
			triggerServerEvent("moveMagicCarpet", 1);
		} else if(key == "shift") {
			triggerServerEvent("moveMagicCarpet", -1);
		} else if(!ctrlPressed && movingKeys) {
			triggerServerEvent("moveObject", key);
		} else if(!ctrlPressed && key == "r") {
			triggerServerEvent("toggleObjectRotation");
		} else if(ctrlPressed && movingKeys) {
			triggerServerEvent("startMovingObject", key);
		}
		
		if(currentWindow != "") {
			if(key == "x" && ctrlPressed) {
				onWindowClose(currentWindow, 0);
			} else if(key == "enter") {
				switch(currentWindow) {
					case GUI.objListWindow.getName():
						onButtonClick(GUI.selectButton.getName(), 0);
					break;
					
					case GUI.searchWindow.getName():
						onButtonClick(GUI.searchSubmitButton.getName(), 0);
					break;
					
					case GUI.loopGeneratorWindow.getName():
						onButtonClick(GUI.loopSubmitButton.getName(), 0);
					break;
					
					case GUI.editObjectWindow.getName():
						onButtonClick(GUI.editObjectSetButton.getName(), 0);
					break;
				}
			} else if(key == "z" && ctrlPressed) {
				switch(currentWindow) {
					case GUI.objListWindow.getName():
						onButtonClick(GUI.undoButton.getName(), 0);
					break;
					
					case GUI.loopGeneratorWindow.getName():
						onButtonClick(GUI.loopUndoButton.getName(), 0);
					break;
				}
			}
		}
		
		if(currentWindow == GUI.objListWindow.getName()) {
			if(key == "arrow_down") {
				onButtonClick(GUI.nextButton.getName(), 0);
			} else if(key == "arrow_up") {
				onButtonClick(GUI.prevButton.getName(), 0);
			} else if(key == "arrow_right" && ctrlPressed) {
				onButtonClick(GUI.lastpButton.getName(), 0);
			} else if(key == "arrow_left" && ctrlPressed) {
				onButtonClick(GUI.firstpButton.getName(), 0);
			} else if(key == "arrow_right") {
				onButtonClick(GUI.nextpButton.getName(), 0);
			} else if(key == "arrow_left") {
				onButtonClick(GUI.prevpButton.getName(), 0);
			} else if(key == "c" && ctrlPressed) {
				onButtonClick(GUI.categoriesButton.getName(), 0);
			} else if(key == "s" && ctrlPressed) {
				onButtonClick(GUI.searchButton.getName(), 0);
			}
		}
	}
}
addEvent("keyPress", onKeyPress);

function toggleObjectList(visible) {
	currentWindow = (visible ? GUI.objListWindow.getName() : "");
	GUI.objListWindow.setVisible(visible);
	guiToggleCursor(visible);
	if(currentCatItems.len() == 0) {
		onButtonClick(GUI.categoriesButton.getName(), 0);
	}
}
addEvent("toggleObjectList", toggleObjectList);

function toggleLoopGenerator(visible, objID) {
	currentWindow = (visible ? GUI.loopGeneratorWindow.getName() : "");
	GUI.loopGeneratorWindow.setVisible(visible);
	guiToggleCursor(visible);
	GUI.loopGeneratorEditBox[0].setText(objID.tostring()); 
}
addEvent("toggleLoopGenerator", toggleLoopGenerator);

function toggleEditObject(visible, object) {
	currentWindow = (visible ? GUI.editObjectWindow.getName() : "");
	GUI.editObjectWindow.setVisible(visible);
	guiToggleCursor(visible);
	GUI.editObjectEditBox[0].setText(object[1].tostring());
	GUI.editObjectEditBox[1].setText(object[2].tostring());
	GUI.editObjectEditBox[2].setText(object[3].tostring());
	GUI.editObjectEditBox[3].setText(object[4].tostring());
	GUI.editObjectEditBox[4].setText(object[5].tostring());
	GUI.editObjectEditBox[5].setText(object[6].tostring());
}
addEvent("toggleEditObject", toggleEditObject);

function loadObjects(objects) {
	objList = objects;
}
addEvent("loadObjects", loadObjects);

function onWindowClose(wndName, wndState) {
	currentWindow = "";
	if(wndName == GUI.objListWindow.getName()) {
		triggerServerEvent("playerCommand", "/osel");
	} else if(wndName == GUI.loopGeneratorWindow.getName()) {
		triggerServerEvent("playerCommand", "/oloop");
	} else if(wndName == GUI.editObjectWindow.getName()) {
		triggerServerEvent("playerCommand", "/oedit");
	} else if(wndName == GUI.searchWindow.getName()) {
		GUI.searchWindow.setVisible(false);
		GUI.searchEditBox.setText(""); 
		currentWindow = GUI.objListWindow.getName();
	}
}
addEvent("windowClose", onWindowClose);

function onButtonClick(btnName, bState) {
    if(btnName == GUI.nextButton.getName()) {
		GUI.item[currentItem].setProperty("TextColours", "FFFFFFFF");
		currentItem++;
		if(currentItem == currentPageItems.len()) currentItem = 0;
		GUI.item[currentItem].setProperty("TextColours", "FFFF9900");
    } else if(btnName == GUI.prevButton.getName()) {
		GUI.item[currentItem].setProperty("TextColours", "FFFFFFFF");
		currentItem--;
		if(currentItem == -1) currentItem = currentPageItems.len()-1;
		GUI.item[currentItem].setProperty("TextColours", "FFFF9900");
    } else if(btnName == GUI.selectButton.getName()) {
		if(currentCat == "") {
			currentCat = format("%c", currentPageItems[currentItem][0]);
			currentCatItems = {};
			local i = 0;
			foreach(y,val in objList) {
				if(currentCat.tolower() == val[1].slice(0, 1).tolower()) {
					currentCatItems[i] <- [val[0], val[1]];
					i++;
				}
			}
			if(i == 0) {
				guiShowMessageBox("This category is empty", "No objects");
				onButtonClick(GUI.categoriesButton.getName(), 0);
			} else {
				resetCurrentItem();
				numPages = ceil(currentCatItems.len() / itemsPerPage.tofloat());
				currentPage = 1;
				loadPage();
			}
		} else {
			local id = -1;
			foreach(i,val in objList) {
				if(val[0] == currentPageItems[currentItem][0]) {
					id = i;
					break;
				}
			}
			triggerServerEvent("playerCommand", "/oc "+id);
		}
	} else if(btnName == GUI.nextpButton.getName()) {
		currentPage++;
		if(currentPage > numPages) currentPage = 1;
		loadPage();
	} else if(btnName == GUI.prevpButton.getName()) {
		currentPage--;
		if(currentPage < 1) currentPage = numPages.tointeger();
		loadPage();
	} else if(btnName == GUI.firstpButton.getName()) {
		currentPage = 1;
		loadPage();
	} else if(btnName == GUI.lastpButton.getName()) {
		currentPage = numPages.tointeger();
		loadPage();
	} else if(btnName == GUI.categoriesButton.getName()) {
		currentCatItems = {};
		currentCatItems[0] <- [48, "Static models hashes 0"];
		for(local i = 65; i <= 89; i++) {
			currentCatItems[i-64] <- [i, "Static models hashes "+format("%c", i)];
		}
		resetCurrentItem();
		numPages = ceil(currentCatItems.len() / itemsPerPage.tofloat());
		currentPage = 1;
		currentCat = "";
		loadPage();
	} else if(btnName == GUI.undoButton.getName()) {
		triggerServerEvent("playerCommand", "/od");
	} else if(btnName == GUI.searchButton.getName()) {
		currentWindow = GUI.searchWindow.getName();
		GUI.searchWindow.setVisible(true);
	} else if(btnName == GUI.searchSubmitButton.getName()) {
		currentCatItems = {};
		local name = GUI.searchEditBox.getText().tolower();
		local i = 0;
		foreach(y,val in objList) {
			if(val[1].tolower().find(name) != null) {
				currentCatItems[i] <- [val[0], val[1]];
				i++;
			}
		}
		resetCurrentItem();
		numPages = ceil(currentCatItems.len() / itemsPerPage.tofloat());
		currentPage = 1;
		currentCat = "SEARCH";
		loadPage();
		onWindowClose(GUI.searchWindow.getName(), 0);
	} else if(btnName == GUI.searchCloseButton.getName()) {
		onWindowClose(GUI.searchWindow.getName(), 0);
	} else if(btnName == GUI.loopSubmitButton.getName()) {
		triggerServerEvent("generateLoopEvent", GUI.loopGeneratorEditBox[0].getText().tointeger(), GUI.loopGeneratorEditBox[5].getText().tointeger(), GUI.loopGeneratorEditBox[4].getText().tointeger(), GUI.loopGeneratorEditBox[1].getText().tointeger(), GUI.loopGeneratorEditBox[2].getText(), GUI.loopGeneratorEditBox[3].getText().tofloat());
	} else if(btnName == GUI.loopUndoButton.getName()) {
		triggerServerEvent("undoLoop");
	} else if(btnName == GUI.editObjectSetButton.getName()) {
		local object = [
			0,
			GUI.editObjectEditBox[0].getText().tofloat(),
			GUI.editObjectEditBox[1].getText().tofloat(),
			GUI.editObjectEditBox[2].getText().tofloat(),
			GUI.editObjectEditBox[3].getText().tofloat(),
			GUI.editObjectEditBox[4].getText().tofloat(),
			GUI.editObjectEditBox[5].getText().tofloat()
		];
		triggerServerEvent("setObjectData", object);
	} else if(btnName == GUI.editObjectCloseButton.getName()) {
		onWindowClose(GUI.editObjectWindow.getName(), 0);
	}
}
addEvent("buttonClick", onButtonClick);

function loadPage() {
	local limit = itemsPerPage*(currentPage-1);
	currentPageItems = {};
	for(local i = 0; i < itemsPerPage; i++) {
		if(currentCatItems.rawin(limit)) {
			currentPageItems[i] <- currentCatItems[limit];
			GUI.item[i].setText(currentPageItems[i][1]);
			limit++;
		} else {
			GUI.item[i].setText("");
		}
	}
	GUI.objListWindow.setText("Select object (page "+currentPage+"/"+numPages+")");
	resetCurrentItem();
}

function resetCurrentItem() {
	GUI.item[currentItem].setProperty("TextColours", "FFFFFFFF");
	GUI.item[0].setProperty("TextColours", "FFFF9900");
	currentItem = 0;
}