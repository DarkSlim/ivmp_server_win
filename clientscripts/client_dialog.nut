/*
 * Dialoguue system v2.0
 * Author: Roox
 */
 
local screen = guiGetScreenSize();
//-----| Gui
local GUIDIalogId = 0;
local GUIDialogMSGBox = {};
local GUIDialogInput = {};
local GUIDialogList = {};
local GUIDialogListButtonsChosen = 0;
local GUIDialogListButtonsNow = 0;
local GUIDialogListButtons = 5;
local GUIDialogMSGBoxTextsNow = 0;
local GUIDialogMSGBoxTexts = 2;
local GUIDialogInputTextsNow = 0;
local GUIDialogInputTexts = 2;
local GUIDialogLineSize = 13.0;

// Main window
GUIDialogMSGBox.window <- GUIWindow();
GUIDialogMSGBox.window.setPosition(screen[0]/2-230, screen[1]/2-85, false);
GUIDialogMSGBox.window.setSize(460.0, 130.0, false);
GUIDialogMSGBox.window.setText("Window text");
GUIDialogMSGBox.window.setVisible(false);
 
// Buttons
GUIDialogMSGBox.firstbutton <- GUIButton();
GUIDialogMSGBox.firstbutton.setParent(GUIDialogMSGBox.window.getName());
GUIDialogMSGBox.firstbutton.setPosition(50.0, 70.0, false);
GUIDialogMSGBox.firstbutton.setSize(170.0, 30.0, false);
GUIDialogMSGBox.firstbutton.setText("Button 1");
GUIDialogMSGBox.firstbutton.setProperty("NormalTextColour", "FFFFFFFF");

GUIDialogMSGBox.secondbutton <- GUIButton();
GUIDialogMSGBox.secondbutton.setParent(GUIDialogMSGBox.window.getName());
GUIDialogMSGBox.secondbutton.setPosition(240.0, 70.0, false);
GUIDialogMSGBox.secondbutton.setSize(170.0, 30.0, false);
GUIDialogMSGBox.secondbutton.setText("Button 2");
GUIDialogMSGBox.secondbutton.setProperty("NormalTextColour", "FFFFFFFF");

// Main window
GUIDialogInput.window <- GUIWindow();
GUIDialogInput.window.setPosition(screen[0]/2-230, screen[1]/2-85, false);
GUIDialogInput.window.setSize(460.0, 150.0, false);
GUIDialogInput.window.setText("Window text");
GUIDialogInput.window.setVisible(false);
 
// Input edit box
GUIDialogInput.inputtext <- GUIEditBox();
GUIDialogInput.inputtext.setParent(GUIDialogInput.window.getName());
GUIDialogInput.inputtext.setPosition(20.0, 42.0, false);
GUIDialogInput.inputtext.setSize(410.0, 20.0, false);
GUIDialogInput.inputtext.setProperty("BlinkCaret", "true");
GUIDialogInput.inputtext.setProperty("BlinkCaretTimeout", "1.0");
GUIDialogInput.inputtext.setProperty("Font", "tahoma");
GUIDialogInput.inputtext.setProperty("SelectedTextColour", "FF0000FF");
 
// Buttons
GUIDialogInput.firstbutton <- GUIButton();
GUIDialogInput.firstbutton.setParent(GUIDialogInput.window.getName());
GUIDialogInput.firstbutton.setPosition(50.0, 90.0, false);
GUIDialogInput.firstbutton.setSize(170.0, 30.0, false);
GUIDialogInput.firstbutton.setText("Button 1");
GUIDialogInput.firstbutton.setProperty("NormalTextColour", "FFFFFFFF");

GUIDialogInput.secondbutton <- GUIButton();
GUIDialogInput.secondbutton.setParent(GUIDialogInput.window.getName());
GUIDialogInput.secondbutton.setPosition(240.0, 90.0, false);
GUIDialogInput.secondbutton.setSize(170.0, 30.0, false);
GUIDialogInput.secondbutton.setText("Button 2");
GUIDialogInput.secondbutton.setProperty("NormalTextColour", "FFFFFFFF");

