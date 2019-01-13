function varargout = lab2(varargin)
% LAB2 MATLAB code for lab2.fig
%      LAB2, by itself, creates a new LAB2 or raises the existing
%      singleton*.
%
%      H = LAB2 returns the handle to a new LAB2 or the handle to
%      the existing singleton*.
%
%      LAB2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LAB2.M with the given input arguments.
%
%      LAB2('Property','Value',...) creates a new LAB2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lab2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lab2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lab2

% Last Modified by GUIDE v2.5 21-Nov-2018 10:13:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lab2_OpeningFcn, ...
                   'gui_OutputFcn',  @lab2_OutputFcn, ...
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


% --- Executes just before lab2 is made visible.
function lab2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lab2 (see VARARGIN)

% Choose default command line output for lab2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lab2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
handles.peakk = peaks(35);
handles.membr = membrane;
[x,y] = meshgrid(-8:.5:8);
r = sqrt(x.^2+y.^2) + eps;
sinc = sin(r)./r;
handles.sincc = sinc;
handles.curr = handles.peakk;
guidata(hObject,handles);


% --- Outputs from this function are returned to the command line.
function varargout = lab2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in sur.
function sur_Callback(hObject, eventdata, handles)
% hObject    handle to sur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
surf(handles.axes1,handles.curr)

% --- Executes on button press in mesh.
function mesh_Callback(hObject, eventdata, handles)
% hObject    handle to mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mesh(handles.axes1,handles.curr)

% --- Executes on button press in con.
function con_Callback(hObject, eventdata, handles)
% hObject    handle to con (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contour(handles.axes1,handles.curr)

% --- Executes on selection change in pop.
function pop_Callback(hObject, eventdata, handles)
% hObject    handle to pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop
str = get(hObject,'Value');
if str == 1
    handles.curr = handles.peakk;
elseif str == 2
    handles.curr = handles.membr;
elseif str == 3
    handles.curr = handles.sincc;
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
