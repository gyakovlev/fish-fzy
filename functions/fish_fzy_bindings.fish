function fish_fzy_bindings --description "Configures fish-fzy bindings"
	status is-interactive; or return
	function fish_user_key_bindings
		bind \cr 'fzy_select_history (commandline -b)'
  		bind \cf 'fzy_select_directory'
	end
end
