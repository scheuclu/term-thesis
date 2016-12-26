set command="cd %~dp0; run_tests;"
matlab -nodesktop -nosplash -nodisplay -minimize -wait -logfile output_tests.log -r %command%
type output_tests.log
set content=
for /f "delims=" %%i in (ExitCode.txt) do set content=%content% %%i

exit %content%