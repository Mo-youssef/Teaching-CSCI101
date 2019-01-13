function varargout = magic_gui(varargin)
% Tutorial m-file to demonstrate the operation of various controls
% such as listbox, radio button, checkbox, push button, static text, and axes.
% Requires the Image Processing Toolbox, but could easily be modified to work without it (just remove references to histograms).
%
% Written by Mark Hayworth, Ph.D.
% Imaging Section, Corporate Functions Analytical
% email: hayworth dot ms at pg dot com
% The Procter & Gamble Company, Cincinnati, Ohio, USA.
% December 2008 - April 2017.
% Updated April 13, 2015:
%       (1) got rid of image masking (was too complicated for novice users)
%       (2) got rid of image analysis (was too complicated for novice users)
%       (3) Now save some GUI settings to a mat file,
%       (4) Not using aviread anymore since it's not supported by R2015a.
%       (5) Changed the way the GUI was maximized.
%
% magic_gui M-file for magic_gui.fig
%      magic_gui by itself, creates a new magic_gui or raises the existing
%      singleton*.
%
%      H = magic_gui returns the handle to a new magic_gui or the handle to
%      the existing singleton*.
%
%      magic_gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in magic_gui.M with the given input arguments.
%
%      magic_gui('Property','Value',...) creates a new magic_gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before magic_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to magic_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help magic_gui

% Last Modified by GUIDE v2.5 07-Aug-2017 21:41:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
	'gui_Singleton',  gui_Singleton, ...
	'gui_OpeningFcn', @magic_gui_OpeningFcn, ...
	'gui_OutputFcn',  @magic_gui_OutputFcn, ...
	'gui_LayoutFcn',  [], ...
	'gui_Callback',   []);
