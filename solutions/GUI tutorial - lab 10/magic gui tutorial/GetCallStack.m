%=====================================================================
% Gets a string describing the call stack where each line is the filename, function name, and line number in that file.
function callStackString = GetCallStack(errorObject)
try
	theStack = errorObject.stack;
	callStackString = '';
	for k = 1 : length(theStack)-3
		[folder, baseFileName, ext] = fileparts(theStack(k).file);
		baseFileName = sprintf('%s%s', baseFileName, ext);
		callStackString = sprintf('%s in file %s, in the function %s, at line %d\n', callStackString, baseFileName, theStack(k).name, theStack(k).line);
	end
catch ME
	callStackString = GetCallStack(ME);
	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
		mfilename, callStackString, ME.message);
	WarnUser(errorMessage);
end
return; % from callStackString

%==========================================================================================================================
% Warn user via the command window and a popup message.
function WarnUser(warningMessage)
fprintf(1, '%s\n', warningMessage);
uiwait(warndlg(warningMessage));
return; % from WarnUser()