// Main window
GUIDialogList.window <- GUIWindow();
GUIDialogList.window.setPosition(screen[0]/2-230, screen[1]/2-85, false);
GUIDialogList.window.setSize(460.0, 150.0, false);
GUIDialogList.window.setText("Window text");
GUIDialogList.window.setVisible(false);
	
// Buttons
GUIDialogList.firstbutton <- GUIButton();
GUIDialogList.firstbutton.setParent(GUIDialogList.window.getName());
GUIDialogList.firstbutton.setPosition(50.0, 70.0, false);
GUIDialogList.firstbutton.setSize(170.0, 30.0, false);
GUIDialogList.firstbutton.setText("Button 1");
GUIDialogList.firstbutton.setProperty("NormalTextColour", "FFFFFFFF");

GUIDialogList.secondbutton <- GUIButton();
GUIDialogList.secondbutton.setParent(GUIDialogList.window.getName());
GUIDialogList.secondbutton.setPosition(240.0, 70.0, false);
GUIDialogList.secondbutton.setSize(170.0, 30.0, false);
GUIDialogList.secondbutton.setText("Button 2");
GUIDialogList.secondbutton.setProperty("NormalTextColour", "FFFFFFFF");

function onScriptInit()
{
	GUIDialogList.button <- array(GUIDialogListButtons, null);
	for(local i = 0; i < GUIDialogListButtons; i++)
	{
		GUIDialogList.button[i] = GUIButton();
		GUIDialogList.button[i].setParent(GUIDialogList.window.getName());
		GUIDialogList.button[i].setPosition(50.0, 50.0 + (i*20.0).tofloat(), false);
		GUIDialogList.button[i].setSize(360.0, 20.0, false);
		GUIDialogList.button[i].setText("Button " + i);
		GUIDialogList.button[i].setProperty("NormalTextColour", "FFFFFFFF");
	}
	
	// MSG Box
	GUIDialogMSGBox.text <- array(GUIDialogMSGBoxTexts, null);
	for(local i = 0; i < GUIDialogMSGBoxTexts; i++)
	{
		GUIDialogMSGBox.text[i] = GUIText();
		GUIDialogMSGBox.text[i].setParent(GUIDialogMSGBox.window.getName());
		GUIDialogMSGBox.text[i].setPosition(20.0, 10.0 + (i*GUIDialogLineSize).tofloat(), false);
		GUIDialogMSGBox.text[i].setText(" ");
		GUIDialogMSGBox.text[i].setProperty("Font", "tahoma");
	}
	
	GUIDialogInput.text <- array(GUIDialogInputTexts, null);
	for(local i = 0; i < GUIDialogInputTexts; i++)
	{
		GUIDialogInput.text[i] = GUIText();
		GUIDialogInput.text[i].setParent(GUIDialogInput.window.getName());
		GUIDialogInput.text[i].setPosition(20.0, 10.0 + (i*GUIDialogLineSize).tofloat(), false);
		GUIDialogInput.text[i].setText(" ");
		GUIDialogInput.text[i].setProperty("Font", "tahoma");
	}
	return 1;
}
addEvent("scriptInit", onScriptInit);