if nargin && ischar(varargin{1})
	gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
	[varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
	gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before magic_gui is made visible.
function magic_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to magic_gui (see VARARGIN)

% Choose default command line output for magic_gui
handles.output = true; % Just indicate that it ran successfully

%===================================================================================================================
% --- My Startup Code --------------------------------------------------
% Clear old stuff from console.
clc;
% Print informational message so you can look in the command window and see the order of program flow.
fprintf(1, 'Just entered magic_gui_OpeningFcn...\n');
% MATLAB QUIRK: Need to clear out any global variables you use anywhere
% otherwise it will remember their prior values from a prior running of the macro.
% (I'm not using any global variables in this program, so I commented it out.  Put it back in if you do put in and use any global variables.)
% clear global;
try
	% Initialize some variables.
	handles.programFolder = cd; % Initialize folder where this .m and .fig file live.
	handles.imageFolder = cd; % Initialize folder where the image files live.  Presumably they will click the button to change this.
	set(handles.figMainWindow, 'Visible', 'off');
	
	% Load up the initial values from the mat file - the values of the checkboxes, last folder used, etc.
	handles = LoadUserSettings(handles);
	
	% If the last-used image folder does not exist, but the imdemos folder exists, then point them to that MATLAB image demos folder instead.
	if exist(handles.imageFolder, 'dir') == 0
		% Folder stored in the mat file does not exist.  Try the imdemos folder instead.
		% This is where the standard demo images that ship with MATLAB's Imge Processing Toolbox live.
		imdemosFolder = fileparts(which('cameraman.tif')); % Determine where demo images folder is (works with all versions of MATLAB).
		if exist(imdemosFolder, 'dir') == 0
			% imdemos folder exists.  Use it.
			handles.imageFolder = imdemosFolder;
		else
			% imdemos folder does not exist.  Use current folder.
			handles.imageFolder = cd;
		end
	end
	% handles.imageFolder will be a valid, existing folder by the time you get here.
	set(handles.txtFolder, 'string', handles.imageFolder);
	
	%msgboxh(handles.imageFolder);
	% Load list of images in the image folder.
	handles = LoadImageList(handles);
	% Select none of the items in the listbox.
	set(handles.lstImageList, 'value', []);
	% Update the number of images in the Analyze button caption.
	UpdateAnalyzeButtonCaption(handles);
	% Set up scrollbar captions.
	ScrollBarMoved(handles);
	
	% Load a splash image.
	%axes(handles.axesImage);
	fullSplashImageName = fullfile(handles.programFolder, '/Splash Images/Magic Hat.png');
	if exist(fullSplashImageName, 'file')
		% Display splash image.
		splashImage = imread(fullSplashImageName);
	else
		% Splash image not found.  Display something so it's not just blank.
		splashImage = peaks(300); % Guaranteed to exist because we're MAKING it!
		fprintf('Warning: Splash image not found: %s\n', fullSplashImageName);
	end
	
	% Display image in the "axesImage" axes control on the user interface.
	hold off;	% IMPORTANT NOTE: hold needs to be off in order for the "fit" feature to work correctly.
	imshow(splashImage, 'InitialMagnification', 'fit', 'parent', handles.axesImage);
	axis off;
	
	txtInfo = sprintf('MAGIC - MATLAB Analysis with Generic Imaging Code.\n\nBy Mark Hayworth, Ph.D.\nThe Procter & Gamble Company\n\nTutorial GUI to demonstrate basic functionality\nof various controls on the GUI.');
	set(handles.txtInfo, 'string', txtInfo);
	
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
% Print informational message so you can look in the command window and see the order of program flow.
fprintf(1, 'Now leaving magic_gui_OpeningFcn.\n');

% Update handles structure
guidata(hObject, handles);
return; % from magic_gui_OpeningFcn()

% --- End of My Startup Code --------------------------------------------------
%===================================================================================================================


%===================================================================================================================
% --- Outputs from this function are returned to the command line.
function varargout = magic_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
	% Print informational message so you can look in the command window and see the order of program flow.
	fprintf(1, 'Just entered magic_gui_OutputFcn...\n');
	% Get default command line output from handles structure
	varargout{1} = handles.output;
	
	% Maximize the window via undocumented Java call.
	% Reference: http://undocumentedmatlab.com/blog/minimize-maximize-figure-window
	MaximizeFigureWindow;
	
	% Print informational message so you can look in the command window and see the order of program flow.
	fprintf(1, 'Now leaving magic_gui_OutputFcn.\n');
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end

%===================================================================================================================
function LoadSplashImage(handles, handleToAxes)
try
	fullSplashImageName = fullfile(handles.programFolder, '/Splash Images/Splash.png');
	
	if exist(fullSplashImageName, 'file')
		% Display splash image.
		imgSplash = imread(fullSplashImageName);
	else
		% Display something
		imgSplash = peaks(300);
	end
	% Display image array in a window on the user interface.
	% Display in axes, storing handle of image for later quirk workaround.
	hold off;	% IMPORTANT NOTE: hold needs to be off in order for the "fit" feature to work correctly.
	imshow(imgSplash, 'InitialMagnification', 'fit', 'parent', handleToAxes);
	axis(handleToAxes, 'off');
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
return; % from 	LoadSplashImage()


%===================================================================================================================
% --- Executes on clicking in lstImageList listbox.
% Display image from disk and plots histogram
function lstImageList_Callback(hObject, eventdata, handles)
% hObject    handle to lstImageList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns lstImageList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstImageList
try
	% Change mouse pointer (cursor) to an hourglass.
	% QUIRK: use 'watch' and you'll actually get an hourglass not a watch.
	set(gcf,'Pointer','watch');
	drawnow;	% Cursor won't change right away unless you do this.
	
	% Update the number of selected images in the Analyze button caption.
	UpdateAnalyzeButtonCaption(handles);
	
	% Get the selected image name, if they selected only one image file.
	% If they selected, none, or multiple, then we can bail out and not display any image.
	selectedListboxItem = get(handles.lstImageList, 'value');
	if isempty(selectedListboxItem)
		% Bail out if nothing was selected.
		% Change mouse pointer (cursor) to an arrow.
		set(gcf,'Pointer','arrow');
		drawnow;	% Cursor won't change right away unless you do this.
		return;
	end
	% If more than one is selected, bail out.
	if length(selectedListboxItem) > 1
		baseImageFileName = '';
		% Change mouse pointer (cursor) to an arrow.
		set(gcf,'Pointer','arrow')
		drawnow;	% Cursor won't change right away unless you do this.
		return;
	end
	
	% Hide the histogram since there are no counts yet, and we want to hide any old histograms that are showing.
	SetAxesVisibility(handles, handles.axesPlot, 0);
	
	% If only one image is selected, display it.
	ListOfImageNames = get(handles.lstImageList, 'string'); % List of ALL filenames in the listbox.
	baseImageFileName = strcat(cell2mat(ListOfImageNames(selectedListboxItem)));
	fullImageFileName = fullfile(handles.imageFolder, baseImageFileName);	% Prepend folder.
	
	[folder, baseFileNameNoExtension, extension] = fileparts(fullImageFileName);
	switch lower(extension)
		case {'.mov', '.wmv', '.asf'}
			msgboxw('Mov and wmv format video files are not supported by MATLAB.');
			% Change mouse pointer (cursor) to an arrow.
			set(gcf,'Pointer','arrow');
			drawnow;	% Cursor won't change right away unless you do this.
			return;
			% 	case '.avi'
			% 		% The only video format supported natively by MATLAB is avi.
			% 		% A more complicated video player plug in is on MATLAB File Central
			% 		% that will support more types of video.  It has a bunch of DLL's and
			% 		% other files that you have to install.
			%
			% 		% Read the file into a MATLAB movie structure.
			% 		myVideo = aviread(fullImageFileName);
			% 		myVideoParameters = aviinfo(fullImageFileName);
			% 		numberOfFrames = myVideoParameters.NumFrames;
			%
			% 		% Extract a frame.
			% 		frameToView = uint8(floor(numberOfFrames/2));	% Take the middle frame.
			% 		imgFirstFrame = myVideo(frameToView).cdata;	% The index is the frame number.
			% 		cla(handles.axesPlot, 'reset');
			% 		imshow(imgFirstFrame, 'Parent', handles.axesPlot); % Display the first frame.
			%
			% 		% Play the movie in the axes.  It doesn't stretch to fit the axes.
			% 		% The macro will wait until it finishes before continuing.
			% 		axes(handles.axesImage);
			% 		hold off;
			% 		cla(handles.axesImage, 'reset'); % Let image resize, for example demo video rhinos.avi won't fill the image buffer if we don't do this.
			% 		movie(handles.axesImage, myVideo);
			% 		cla(handles.axesPlot, 'reset'); % Clear the mini-image from the plot axes.
			%
			% 	    guidata(hObject, handles);
			% 		% Change mouse pointer (cursor) to an arrow.
			% 		set(gcf,'Pointer','arrow');
			% 		drawnow;	% Cursor won't change right away unless you do this.
			% 		return;
		otherwise
			% Display the image.
			theImage = DisplayImage(handles, fullImageFileName);
	end
	
	% If imgOriginal is empty (couldn't be read), just exit.
	if isempty(theImage)
		% Change mouse pointer (cursor) to an arrow.
		set(gcf,'Pointer','arrow');
		drawnow;	% Cursor won't change right away unless you do this.
		return;
	end
	
	% Analyze this image, if it's a valid one.
	if get(handles.chkAutoAnalyze,'Value') && ~isempty(theImage)
		AnalyzeSingleImage(handles, fullImageFileName);
	end
	
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
% Change mouse pointer (cursor) to an arrow.
set(gcf,'Pointer','arrow');
drawnow;	% Cursor won't change right away unless you do this.
guidata(hObject, handles);
return % from lstImageList_Callback()


%===================================================================================================================
% Reads FullImageFileName from disk into the axesImage axes.
function imageArray = DisplayImage(handles, fullImageFileName)
% Try to read in the image.  Bail out if it can't be read with imread().
imageArray = []; % Initialize
try
	[imageArray, colorMap] = imread(fullImageFileName);
	% colorMap will have something for an indexed image (gray scale image with a stored colormap).
	% colorMap will be empty for a true color RGB image or a monochrome gray scale image.
catch ME
	% Will get here if imread() fails, like if the file is not an image file but a text file or Excel workbook or something.
	[~, baseFileNameNoExtension, ext] = fileparts(fullImageFileName);
	baseFileName = [baseFileNameNoExtension, ext];
	errorMessage = sprintf('%s is not a file that can be read with imread().\nYou will have to use another file reader for it.', ...
		baseFileName);
	% 	callStackString = GetCallStack(ME);
	% 	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
	% 		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
	return;	% Skip the rest of this function.
end

try
	% Display image array in a window on the user interface.
	%axes(handles.axesImage);
	hold off;	% IMPORTANT NOTE: hold needs to be off in order for the "fit" feature to work correctly.
	
	% Here we actually display the image in the "axesImage" axes.
	imshow(imageArray, 'InitialMagnification', 'fit', 'parent', handles.axesImage);
	
	% Display a title above the image.
	[folder, basefilename, extension] = fileparts(fullImageFileName);
	extension = lower(extension);
	% Display the title.
	caption = [basefilename, extension];
	title(handles.axesImage, caption, 'Interpreter', 'none', 'FontSize', 14);
	% Get the size of the image.
	[rows, columns, numberOfColorChannels] = size(imageArray);
	% Get the file date.
	fileInfo = dir(fullImageFileName);
	txtInfo = sprintf('%s\n\n%d lines (rows) vertically\n%d columns across\n%d color channels\n', ...
		[basefilename extension], rows, columns, numberOfColorChannels);
	
	% Tell user the type of image it is.
	% Display colorbar only if it's an indexed image, not a gray scale image or a color image.
	isIndexedImage = false;
	if numberOfColorChannels == 3
		% It's a color image.  Don't use a colorbar.
		colorbar 'off';  % get rid of colorbar.
		txtInfo = sprintf('%s\nThis is a true color, RGB image.', txtInfo);
	elseif numberOfColorChannels == 1 && isempty(colorMap)
		% It's a gray scale image.  Don't use a colorbar.
		colorbar 'off';  % get rid of colorbar.
		txtInfo = sprintf('%s\nThis is a gray scale image, with no stored color map.', txtInfo);
	elseif numberOfColorChannels == 1 && ~isempty(colorMap)
		% It's an indexed image.  Use a colorbar.
		[numColors, colorColumns] = size(colorMap);
		txtInfo = sprintf('%s\nThis is an indexed image.  It has one "value" channel with a stored color map that is used to pseudocolor it with %d colors.', txtInfo, numColors);
		colormap(handles.axesImage, colorMap);  % Starting with R2016b (I think), need to add the axes in order to have the color map actually be applied.
		whos colorMap;
		%fprintf('About to apply the colormap...\n');
		% Thanks to Jeff Mather at the Mathworks to helping to get this working for an indexed image.
		colorbar('peer', handles.axesImage);
		%fprintf('Done applying the colormap.\n');
		isIndexedImage = true;
	end
	
	% Show the file time and date.
	txtInfo = sprintf('%s\n\n%s', txtInfo, fileInfo.date);
	set(handles.txtInfo, 'String', txtInfo);
	
	% Plot the histogram if requested.
	plotHistogram = get(handles.chkPlotHistograms, 'Value');
	if plotHistogram
		if isIndexedImage
			% It's an indexed image and the histogram of the indexes don't really mean anything.
			% So convert the image to an RGB image with ind2rgb and use that color image to show histograms.
			rgbImage = uint8(255 * mat2gray(ind2rgb(imageArray, colorMap)));
			fprintf('About to convert the indexed image to RGB Color and plot the histogram...\n');
			PlotImageHistogram(handles, rgbImage);
			fprintf('Done plotting histogram.\n');
			% 		text(.2, .5, 'This is an indexed image so the histogram is not meaningful', 'FontSize', 20);
		else
			% It's a normal gray scale or RGB image.
			fprintf('About to plot histogram...\n');
			PlotImageHistogram(handles, imageArray);
			fprintf('Done plotting histogram.\n');
		end
		axes(handles.axesPlot); % Switch focus back to the main image axes.
	end
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
return; % from DisplayImage


%===================================================================================================================
% Update Analyze button and tooltip string depending on how many files in the listbox were selected.
function UpdateAnalyzeButtonCaption(handles)
Selected = get(handles.lstImageList, 'value');
if length(Selected) > 1
	buttonCaption = sprintf('Step 5:  Go! Analyze %d images', length(Selected));
	set(handles.btnAnalyze, 'string', buttonCaption);
	set(handles.btnAnalyze, 'Tooltipstring', 'Display and analyze the selected image(s)');
elseif length(Selected) == 1
	set(handles.btnAnalyze, 'string', 'Step 5:  Go! Analyze 1 image');
	set(handles.btnAnalyze, 'Tooltipstring', 'Display and analyze the selected image');
else
	set(handles.btnAnalyze, 'string', 'Step 5:  Stop! Analyze no images');
	set(handles.btnAnalyze, 'Tooltipstring', 'Please select image(s) first');
end
return;

%===================================================================================================================
% --- Executes during object creation, after setting all properties.
function lstImageList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstImageList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	set(hObject,'BackgroundColor','white');
end
return


%===================================================================================================================
% --- Executes on clicking btnSelectFolder button.
% Asks user to select a directory and then loads up the listbox (via a call
% to LoadImageList)
function btnSelectFolder_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelectFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%msgbox(handles.imageFolder);
try
	returnValue = uigetdir(handles.imageFolder,'Select folder');
	% returnValue will be 0 (a double) if they click cancel.
	% returnValue will be the path (a string) if they clicked OK.
	if returnValue ~= 0
		% Assign the value if they didn't click cancel.
		handles.imageFolder = returnValue;
		handles = LoadImageList(handles);
		set(handles.txtFolder, 'string' ,handles.imageFolder);
		guidata(hObject, handles);
		% Save the image folder in our ini file.
		SaveUserSettings(handles);
	end
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
return

%===================================================================================================================
% --- Load up the listbox with tif files in folder handles.handles.imageFolder
function handles=LoadImageList(handles)
try
	listOfFileNames = {};
	folder = handles.imageFolder;
	if ~isempty(handles.imageFolder)
		if exist(folder,'dir') == false
			warningMessage = sprintf('Note: the folder used when this program was last run:\n%s\ndoes not exist on this computer.\nPlease run Step 1 to select an image folder.', handles.imageFolder);
			msgboxw(warningMessage);
			return;
		end
	else
		msgboxw('No folder specified as input for function LoadImageList.');
		return;
	end
	% If it gets to here, the folder is good.
	% Make a file pattern for all files regardless of extension.
	% Change pattern if you want something else.  For example if you want only csv files, then change it to '*.csv'.
	filePattern = fullfile(handles.imageFolder, '*.*');
	% Read the folder to get a directory listing of all files in the folder.
	imageFiles = dir(filePattern);
	% Get a cell array for the listbox.
	listOfFileNames = {imageFiles.name}; % A cell array of base file names.
	
	%-------------------------- Option --------------------------------------------------------------
	% If you want to limit the list of files to image files ONLY, then include the next 16 lines or so.
	% If you want to keep ALL file names in the list, comment out or delete the next 16 lines or so.
	% Get a list (cell array) of all the allowable image formats that imread() can read.
	allowableFormats = imformats;  % A structure
	allowableFormats = [allowableFormats.ext]; % Extract the extensions into a cell array.
	
	% Make a list of which filenames are images.  Initialize with a list of "keepers" that is boolean.
	indexesToKeep = false(1, length(listOfFileNames));
	for index = 1:length(imageFiles)
		baseFileName = imageFiles(index).name;
		[folder, name, extension] = fileparts(baseFileName); % extension will have a dot.
		% Remove dot as the first character of the extension to be consistent with how imformats() returns the extentions.
		extension = lower(extension(2:end)); % Should already be lower case, but just make sure.
		itIsAnImage = sum(ismember(extension, allowableFormats)) >= 1;
		if itIsAnImage
			% It's an image, so flag it as a file to keep in our list of files to show in the listbox.
			indexesToKeep(index) = true;
		end
	end
	listOfFileNames = listOfFileNames(indexesToKeep); % Extract and keep only those that are images.  Discard the rest of the filenames.
	%-------------------------- End of Option --------------------------------------------------------------
	
	% Send the list of filenames to the listbox control on the GUI.
	set(handles.lstImageList,'string', listOfFileNames);
	
	% If the current listbox has fewer items in it than the value of the selected item in the last folder,
	% then the selected item will be off the end of the list, like you were looking at image 10 but the new folder has only 2 items in it.
	% In cases like that, the entire listbox will not show up.  So you have to make sure that the selected item is not more than the
	% number of items in the list.  We'll just deselect everything to make sure that doesn't happen.
	% Select none of the items in the listbox.
	set(handles.lstImageList, 'value', []);
	% Change caption to say Select All
	set(handles.btnSelectAllOrNone, 'string', 'Step 2:  Select All');
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
return; % from LoadImageList()


%===================================================================================================================
% --- Executes on clicking btnAnalyze button.
% Goes down through the list, displaying then analyzing each highlighted image file.
% Main processing is done by the function AnalyzeSingleImage()
function btnAnalyze_Callback(hObject, eventdata, handles)
% hObject    handle to btnAnalyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Change mouse pointer (cursor) to an hourglass.
% QUIRK: use 'watch' and you'll actually get an hourglass not a watch.
set(gcf,'Pointer','watch');
drawnow;	% Cursor won't change right away unless you do this.
try
	% Get a list of those indexes that are selected, so we know which images to process.
	Selected = get(handles.lstImageList, 'value');
	numberOfSelectedFiles = length(Selected);
	numberOfFilesAnalyzed = 0;  % Keep track of how many we actually do analyze.  They might skip some so it might be different.
	
	% Then get list of all of the filenames in the list,
	% regardless of whether they are selected or not.
	ListOfImageNames = get(handles.lstImageList, 'string');
	
	% At the beginning of the loop, make the Finish Now checkbox unchecked and visible.
	set(handles.chkFinishNow, 'Visible', 'on');
	set(handles.chkFinishNow, 'Value', 0);
	
	% Make an array for the results.
	% We will send these to Excel if requested.
	%     resultsArray = zeros(numberOfSelectedFiles, 6);
	
	for j = 1 : numberOfSelectedFiles    % Loop though all selected indexes.
		index = Selected(j);    % Get the next selected index.
		% Get the filename for this selected index.
		baseFileName = strcat(cell2mat(ListOfImageNames(index)));
		imageFullFileName = fullfile(handles.imageFolder, baseFileName);
		
		% Display the image.
		imgOriginal = DisplayImage(handles, imageFullFileName);
		% If imgOriginal is empty (couldn't be read), skip to next file.
		if isempty(imgOriginal)
			continue;
		end
		
		% Analyze this image file.
		resultsArray = AnalyzeSingleImage(handles, imageFullFileName);
		numberOfFilesAnalyzed = numberOfFilesAnalyzed + 1;
		
		% See if the user wants to quit early
		chkFinishNow = get(handles.chkFinishNow, 'Value');
		if chkFinishNow
			break;
		end
		
		if get(handles.chkSendToExcel, 'value')
			% Send the results to Excel.  One workbook will be created for each image.
			% Note: You could have one workbook and one worksheet for each image, (just keep the
			% same excelFullFileName but change workSheetName), but Excel 2003 limits you
			% to 32 worksheets or less per workbook, so be aware of that.
			blankString = ' ';  % Need so that both rows of columnNames cell array have the same number of elements (or else you'll get an error).
			columnNames = {baseFileName, blankString, blankString, blankString,...
				blankString, blankString, blankString; ...
				'Blob #', 'Area', 'Mean Intensity', 'Perimeter', ...
				'CentroidX', 'CentroidY', 'ECD'};
			[folder, baseFileNameNoExtension, extension] = fileparts(baseFileName);
			excelBaseFileName = sprintf('Results for %s.xls', baseFileNameNoExtension);
			excelFullFileName = fullfile(handles.imageFolder, excelBaseFileName);
			workSheetName = 'Results';
			% Write the filename into row 1, and the column headings into row 2.
			xlswrite(excelFullFileName, columnNames, workSheetName, 'B1');
			% Write numerical results starting on row 3.
			xlswrite(excelFullFileName, resultsArray, workSheetName, 'B3');
			msgboxw({'Done with analysis.  Results are in Excel file:'; excelFullFileName});
		end
		
		% Prompt to allow user to inspect the image.
		if j < numberOfSelectedFiles && get(handles.chkPauseAfterImage, 'value')
			userPrompt = sprintf('Check out results, then\nclick Continue to process the next image.');
			reply = questdlg(userPrompt, ...
				'Continue?', 'Continue', 'Quit loop', 'Continue');
			% reply = '' for Upper right X, otherwise it's the exact wording.
			if strcmpi(reply, 'Quit loop')
				set(handles.txtInfo, 'string', 'Batch processing terminated.');
				break;
			end
		end
	end % Of loop over all the files selected in the listbox.
	% Update the text on the GUI
	txtInfo = sprintf('Done analyzing %d files.', numberOfFilesAnalyzed);
	set(handles.txtInfo, 'String', txtInfo);
	
	% At the end of the loop, make the Finish Now checkbox unchecked and invisible.
	set(handles.chkFinishNow, 'Visible', 'off');
	set(handles.chkFinishNow, 'Value', 0);
	
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end

set(gcf,'Pointer','arrow');
drawnow;	% Cursor won't change right away unless you do this.

guidata(hObject, handles);
return


%===================================================================================================================
% --- Executes on button press in btnSelectAllOrNone.
function btnSelectAllOrNone_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelectAllOrNone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
	% Find out button caption and take appropriate action.
	ButtonCaption = get(handles.btnSelectAllOrNone, 'string');
	if strcmp(ButtonCaption, 'Step 2:  Select All') == 1
		% Select all items in the listbox.
		% Need to find out how many items are in the listbox (both selected and
		% unselected).  It's quirky and inefficient but it's the only way I
		% know how to do it.
		% First get the whole damn listbox text into a cell array.
		caListboxString = get(handles.lstImageList, 'string');
		NumberOfItems = length(caListboxString);    % Get length of that cell array.
		AllIndices=1:NumberOfItems; % Make a vector of all indices.
		% Select all indices.
		set(handles.lstImageList, 'value', AllIndices);
		% Finally, change caption to say "Select None"
		set(handles.btnSelectAllOrNone, 'string', 'Step 2:  Select None');
		% It scrolls to the bottom of the list.  Use the following line
		% if you want the first item at the top of the list.
		set(handles.lstImageList, 'ListboxTop', 1);
	else
		% Select none of the items in the listbox.
		set(handles.lstImageList, 'value', []);
		% Change caption to say Select All
		set(handles.btnSelectAllOrNone, 'string', 'Step 2:  Select All');
	end
	% Update the number of images in the Analyze button caption.
	UpdateAnalyzeButtonCaption(handles);
	guidata(hObject, handles);
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end


%===================================================================================================================
% --- Executes on button press in chkSendToExcel.
function chkSendToExcel_Callback(hObject, eventdata, handles)
% hObject    handle to chkSendToExcel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of chkSendToExcel
checkboxState = get(hObject,'Value');
message = sprintf('Now the results will be saved to an Excel workbook in folder\n%s', handles.imageFolder);
if checkboxState
	set(handles.txtInfo, 'string', message);
else
	set(handles.txtInfo, 'string', 'Now the results will not be saved to an Excel workbook.');
end


%===================================================================================================================
% --- Executes on button press in chkPauseAfterImage.
function chkPauseAfterImage_Callback(hObject, eventdata, handles)
% hObject    handle to chkPauseAfterImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of chkPauseAfterImage
checkboxState = get(hObject,'Value');
if checkboxState
	set(handles.txtInfo, 'string', 'Now you will be able to inspect the results before it processes the next image.');
else
	set(handles.txtInfo, 'string', 'Now the image(s) will be analyzed without pausing for you will be able to inspect the results in between images.');
end


%===================================================================================================================
% Erases all lines from the image axes.  The current axes should be set first using the axes()
% command before this function is called, as it works from the current axes, gca.
function ClearLinesFromAxes(h)

%fprintf('ClearLinesFromAxes.1\n');
axesHandlesToChildObjects = findobj(h, 'Type', 'line');
%fprintf('ClearLinesFromAxes.2\n');
if ~isempty(axesHandlesToChildObjects)
	delete(axesHandlesToChildObjects);
end
return; % from ClearLinesFromAxes


%===================================================================================================================
% --- Executes during object creation, after setting all properties.
% EVEN THOUGH THIS FUNCTION IS EMPTY, DON'T DELETE IT OR ERRORS WILL OCCUR
function axesPlot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axesPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axesPlot


%===================================================================================================================
% --- Executes during object creation, after setting all properties.
% EVEN THOUGH THIS FUNCTION IS EMPTY, DON'T DELETE IT OR ERRORS WILL OCCUR
function axesImage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axesImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axesImage


%===================================================================================================================
% --- Executes during object creation, after setting all properties.
% EVEN THOUGH THIS FUNCTION IS EMPTY, DON'T DELETE IT OR ERRORS WILL OCCUR
function figMainWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figMainWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


%===================================================================================================================
% --- Executes on button press in btnExit.
function btnExit_Callback(hObject, eventdata, handles)
% hObject    handle to btnExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
	% Print informational message so you can look in the command window and see the order of program flow.
	fprintf(1, 'Just entered btnExit_Callback...\n');
	
	% Save the current settings out to the .mat file.
	SaveUserSettings(handles);
	
	% Cause it to shutdown.
	delete(handles.figMainWindow);
	
	% Print informational message so you can look in the command window and see the order of program flow.
	fprintf(1, 'Now leaving btnExit_Callback.\n');
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end


%===================================================================================================================
% --- Executes on button press in chkAutoAnalyze.
function chkAutoAnalyze_Callback(hObject, eventdata, handles)
% hObject    handle to chkAutoAnalyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of chkAutoAnalyze
checkboxState = get(hObject,'Value');
if checkboxState
	set(handles.txtInfo, 'string', 'Now the image will be analyzed as soon as it is selected.');
else
	set(handles.txtInfo, 'string', 'Now the image(s) will be analyzed only when the Analyze button is clicked.');
end


%===================================================================================================================
% Process file.
% You can replace this contents of this function's "try" block with whatever you want.
% Just delete the whole "try" block, and put your own code in here.  It's as simple as that!
% It would be good to leave the "catch" block though.
function [resultsArray] = AnalyzeSingleImage(handles, fullImageFileName)
try
	resultsArray = zeros(1, 3);	% Initialize to make sure that something will always be returned.
	
	% Put your custom code here...
	% Display the image.
	theImage = DisplayImage(handles, fullImageFileName);
	theMean = mean2(theImage(:));	% Just as an example, get the mean intensity of all the pixels.
	resultsArray = theMean * ones(1, 3);	% Whatever you want to return to the calling routine ...
	% As another example, you can get status (checked or unchecked) of checkboxes, get scroll bar values, get popup menu index, etc.
	% and then use those values to do different things with your code.
	
	% Put some random stuff into the table.
	FillUpTable(handles);
	
	% Get the text in the edit text box.  (We don't do anything with it though - it's just for demo.)
	editTextContents = get(handles.edtEditText, 'String');
	set(handles.txtInfo, 'String', editTextContents);
	
	message = sprintf('Now is when it would be running your custom code\nthat you put inside the AnalyzeSingleImage() function.');
	msgboxh(message);
	
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
return;  % AnalyzeSingleImage


%===================================================================================================================
% Put some random numbers into the table, just to show how it can be done.
function FillUpTable(handles)
try
	% Create sample data and row and column headers.
	columnHeaders = {'n', 'Result #1', 'Result #2'};
	tableData = cell(10, 3);
	for n = 1 : size(tableData, 1)
		rowHeaders{n} = sprintf('Row #%d', n);
		% Make up some data to put into the table control.
		tableData{n,1} = n;
		tableData{n,2} = 10*randi(9, 1,1);
		tableData{n,3} = sprintf('  Value = %.2f %s %.2f', rand(1,1), 177, rand(1));
	end
	
	% Apply the row and column headers.
	set(handles.uitable1, 'RowName', rowHeaders);
	set(handles.uitable1, 'ColumnName', columnHeaders);
	
	% Adjust columns widths.
	set(handles.uitable1, 'ColumnWidth', {30, 60, 180});
	
	% Display the table of values.
	set(handles.uitable1, 'data', tableData);
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
return;  % FillUpTable


%===================================================================================================================
% Takes histogram of 1-D array blobSizeArray, and plots it.
function [blobCounts, areaValues] = PlotHistogram(handles, blobSizeArray)
% Get a histogram of the blobSizeArray and display it in the histogram viewport.
numberOfBins = min([100 length(blobSizeArray)]);
[blobCounts, areaValues] = hist(blobSizeArray, numberOfBins);
% Plot the number of blobs with a certain area versus that area.
axes(handles.axesPlot);
bar(areaValues, blobCounts);
title('Histogram of Blob Sizes');
return;


% --- Executes when selected object is changed in grpRadButtonGroup.
function grpRadButtonGroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in grpRadButtonGroup
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue, 'Tag') % Get Tag of selected object.
	case 'radOption1'
		% Code for when radiobutton1 is selected.
		txtInfo = sprintf('Option 1 is selected and the others are deselected.');
	case 'radOption2'
		% Code for when radiobutton2 is selected.
		txtInfo = sprintf('Option 2 is selected and the others are deselected.');
		% Continue with more cases as necessary.
	otherwise
		% Code for when there is no match.
end
set(handles.txtInfo, 'String', txtInfo);
return; % from grpRadButtonGroup_SelectionChangeFcn


%===================================================================================================================
% --- Executes on slider movement.
function sldHorizontalScrollbar_Callback(hObject, eventdata, handles)
% hObject    handle to sldHorizontalScrollbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Set up the Scrollbar captions.
ScrollBarMoved(handles);


%===================================================================================================================
% --- Executes during object creation, after setting all properties.
function sldHorizontalScrollbar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldHorizontalScrollbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%===================================================================================================================
% --- Executes on slider movement.
function sldVerticalScrollbar_Callback(hObject, eventdata, handles)
% hObject    handle to sldVerticalScrollbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% Set up the Vertical Scrollbar caption.
ScrollBarMoved(handles);


%===================================================================================================================
% --- Executes during object creation, after setting all properties.
function sldVerticalScrollbar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldVerticalScrollbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%===================================================================================================================
function ScrollBarMoved(handles)
try
	% Set up the Vertical Scrollbar caption.
	scrollbarValue = get(handles.sldVerticalScrollbar, 'Value');
	caption = sprintf('V value = %.2f', scrollbarValue);
	set(handles.txtVScrollbar, 'string', caption);
	% Set up the Horizontal Scrollbar caption.
	scrollbarValue = get(handles.sldHorizontalScrollbar,'Value');
	caption = sprintf('H value = %.2f', scrollbarValue);
	set(handles.txtHScrollbar, 'string', caption);
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
return; % from SaveUserSettings()


%===================================================================================================================
% --- Executes on mouse motion over figure - except title and menu.
function figMainWindow_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figMainWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%===================================================================================================================
function edtEditText_Callback(hObject, eventdata, handles)
% hObject    handle to edtEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtEditText as text
%        str2double(get(hObject,'String')) returns contents of edtEditText as a double


%===================================================================================================================
% --- Executes during object creation, after setting all properties.
function edtEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	set(hObject,'BackgroundColor','white');
end


%===================================================================================================================
function mnuToolsSaveScreenshot_Callback(hObject, eventdata, handles)
% hObject    handle to mnuToolsSaveScreenshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% IMPORTANT NOTE: YOU MUST HAVE DOWNLOADED import_fig()
% FROM THE FILE EXCHANGE FOR THIS FUNCTION TO WORK.
try
	% Save the figure
	% Have user browse for a file, from a specified "starting folder."
	% For convenience in browsing, set a starting folder from which to browse.
	startingFolder = 'C:\Program Files\MATLAB';
	if ~exist(startingFolder, 'dir')
		% If that folder doesn't exist, just start in the current folder.
		startingFolder = pwd;
	end
	% Get the name of the color image file that the user wants to save this figure into.
	defaultFileName = fullfile(startingFolder, 'MAGIC_Screenshot.png');
	[baseFileName, folder] = uiputfile(defaultFileName, 'Specify a file for your screenshot');
	if baseFileName == 0
		% User clicked the Cancel button.
		return;
	end
	screenshotFileName = fullfile(folder, baseFileName);
	% Display a message on the UI.
	txtInfo = sprintf('Please wait...\nSaving screenshot as\n%s', screenshotFileName);
	set(handles.txtInfo, 'String', txtInfo);
	% CALL export_fig, WHICH YOU MUST HAVE DOWNLOADED.
	export_fig(screenshotFileName);
	message = sprintf('Screenshot saved as:\n%s', screenshotFileName);
	set(handles.txtInfo, 'String', message);
	msgboxw(message);
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
	WarnUser('Are you sure you downloaded export_fig, and it is on the search path?');
end
return; % from mnuToolsSaveScreenshot_Callback


%===================================================================================================================
function mnuToolsMontage_Callback(hObject, eventdata, handles)
% hObject    handle to mnuToolsMontage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
	% Change mouse pointer (cursor) to an hourglass.
	% QUIRK: use 'watch' and you'll actually get an hourglass not a watch.
	set(gcf,'Pointer','watch');
	% Get a list of all the filenames.
	ListOfImageNames = get(handles.lstImageList, 'string');
	% Get a list of what files they selected.
	selectedItems = get(handles.lstImageList, 'value');
	% If none are selected, use them all.
	numberOfSelectedImages = length(selectedItems);
	if numberOfSelectedImages <= 1
		numberOfSelectedImages = length(ListOfImageNames);
		selectedItems = 1 : numberOfSelectedImages;
	end
	caption = sprintf('Please wait...Constructing montage of %d images...', numberOfSelectedImages);
	title(caption, 'FontSize', 14);
	set(handles.txtInfo, 'string', caption);
	drawnow;	% Cursor won't change right away unless you do this.
	% Get a list of the selected files only.
	% Warning: This will not include folders so we will have to prepend the folder.
	ListOfImageNames = ListOfImageNames(selectedItems);
	for k = 1 : numberOfSelectedImages    % Loop though all selected indexes.
		% Get the filename for this selected index.
		baseImageFileName = cell2mat(ListOfImageNames(k));
		imageFullFileName = fullfile(handles.imageFolder, baseImageFileName);
		ListOfImageNames{k} = imageFullFileName;
	end
	% Figure out how many rows and there should be.
	% There is twice as much space horizontally as vertically so solve the equation 2*rows^2 = numberOfImages.
	rows = ceil(sqrt(numberOfSelectedImages/2));
	columns = 2 * rows;
	axes(handles.axesImage);
	cla(handles.axesImage, 'reset');
	handleToImage = handles.axesImage;
	hMontage = montage(ListOfImageNames, 'size', [rows columns]);
	caption = sprintf('Displaying a montage of %d images.', numberOfSelectedImages);
	title(caption, 'FontSize', 20);
	set(handles.txtInfo, 'string', caption);
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	LoadSplashImage(handles, handles.axesImage);
	WarnUser(errorMessage);
end
% Change mouse pointer (cursor) to an arrow.
set(gcf,'Pointer','arrow');
drawnow;	% Cursor won't change right away unless you do this.

return; % from mnuToolsMontage_Callback


%=====================================================================
% Plots the histogram of grayImage in axes axesImage
% If grayImage is a double, it must be normalized between 0 and 1.
function PlotImageHistogram(handles, imageArray)
try
	numberOfDimensions = ndims(imageArray);
	if numberOfDimensions == 1 || numberOfDimensions == 2
		% Grayscale 2D or 1D image.
		PlotGrayscaleHistogram(handles, imageArray)
	elseif numberOfDimensions == 3
		% True color RGB image.
		PlotRGBHistograms(handles, imageArray);
	else
		warningMessage = sprintf('Histograms are only supported for grayscale (2D) or color (3D) images');
		WarnUser(warningMessage);
	end
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
return; % PlotImageHistogram


%=====================================================================
% Plots the histogram of grayImage in axes axesImage
% If grayImage is a double, it must be normalized between 0 and 1.
function [minGL, maxGL] = PlotGrayscaleHistogram(handles, grayImage)
try
	% Plot the histogram in the histogram viewport.
	axes(handles.axesPlot);  % makes existing axes handles.axesPlot the current axes.
	
	% Get the histogram
	[pixelCounts, grayLevels] = imhist(grayImage);
	
	% Plot it.
	bar(grayLevels, pixelCounts, 'BarWidth', 1);
	title('Histogram of Gray Image', 'FontSize', 12);
	grid on;
	
	% Get the min and max GL for fun.
	minGL = min(grayImage(:));
	maxGL = max(grayImage(:));
	
	% Set up the x axis of the histogram to go from 0 to the max value allowed for this type of integer (uint8 or uint16).
	theClass = class(grayImage);
	% Only set xlim for integers.  For example the demo image blobs.png is logical not integer even though it's grayscale.
	if strfind(theClass, 'int')
		xlim([0 intmax(theClass)]);
	end
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
return; % PlotGrayscaleHistogram


%=====================================================================
% Plots the histogram of imgColorImageArray in axes axesImage
% If imgArray is a double, it must be normalized between 0 and 1.
function [minGL, maxGL, gl1Percentile, gl99Percentile] = PlotRGBHistograms(handles, imgColorImageArray)
try
	% Get a histogram of the entire image.  But imhist only allows 2D images, not color ones.
	% First get individual channels from the original image.
	redBand = imgColorImageArray(:,:,1);
	greenBand = imgColorImageArray(:,:,2);
	blueBand = imgColorImageArray(:,:,3);
	
	% Use 256 bins.
	[redCounts, redGLs] = imhist(redBand, 256);    % make sure you label the axes after imhist because imhist will destroy them.
	[greenCounts, greenGLs] = imhist(greenBand, 256);    % make sure you label the axes after imhist because imhist will destroy them.
	[blueCounts, blueGLs] = imhist(blueBand, 256);    % make sure you label the axes after imhist because imhist will destroy them.
	
	% GLs goes from 0 (at element 1) to 255 (at element 256) but only some
	% these bins have data in them.  The upper ones may be 0.  Find the last
	% non-zero bin so we can plot just up to there to get better horizontal resolution.
	maxBinUsedR = find(redCounts, 1, 'last' );
	maxBinUsedG = find(greenCounts, 1, 'last' );
	maxBinUsedB = find(blueCounts, 1, 'last' );
	% If the entire image is zero, have the max bin be 0.
	if isempty(maxBinUsedR); maxBinUsedR = 1; end;
	if isempty(maxBinUsedG); maxBinUsedG = 1; end;
	if isempty(maxBinUsedB); maxBinUsedB = 1; end;
	% Take the largest one overall for plotting them all.
	maxBinUsed = max([maxBinUsedR maxBinUsedG maxBinUsedB]);
	
	% Get subportion of array that has non-zero data.
	redCounts = redCounts(1:maxBinUsed);
	greenCounts = greenCounts(1:maxBinUsed);
	blueCounts = blueCounts(1:maxBinUsed);
	GLs = redGLs(1:maxBinUsed);
	
	% Assign the max and min for the 3 color bands.
	minGL(1) = GLs(maxBinUsedR);
	maxGL(2) = GLs(maxBinUsedG);
	maxGL(3) = GLs(maxBinUsedB);
	
	% Calculate the 1% and 99% value of the CDF for the 3 color bands.
	gl1Percentile = ones(3, 1);	    % Preallocate one element for each color.
	gl99Percentile = ones(3, 1);		% Preallocate one element for each color.
	for color = 1:3
		switch color
			case 1
				counts = redCounts;
			case 2
				counts = greenCounts;
			case 3
				counts = blueCounts;
		end
		summed = sum(counts);
		cdf = 0;
		for bin = 1 : maxBinUsed
			cdf = cdf + counts(bin);
			if cdf < 0.01 * summed
				gl1Percentile(color) = GLs(bin);
			end
			if cdf > 0.99 * summed
				break;
			end
		end
		gl99Percentile(color) = GLs(bin);
	end
	
	% Plot the histogram in the histogram viewport.
	axes(handles.axesPlot);  % makes existing axes handles.axesPlot the current axes.
	% Plot the histogram as a line curve.
	plot(GLs, blueCounts, 'b', 'LineWidth', 3);
	hold on;
	plot(GLs, greenCounts, 'g', 'LineWidth', 3);
	plot(GLs, redCounts, 'r', 'LineWidth', 3);
	grid on;
	title('Red, Green, and Blue Histograms');
	maxCountInHistogram = max([redCounts(:); greenCounts(:); blueCounts(:)]);
	set(handles.axesPlot,'YLim',[0 maxCountInHistogram]);
	
	% Plot the sum of all of them
	% 		sumCounts = redCounts + greenCounts + blueCounts;
	% 		plot(GLs, sumCounts, 'k', 'LineWidth', 1);  % Plot sum in black color.
	% 		set(handles.axesPlot,'YLim',[0 max(sumCounts)]);
	
	% Set up custom tickmarks.
	set(handles.axesPlot,'XTick',      [0 20 40 60 80 100 120 140 160 180 200 220 240 255]);
	set(handles.axesPlot,'XTickLabel', {0 20 40 60 80 100 120 140 160 180 200 220 240 255});
	set(get(handles.axesPlot,'XLabel'),'string','Gray Level');
	ylabel('# of Pixels');
	xlabel('Gray Level');
	xlim([0 255]);
	hold off;
	
	axes(handles.axesImage);	% Switch current figure back to image box.
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
return; % PlotRGBHistograms


%===================================================================================================================
function mnuTools_Callback(hObject, eventdata, handles)
% hObject    handle to mnuTools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%===================================================================================================================
% Pops up a message box and waits for the user to click OK.
function msgboxw(in_strMessage)
uiwait(msgbox(in_strMessage));
return;


%===================================================================================================================
% Pops up a help/information box and waits for the user to click OK.
function msgboxh(in_strMessage)
uiwait(helpdlg(in_strMessage));
return;


%==========================================================================================================================
% Warn user via the command window and a popup message.
function WarnUser(warningMessage)
fprintf(1, '%s\n', warningMessage);
uiwait(warndlg(warningMessage));
return; % from WarnUser()


% --- Executes on button press in chkPlotHistograms.
function chkPlotHistograms_Callback(hObject, eventdata, handles)
% hObject    handle to chkPlotHistograms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of chkPlotHistograms
try
	showHistogram = get(handles.chkPlotHistograms, 'Value');
	% Hide the histogram since there are no counts yet, and we want to hide any old histograms that are showing.
	SetAxesVisibility(handles, handles.axesPlot, showHistogram);
	if showHistogram
		% If showing, turn the axes on since SetAxesVisibility() does everything except the axes.
		axis(handles.axesPlot, 'on');
	end
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
return; % from chkPlotHistograms_Callback()


% --- Executes on button press in radOption2.
function radOption2_Callback(hObject, eventdata, handles)
% hObject    handle to radOption2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radOption2


% --- Executes on button press in radOption1.
function radOption1_Callback(hObject, eventdata, handles)
% hObject    handle to radOption1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radOption1


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
try
	% Get the index (a number) and the item (the string in the drop down list) for the item they chose.
	contents = cellstr(get(handles.popupmenu1,'String')); % Returns popupmenu1 contents as cell array
	selectedIndex = get(handles.popupmenu1,'Value');	% Get the index of the item they selected: 1, 2, or 3.
	selectedItem = contents{selectedIndex};		% Returns selected item from popupmenu1
	% You can use the above code in any other callback to determine what item was selected.
	
	% Tell the user what they picked.
	message = sprintf('You selected item #%d from the popupmenu.\nThe string for that index number is : %s', selectedIndex, selectedItem);
	msgboxh(message);
	% Now you can add other code, if you want, to do other operations.
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
return; % from popupmenu1_Callback()


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
	set(hObject,'BackgroundColor','white');
end


%==================================================================================
% Save variables and GUI control settings so they can be recalled between sessions.
% I'm only saving the image folder and some of the settings here, but you could
% save all the settings of all the checkboxes, scrollbars, etc. on the GUI, if you want.
function SaveUserSettings(handles)
try
	matFullFileName = fullfile(handles.programFolder, [mfilename, '.mat']);
	% Save the current folder they're looking at.
	lastUsedImageFolder = handles.imageFolder;
	% Get current value of GUI controls, like checkboxes, etc.
	guiSettings.chkSendToExcel = get(handles.chkSendToExcel, 'Value');
	guiSettings.chkPauseAfterImage = get(handles.chkPauseAfterImage, 'Value');
	guiSettings.chkAutoAnalyze = get(handles.chkAutoAnalyze, 'Value');
	guiSettings.chkPlotHistograms = get(handles.chkPlotHistograms, 'Value');
	guiSettings.sldVerticalScrollbar = get(handles.sldVerticalScrollbar, 'Value');
	guiSettings.sldHorizontalScrollbar = get(handles.sldHorizontalScrollbar, 'Value');
	guiSettings.radOption1 = get(handles.radOption1, 'Value');
	guiSettings.radOption2 = get(handles.radOption2, 'Value');
	
	% Save all the settings to a .mat file.
	save(matFullFileName, 'lastUsedImageFolder', 'guiSettings');
	
	message = sprintf('Saved the current GUI settings to\n%s', matFullFileName);
	msgboxh(message);
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
return; % from SaveUserSettings()


%=========================================================================================
% Recall variables from the last session, including the image folder and the GUI settings.
function handles = LoadUserSettings(handles)
try
	% Load up the initial values from the mat file.
	matFullFileName = fullfile(handles.programFolder, [mfilename, '.mat']);
	if exist(matFullFileName, 'file')
		% Pull out values and stuff them in structure initialValues.
		initialValues = load(matFullFileName);
		% Assign the image folder from the lastUsedImageFolder field of the structure.
		handles.imageFolder = initialValues.lastUsedImageFolder;
		
		% Get the last state of the controls.
		chkSendToExcel = initialValues.guiSettings.chkSendToExcel;
		chkPauseAfterImage = initialValues.guiSettings.chkPauseAfterImage;
		chkAutoAnalyze = initialValues.guiSettings.chkAutoAnalyze;
		chkPlotHistograms = initialValues.guiSettings.chkPlotHistograms;
		sldVerticalScrollbar = initialValues.guiSettings.sldVerticalScrollbar;
		sldHorizontalScrollbar = initialValues.guiSettings.sldHorizontalScrollbar;
		radOption1 = initialValues.guiSettings.radOption1;
		radOption2 = initialValues.guiSettings.radOption2;
		
		% Send those recalled values to their respective controls on the GUI.
		set(handles.chkSendToExcel, 'Value', chkSendToExcel);
		set(handles.chkPauseAfterImage, 'Value', chkPauseAfterImage);
		set(handles.chkAutoAnalyze, 'Value', chkAutoAnalyze);
		set(handles.chkPlotHistograms, 'Value', chkPlotHistograms);
		set(handles.sldVerticalScrollbar, 'Value', sldVerticalScrollbar);
		set(handles.sldHorizontalScrollbar, 'Value', sldHorizontalScrollbar);
		set(handles.radOption1, 'Value', radOption1);
		set(handles.radOption2, 'Value', radOption2);
	else
		% If the mat file file does not exist yet, save the settings out to a new settings .mat file.
		SaveUserSettings(handles);
	end
catch ME
	% Some error happened if you get here.
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
return; % from LoadUserSettings()


% --- Executes on button press in chkFinishNow.
function chkFinishNow_Callback(hObject, eventdata, handles)
% hObject    handle to chkFinishNow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkFinishNow

% Sets visibility of an image that is displayed in an axes.
% Let's say you've used imshow() to display an image in an axes.
% Now, let's say you want to hide that image.
% For some reason, when you set the visibility of the axes (which is a
% containter for the image) to 'off', the image does not disappear.  All
% this does is to make the lines, tick marks, and labels for the graph in
% the axes (which actually don't even appear when you're showing an image)
% disappear, but it leaves the image still visible.  The "reason" for this
% is that the image is a child of the axes and when you set visibility of
% the parent container to be false, it does not set the visibility of all
% the things it contains to also be false.  You have to do that manually,
% which is what this function does.
% MATLAB proves itself, once again, to be very quirky.
% visibility argument = 1 or 0 for visible or invisible.
function allHandles = SetAxesVisibility(handles, axesHandle, visibility)
% Get the handles of all the things in the axes, including the axes itself.
allHandles = findobj(axesHandle);
% Loop through all objects, setting their visibility to the specified value.
for k = 1 : size(allHandles)
	hChild = allHandles(k);
	objectType = get(hChild,'type');
	if visibility == 1 && (strcmpi(objectType, 'axes') <= 0)
		% Set visible unless it's the axes themselves.
		% Keep the axes themselves always turned off, just set visible
		% the things inside of the axes container.
		set(hChild, 'visible', 'on');
	else
		set(hChild, 'visible', 'off');
	end
end

return;
