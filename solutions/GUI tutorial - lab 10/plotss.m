function varargout = plotss(varargin)
% PLOTSS MATLAB code for plotss.fig
%      PLOTSS, by itself, creates a new PLOTSS or raises the existing
%      singleton*.
%
%      H = PLOTSS returns the handle to a new PLOTSS or the handle to
%      the existing singleton*.
%
%      PLOTSS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTSS.M with the given input arguments.
%
%      PLOTSS('Property','Value',...) creates a new PLOTSS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotss_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotss_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotss

% Last Modified by GUIDE v2.5 22-Nov-2018 13:22:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotss_OpeningFcn, ...
                   'gui_OutputFcn',  @plotss_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before plotss is made visible.
function plotss_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotss (see VARARGIN)

% Choose default command line output for plotss
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotss wait for user response (see UIRESUME)
% uiwait(handles.figure1);
handles.peaks = peaks(35);
handles.membrane = membrane;
handles.sphere = sphere;
[x,y] = meshgrid(-8:.5:8);
r = sqrt(x.^2+y.^2) + eps;
sinc = sin(r)./r;
handles.sincc = sinc;
handles.curr = handles.peaks;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = plotss_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in surf.
function surf_Callback(hObject, eventdata, handles)
% hObject    handle to surf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
surf(handles.axis,handles.curr);
contour(handles.axes2,handles.curr)

% --- Executes on button press in contour.
function contour_Callback(hObject, eventdata, handles)
% hObject    handle to contour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contour(handles.axis,handles.curr)


% --- Executes on button press in mesh.
function mesh_Callback(hObject, eventdata, handles)
% hObject    handle to mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mesh(handles.axis,handles.curr)

% --- Executes on selection change in popmenu.
function popmenu_Callback(hObject, eventdata, handles)
% hObject    handle to popmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popmenu
a = get(hObject,'Value');
if a == 1
    handles.curr = handles.peaks;
elseif a == 2
    handles.curr = handles.membrane;
elseif a == 3
    handles.curr = handles.sincc;
elseif a == 4
    handles.curr = handles.sphere;
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on surf and none of its controls.
function surf_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to surf (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