function onButtonClick(btnName, bState)
{
	if(btnName == GUIDialogMSGBox.firstbutton.getName() || btnName == GUIDialogMSGBox.secondbutton.getName())
	{
		local response;
		if(btnName == GUIDialogMSGBox.firstbutton.getName()) response = 1;
		else response = 0;
		
		triggerServerEvent("client_dialog_response", GUIDIalogId, response, 0, "Null");
		
		GUIDialogMSGBox.window.setVisible(false);
		for(local i = 0; i < GUIDialogMSGBoxTextsNow; i++)
		{
			GUIDialogMSGBox.text[i].setVisible(false);
		}
		GUIDialogMSGBox.firstbutton.setVisible(false);
		GUIDialogMSGBox.secondbutton.setVisible(false);
		guiToggleCursor(false);
		GUIDIalogId = 0;
		GUIDialogMSGBoxTextsNow = 0;
	}
	else if(btnName == GUIDialogInput.firstbutton.getName() || btnName == GUIDialogInput.secondbutton.getName())
	{
		local response;
		if(btnName == GUIDialogInput.firstbutton.getName()) response = 1;
		else response = 0;
		
		triggerServerEvent("client_dialog_response", GUIDIalogId, response, 0, GUIDialogInput.inputtext.getText());
		
		GUIDialogInput.window.setVisible(false);
		for(local i = 0; i < GUIDialogInputTextsNow; i++)
		{
			GUIDialogInput.text[i].setVisible(false);
		}
		GUIDialogInput.inputtext.setVisible(false);
		GUIDialogInput.firstbutton.setVisible(false);
		GUIDialogInput.secondbutton.setVisible(false);
		guiToggleCursor(false);
		GUIDIalogId = 0;
		GUIDialogInputTextsNow = 0;
	}
	else if(btnName == GUIDialogList.firstbutton.getName() || btnName == GUIDialogList.secondbutton.getName())
	{
		local response;
		if(btnName == GUIDialogList.firstbutton.getName()) response = 1;
		else response = 0;
		
		triggerServerEvent("client_dialog_response", GUIDIalogId, response, GUIDialogListButtonsChosen, GUIDialogList.button[GUIDialogListButtonsChosen].getText());

		for(local a = 0; a < GUIDialogListButtonsNow; a++)
		{
			GUIDialogList.button[a].setVisible(false);
			GUIDialogList.button[a].setProperty("NormalTextColour", "FFFFFFFF");
			GUIDialogList.button[a].setProperty("HoverTextColour", "FFFFFFFF");
		}
					
		GUIDialogList.window.setVisible(false);
		GUIDialogList.firstbutton.setVisible(false);
		GUIDialogList.secondbutton.setVisible(false);
		guiToggleCursor(false);
		GUIDIalogId = 0;
	}
	else
	{
		for(local i = 0; i < GUIDialogListButtonsNow; i++)
		{
			if(btnName == GUIDialogList.button[i].getName())
			{
				if(i == GUIDialogListButtonsChosen)
				{
					triggerServerEvent("client_dialog_response", GUIDIalogId, 1, i, GUIDialogList.button[i].getText());

					for(local a = 0; a < GUIDialogListButtonsNow; a++)
					{
						GUIDialogList.button[a].setVisible(false);
						GUIDialogList.button[a].setProperty("NormalTextColour", "FFFFFFFF");
						GUIDialogList.button[a].setProperty("HoverTextColour", "FFFFFFFF");
					}
					
					GUIDialogList.window.setVisible(false);
					GUIDialogList.firstbutton.setVisible(false);
					GUIDialogList.secondbutton.setVisible(false);
					guiToggleCursor(false);
					GUIDIalogId = 0;
				}
				else
				{
					GUIDialogList.button[GUIDialogListButtonsChosen].setProperty("NormalTextColour", "FFFFFFFF");
					GUIDialogList.button[GUIDialogListButtonsChosen].setProperty("HoverTextColour", "FFFFFFFF");
					GUIDialogList.button[i].setProperty("NormalTextColour", "FFFF0000");
					GUIDialogList.button[i].setProperty("HoverTextColour", "FFFF0000");
					GUIDialogListButtonsChosen = i;
				}
				break;
			}
		}
	}
	return 1;
}
addEvent("buttonClick", onButtonClick);

