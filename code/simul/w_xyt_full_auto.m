clear all;
close all;
clc;

if isoctave()
	pkg load communications;
	pkg load statistics;
end %if

S_GIF = true;
range_step = 5; % degrees

% w_xyt(NOISE, ATT, CHG_PHI, CHG_R, CHG_THETA, S_GIF, S_DAT, SNR, range_step, N_antenas);

for N_antenas = [3 5 7]
	for NOISE = [false true]
		for ATT = [false true]
			for S_DAT = [true false]
				if S_DAT
					CHG_PHI = false;
					CHG_R = false;
					CHG_THETA = true;
					if NOISE
						for SNR = [1/1 5/1 25/1 50/1 100/1]
							w_xyt(NOISE, ATT, CHG_PHI, CHG_R, CHG_THETA, S_GIF, S_DAT, SNR, range_step, N_antenas);
							% printf("w_xyt(%d, %d, %d, %d, %d, %d, %d, %d, %d, %d);\n", NOISE, ATT, CHG_PHI, CHG_R, CHG_THETA, S_GIF, S_DAT, SNR, range_step, N_antenas)
						end % for
					else
						SNR = 0;
						w_xyt(NOISE, ATT, CHG_PHI, CHG_R, CHG_THETA, S_GIF, S_DAT, SNR, range_step, N_antenas);
						% printf("w_xyt(%d, %d, %d, %d, %d, %d, %d, %d, %d, %d);\n", NOISE, ATT, CHG_PHI, CHG_R, CHG_THETA, S_GIF, S_DAT, SNR, range_step, N_antenas)
					end %if
				else
					for CHG = [false true]
						CHG_PHI = not(CHG);
						CHG_R = CHG;
						CHG_THETA = CHG;
						if NOISE
							for SNR = [1/1 5/1 25/1 50/1 100/1]
								w_xyt(NOISE, ATT, CHG_PHI, CHG_R, CHG_THETA, S_GIF, S_DAT, SNR, range_step, N_antenas);
								% printf("w_xyt(%d, %d, %d, %d, %d, %d, %d, %d, %d, %d);\n", NOISE, ATT, CHG_PHI, CHG_R, CHG_THETA, S_GIF, S_DAT, SNR, range_step, N_antenas)
							end % for
						else
							SNR = 0;
							w_xyt(NOISE, ATT, CHG_PHI, CHG_R, CHG_THETA, S_GIF, S_DAT, SNR, range_step, N_antenas);
							% printf("w_xyt(%d, %d, %d, %d, %d, %d, %d, %d, %d, %d);\n", NOISE, ATT, CHG_PHI, CHG_R, CHG_THETA, S_GIF, S_DAT, SNR, range_step, N_antenas)
						end %if
					end % for
				end %if
			end % for
		end % for
	end % for
	printf("\n\n");
end % for

