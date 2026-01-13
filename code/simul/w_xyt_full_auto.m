clear all;
close all;
clc;

if isoctave()
	pkg load communications;
	pkg load statistics;
end %if

S_GIF = true;
range_step = 5; % degrees
N_antenas_LIST = [3 5 7];

COPY_FILES = true;

% w_xyt(NOISE, ATT, CHG_PHI, CHG_R, CHG_THETA, S_GIF, S_DAT, SNR, range_step, N_antenas);

for S_DAT = [true false]
	for N_antenas = N_antenas_LIST
		if S_DAT
			CHG_LIST = [true];
		else
			CHG_LIST = [false true];
		end
		for NOISE = [false true]
			if NOISE
				SNR_LIST = [1/1 5/1 25/1 50/1 100/1];
			else
				SNR_LIST = [0];
			end %if
			for ATT = [false true]
				for CHG = CHG_LIST
					CHG_PHI = not(CHG);
					CHG_R = xor(CHG, S_DAT);
					CHG_THETA = CHG;
					for SNR = SNR_LIST
						file_adress = w_xyt(NOISE, ATT, CHG_PHI, CHG_R, CHG_THETA, S_GIF, S_DAT, SNR, range_step, N_antenas);
						% fprintf('w_xyt(%d, %d, %d, %d, %d, %d, %d, %d, %d, %d);\n', NOISE, ATT, CHG_PHI, CHG_R, CHG_THETA, S_GIF, S_DAT, SNR, range_step, N_antenas)
						if (S_DAT && COPY_FILES)
							copy_to_documentation(N_antenas, file_adress);
						end %if
					end % for
				end % for
			end % for
		end % for
	end % for
	fprintf('\n%s\n', repelem('|',70));
	fprintf('%s\n', strftime('%Y-%m-%d %H:%M:%S', localtime(time())))
end % for
