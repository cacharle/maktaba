package Artwork is
	type T_Category is (
		CATEGORY_FILM,
		CATEGORY_GAME,
		CATEGORY_ALBUM,
		CATEGORY_OTHER
	);

	type T_Support is (
		SUPPORT_CD,
		SUPPORT_DVD,
		SUPPORT_BLUERAY,
		SUPPORT_VHS,
		SUPPORT_HDDVD
	);

	subtype T_Rating is Integer range 1..3;

	type T_Console is (
		CONSOLE_NES,
		CONSOLE_PS1,
		CONSOLE_PC,
		CONSOLE_NINTENDO64
	);

	-- need Integer range <>
	type T_Songs is array(0..99) of String(0..255);

	type T_Artwork(category: T_Category := CATEGORY_OTHER) is
	record
		title:	String(0..255);
		tech:	T_Support;
		rating:	T_Rating;

		case category is
			when CATEGORY_FILM =>
				director:	String(0..255);
				has_vf:		Boolean;
			when CATEGORY_GAME =>
				console:	T_Console;
				finished:	Boolean;
			when CATEGORY_ALBUM =>
				artist:		String(0..255);
				songs:		T_Songs;
			when others => null;
		end case;
	end record;

end Artwork;
