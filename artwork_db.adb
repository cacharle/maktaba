with Artwork_DB;
use  Artwork_DB;

with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Characters.Handling;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Characters.Handling;

with Ada.Sequential_IO;

package body Artwork_DB is

	package P_Artwork_File is new Ada.Sequential_IO(T_Artwork);
	use     P_Artwork_File;

	procedure Get(artwork: out T_Artwork) is
		category:		T_Category;
		title:			String(1..256);
		support:		T_Support;
		rating:			T_Rating;
		director:		String(1..256);
		is_vf:			Boolean;
		console:		T_Console;
		finished:		Boolean;
		artist:			String(1..256);
		songs:			T_Songs;
		choice_input:	Integer;
		choice_yes_no:	String(1..256);
	begin
		Put_Line("Creation of new record");

		Put("Title: ");
		Get(title);
		Skip_Line;
		New_Line;

		Put_Line("Support: [1] cd");
		Put_Line("         [2] dvd");
		Put_Line("         [3] blueray");
		Put_Line("         [4] vhs");
		Put_Line("         [5] hddvd");
		Get(choice_input);
		case choice_input is
			when 1 => support := SUPPORT_CD;
			when 2 => support := SUPPORT_DVD;
			when 3 => support := SUPPORT_BLUERAY;
			when 4 => support := SUPPORT_VHS;
			when 5 => support := SUPPORT_HDDVD;
			when others => Put_Line("Not a valid choice");
		end case;

		Put("Rating (1|2|3): ");
		Get(rating);
		Skip_Line;
		New_Line;

		Put_Line("Category: [1] film");
		Put_Line("          [2] game");
		Put_Line("          [3] album");
		Put_Line("          [4] other");
		Get(choice_input);
		case choice_input is
			when 1 => category := CATEGORY_FILM;
			when 2 => category := CATEGORY_GAME;
			when 3 => category := CATEGORY_ALBUM;
			when 4 => category := CATEGORY_OTHER;
			when others => Put_Line("Not a valid choice");
		end case;

		case category is
			when CATEGORY_FILM =>
				Put("Director: ");
				Get(director);
				Skip_Line;
				New_Line;

				Put("Is it in vf? [Y/n]: ");
				Get(choice_yes_no);
				Skip_Line;
				New_Line;

				choice_yes_no := to_lower(choice_yes_no);
				if choice_yes_no'length /= 1 or
				   (choice_yes_no(1) /= 'Y' and choice_yes_no(1) /= 'n') then
					Put_Line("Bad Input");
				else
					is_vf := choice_yes_no(1) = 'Y';
				end if;

			when CATEGORY_GAME =>
				Put_Line("Console: [1] nes");
				Put_Line("         [2] ps1");
				Put_Line("         [3] pc");
				Put_Line("         [4] nintendo64");
				Get(choice_input);
				case choice_input is
					when 1 => console := CONSOLE_NES;
					when 2 => console := CONSOLE_PS1;
					when 3 => console := CONSOLE_PC;
					when 4 => console := CONSOLE_NINTENDO64;
					when others => Put_Line("Not a valid choice");
				end case;

			when CATEGORY_ALBUM =>
				null;
			when others => null;
		end case;

		case category is
			when CATEGORY_FILM  => artwork := (CATEGORY_FILM, title, support, rating,
											   director, is_vf);
			when CATEGORY_GAME  => artwork := (CATEGORY_GAME, title, support, rating,
												console, finished);
			when CATEGORY_ALBUM => artwork := (CATEGORY_ALBUM, title, support, rating,
											   artist, songs);
			when CATEGORY_OTHER => artwork := (CATEGORY_OTHER, title, support, rating);
		end case;
	end Get;

	procedure Save(artwork: T_Artwork) is
		file:			P_Artwork_File.File_Type;
	begin
		Create(file, In_File, dirname_data & filename_film);
		Write(file, artwork);
		Close(file);
	end Save;

	procedure Modify(artwork: T_Artwork) is
	begin
		null;
	end Modify;

	procedure Delete(artwork: T_Artwork) is
	begin
		null;
	end Delete;

	procedure Display is
		file:			P_Artwork_File.File_Type;
		tmp_artwork:	T_Artwork;
	begin
		Create(file, Out_File, dirname_data & filename_film);

		while not End_Of_File(file) loop
			Read(file, tmp_artwork);
			put(tmp_artwork.title);
		end loop;

		Close(file);
	end Display;

end Artwork_DB;
