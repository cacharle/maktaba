with Ada.Sequential_IO;


package Artwork_DB is

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

	type T_Songs is array(1..100) of String(1..256);

	type T_Artwork(category: T_Category := CATEGORY_OTHER) is
	record
		title:		String(1..256);
		support:	T_Support;
		rating:		T_Rating;

		case category is
			when CATEGORY_FILM =>
				director:	String(1..256);
				is_vf:		Boolean;
			when CATEGORY_GAME =>
				console:	T_Console;
				finished:	Boolean;
			when CATEGORY_ALBUM =>
				artist:		String(1..256);
				songs:		T_Songs;
			when others => null;
		end case;
	end record;

	package P_Artwork_Sequential is new Ada.Sequential_IO(T_Artwork);
	use     P_Artwork_Sequential;

	procedure Get(artwork: out T_Artwork);
	procedure Save(artwork: T_Artwork);
	procedure Modify(artwork: T_Artwork);
	procedure Delete(artwork: T_Artwork);
	procedure Display;

private

	procedure Open_Artwork_File(category: T_Category;
							    file: out P_Artwork_Sequential.File_Type;
								mode: File_Mode := In_File);

	filename_film:  constant String := "./data/film.db";
	filename_game:  constant String := "./data/game.db";
	filename_album: constant String := "./data/album.db";
	filename_other: constant String := "./data/other.db";

end Artwork_DB;
