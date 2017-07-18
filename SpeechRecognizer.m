function varargout = SpeechRecognizer(varargin)
% SPEECHRECOGNIZER MATLAB code for SpeechRecognizer.fig
%      SPEECHRECOGNIZER, by itself, creates a new SPEECHRECOGNIZER or raises the existing
%      singleton*.
%
%      H = SPEECHRECOGNIZER returns the handle to a new SPEECHRECOGNIZER or the handle to
%      the existing singleton*.
%
%      SPEECHRECOGNIZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPEECHRECOGNIZER.M with the given input arguments.
%
%      SPEECHRECOGNIZER('Property','Value',...) creates a new SPEECHRECOGNIZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SpeechRecognizer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SpeechRecognizer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SpeechRecognizer

% Last Modified by GUIDE v2.5 03-Jul-2017 13:21:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SpeechRecognizer_OpeningFcn, ...
                   'gui_OutputFcn',  @SpeechRecognizer_OutputFcn, ...
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


% --- Executes just before SpeechRecognizer is made visible.
function SpeechRecognizer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SpeechRecognizer (see VARARGIN)
% Choose default command line output for SpeechRecognizer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SpeechRecognizer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SpeechRecognizer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in click.
function click_Callback(hObject, eventdata, handles)
% hObject    handle to click (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Initialization
clear ; close all; clc



tts('Speak Now');




input_layer_size  = 32;  
num_labels = 8;         



% Load Training Data


load('mmatlab.mat'); % training data stored in arrays X, y

m = size(x, 1);
n = size(x,2);
D = [x y];
P = randperm(m);
X = D(P(1),:);
for c=2:m
    X=[X;[D(P(c),:)]];
end

Z=X(101:m,1:n);
Y=X(101:m,n+1);

V = X(1:100,1:n);
H = X(1:100,n+1);

%% ================ Part 3: Predict for One-Vs-All ================

%save('trained_theta.mat','all_theta');

load('trained_theta.mat');
all_theta=all_theta;

%pred = predictOneVsAll(all_theta, Z);
%fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == Y)) * 100);

%load('matlabxy.mat');
pred = predictOneVsAll(all_theta, V);
%fprintf('\nValidation Accuracy: %f\n', mean(double(pred == H)) * 100);
acc=num2str(mean(double(pred == H)) * 100);

axes(handles.axes1);
plot([1:100]);
set(handles.accuracy,'string',acc);
guidata(hObject,handles);


function accuracy_Callback(hObject, eventdata, handles)
% hObject    handle to accuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of accuracy as text
%        str2double(get(hObject,'String')) returns contents of accuracy as a double


% --- Executes during object creation, after setting all properties.
function accuracy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to accuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
