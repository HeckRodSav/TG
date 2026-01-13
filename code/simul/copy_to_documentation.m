function copy_to_documentation(...
	N_antenas, ...
	file_adress ...
)

	folder = '';
	folder = [folder 'POLY_' num2str(N_antenas)];
	doc_foldername = fullfile('..', '..', 'documentation');

	[ ...
		origin_foldername, ...
		name, ...
	] = file_adress{:};


	destination_foldername = fullfile(doc_foldername, 'pictures', folder);
	if not(isfolder(destination_foldername))
		mkdir(foldername);
	end %if

	sorigin_gif_filename = fullfile(origin_foldername, [name '.gif']);
	destination_gif_filename = fullfile(destination_foldername, [name '.gif']);
	copyfile(sorigin_gif_filename, destination_gif_filename, 'f');


	destination_foldername = fullfile(doc_foldername, 'data', folder);
	if not(isfolder(destination_foldername))
		mkdir(foldername);
	end %if

	sorigin_dat_filename = fullfile(origin_foldername, [name '.dat']);
	destination_dat_filename = fullfile(destination_foldername, [name '.dat']);
	copyfile(sorigin_dat_filename, destination_dat_filename, 'f');

	sorigin_dat_r2_filename = fullfile(origin_foldername, [name '.r2.dat']);
	destination_dat_r2_filename = fullfile(destination_foldername, [name '.r2.dat']);
	copyfile(sorigin_dat_r2_filename, destination_dat_r2_filename, 'f');

end % function