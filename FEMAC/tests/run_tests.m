% MATLAB runs the test
cd ..
try
	prepare;
  femac('./examples/core/beam3D_hex8/beam_3D_hex8.dat');
  femac('./examples/core/beam3D_tet4/beam_3D_tet4.dat');
  femac('./examples/core/patch_test/patch_test.dat');
  femac('./examples/core/ustripe_tri3/ustripe_tri3.dat');

  femac('./examples/feti/beam_chaco_2x1_feti2_nocoarse/beam_chaco_2x1_feti2_nocoarse.dat');
  femac('./examples/feti/quad_4ele_chaco_2x2_feti2_nocoarse/quad_4ele_chaco_2x2_feti2_nocoarse.dat');
  femac('./examples/feti/rect_chaco_feti2_nocoarse/rect_chaco_feti2_nocoarse.dat');
  femac('./examples/feti/manual_partitioner/manual_partitioner.dat');
  femac('./examples/feti/ustripe_chaco_fetis_coarsegeneo/ustripe_chaco_fetis_coarsegeneo.dat');

  exit_code = 0;
catch
	exit_code = 1;
end

% check the result
%if result.Passed ~= 0 && result.Failed == 0 && result.Incomplete == 0
%    exit_code = 0;
%end

% write the ExitCode
cd tests
fid = fopen('ExitCode.txt','w');
fprintf(fid,'%d',exit_code);
fclose(fid);

% Ensure that we ALWAYS call exit that is always a success so that CI doesn't stop
exit