function showGUIDialog(id, type, windowtext, maintext, firstbuttontext, secondbuttontext)
{
	if(type == 0)
	{
		GUIDIalogId = id;
		GUIDialogMSGBox.window.setText(windowtext);
		GUIDialogMSGBox.firstbutton.setText(firstbuttontext);
		GUIDialogMSGBox.secondbutton.setText(secondbuttontext);
		
		local text = split(maintext, "\n");
		GUIDialogMSGBox.window.setSize(460.0, 130.0 + ((text.len()-1)*GUIDialogLineSize), false);
		
		if(text.len() > GUIDialogMSGBoxTexts)
		{
			GUIDialogMSGBox.text <- array(text.len(), null);
			for(local i = 0; i < text.len(); i++)
			{
				GUIDialogMSGBox.text[i] = GUIText();
				GUIDialogMSGBox.text[i].setParent(GUIDialogMSGBox.window.getName());
				GUIDialogMSGBox.text[i].setPosition(20.0, 10.0 + (i*GUIDialogLineSize).tofloat(), false);
				GUIDialogMSGBox.text[i].setText(text[i]);
				GUIDialogMSGBox.text[i].setProperty("Font", "tahoma");
				GUIDialogMSGBox.text[i].setVisible(true);
			}
			
			GUIDialogMSGBoxTexts = text.len();
			GUIDialogMSGBoxTextsNow = text.len();
		}
		else
		{
			for(local i = 0; i < text.len(); i++)
			{
				GUIDialogMSGBox.text[i].setText(text[i]);
				GUIDialogMSGBox.text[i].setVisible(true);
			}
			
			for(local i = text.len(); i < GUIDialogMSGBoxTexts; i++)
			{
				GUIDialogMSGBox.text[i].setVisible(false);
			}
			
			GUIDialogMSGBoxTextsNow = text.len();
		}
		
		GUIDialogMSGBox.window.setVisible(true);
		GUIDialogMSGBox.firstbutton.setVisible(true);
		guiToggleCursor(true);
		
		if(secondbuttontext == "")
		{
			GUIDialogMSGBox.firstbutton.setPosition(145.0, 70.0 + ((text.len()-1)*GUIDialogLineSize), false);
			GUIDialogMSGBox.secondbutton.setVisible(false);
		}
		else
		{
			GUIDialogMSGBox.firstbutton.setPosition(50.0, 70.0 + ((text.len()-1)*GUIDialogLineSize), false);
			GUIDialogMSGBox.secondbutton.setPosition(240.0, 70.0 + ((text.len()-1)*GUIDialogLineSize), false);
			GUIDialogMSGBox.secondbutton.setVisible(true);
		}
		
		GUIDialogMSGBox.window.setPosition(screen[0]/2-220, screen[1]/2-85-(text.len()*GUIDialogLineSize/2), false);
	}
	else if(type == 1)
	{
		GUIDIalogId = id;
		GUIDialogInput.window.setText(windowtext);
		GUIDialogInput.firstbutton.setText(firstbuttontext);
		GUIDialogInput.secondbutton.setText(secondbuttontext);
		GUIDialogInput.inputtext.setText("");
		
		local text = split(maintext, "\n");
		GUIDialogInput.window.setSize(460.0, 150.0 + ((text.len()-1)*GUIDialogLineSize), false);
		if(text.len() > GUIDialogInputTexts)
		{
			GUIDialogInput.text <- array(text.len(), null);
			for(local i = 0; i < text.len(); i++)
			{
				GUIDialogInput.text[i] = GUIText();
				GUIDialogInput.text[i].setParent(GUIDialogInput.window.getName());
				GUIDialogInput.text[i].setPosition(20.0, 10.0 + (i*GUIDialogLineSize).tofloat(), false);
				GUIDialogInput.text[i].setText(text[i]);
				GUIDialogInput.text[i].setProperty("Font", "tahoma");
				GUIDialogInput.text[i].setVisible(true);
			}
			GUIDialogInputTexts = text.len();
			GUIDialogInputTextsNow = text.len();
		}
		else
		{
			for(local i = 0; i < text.len(); i++)
			{
				GUIDialogInput.text[i].setText(text[i]);
				GUIDialogInput.text[i].setVisible(true);
			}
			
			for(local i = text.len(); i < GUIDialogInputTexts; i++)
			{
				GUIDialogInput.text[i].setVisible(false);
			}
			
			GUIDialogInputTextsNow = text.len();
		}
		
		GUIDialogInput.window.setVisible(true);
		GUIDialogInput.inputtext.setVisible(true);
		GUIDialogInput.firstbutton.setVisible(true);
		guiToggleCursor(true);
		
		if(secondbuttontext == "")
		{
			GUIDialogInput.firstbutton.setPosition(145.0, 90.0 + ((text.len()-1)*GUIDialogLineSize), false);
			GUIDialogInput.secondbutton.setVisible(false);
		}
		else
		{
			GUIDialogInput.firstbutton.setPosition(50.0, 90.0 + ((text.len()-1)*GUIDialogLineSize), false);
			GUIDialogInput.secondbutton.setPosition(240.0, 90.0 + ((text.len()-1)*GUIDialogLineSize), false);
			GUIDialogInput.secondbutton.setVisible(true);
		}

		GUIDialogInput.inputtext.setPosition(20.0, 42.0 + ((text.len()-1)*GUIDialogLineSize), false);
		GUIDialogInput.window.setPosition(screen[0]/2-230, screen[1]/2-85-(text.len()*GUIDialogLineSize/2), false);
	}
	else
	{
		GUIDIalogId = id;
		GUIDialogList.window.setText(windowtext);
		GUIDialogList.firstbutton.setText(firstbuttontext);
		GUIDialogList.secondbutton.setText(secondbuttontext);
		
		local text = split(maintext, "\n");
		GUIDialogList.window.setSize(460.0, 150.0 + ((text.len())*20.0), false);
		GUIDialogListButtonsChosen = 0;
		
		if(text.len() > GUIDialogListButtons)
		{
			GUIDialogList.button <- array(text.len(), null);
			for(local i = 0; i < text.len(); i++)
			{
				GUIDialogList.button[i] = GUIButton();
				GUIDialogList.button[i].setParent(GUIDialogList.window.getName());
				GUIDialogList.button[i].setPosition(50.0, 50.0 + (i*20.0).tofloat(), false);
				GUIDialogList.button[i].setSize(360.0, 20.0, false);
				GUIDialogList.button[i].setText(text[i]);
				GUIDialogList.button[i].setProperty("NormalTextColour", "FFFFFFFF");
				GUIDialogList.button[i].setVisible(true);
			}
			
			GUIDialogListButtons = text.len();
			GUIDialogListButtonsNow = text.len();
		}
		else
		{	
			for(local i = 0; i < text.len(); i++)
			{
				GUIDialogList.button[i].setText(text[i]);
				GUIDialogList.button[i].setVisible(true);
			}
			
			for(local i = text.len(); i < GUIDialogListButtons; i++)
			{
				GUIDialogList.button[i].setVisible(false);
			}
			
			GUIDialogListButtonsNow = text.len();
		}
		
		GUIDialogList.button[GUIDialogListButtonsChosen].setProperty("NormalTextColour", "FFFF0000");
		GUIDialogList.button[GUIDialogListButtonsChosen].setProperty("HoverTextColour", "FFFF0000");
		
		GUIDialogList.window.setVisible(true);
		GUIDialogList.firstbutton.setVisible(true);
		guiToggleCursor(true);
		
		if(secondbuttontext == "")
		{
			GUIDialogList.firstbutton.setPosition(145.0, 70.0 + (text.len() * 20), false);
			GUIDialogList.secondbutton.setVisible(false);
		}
		else
		{
			GUIDialogList.firstbutton.setPosition(50.0, 70.0 + (text.len() * 20), false);
			GUIDialogList.secondbutton.setPosition(240.0, 70.0 + (text.len() * 20), false);
			GUIDialogList.secondbutton.setVisible(true);
		}
		GUIDialogList.window.setPosition(screen[0]/2-220, screen[1]/2-85-(text.len()*10), false);
	}
	return true;
}
addEvent("server_show_dialog", showGUIDialog);