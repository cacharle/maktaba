with Artwork_DB;
use  Artwork_DB;

with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Characters.Handling, Ada.Strings.Fixed;
use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Characters.Handling, Ada.Strings.Fixed;


package body Artwork_DB is

	procedure Get(artwork: out T_Artwork) is
		last:			Natural;
		category:		T_Category;
		title:			String(1..256) := (others => Character'Val(0));
		support:		T_Support;
		rating:			T_Rating;
		director:		String(1..256) := (others => Character'Val(0));
		is_vf:			Boolean;
		console:		T_Console;
		finished:		Boolean;
		artist:			String(1..256) := (others => Character'Val(0));
		songs:			T_Songs := (others => (others => Character'Val(0)));
		song_str:		String(1..256);
		choice_input:	Integer;
	begin
		Put_Line("Creation of new record");

		Put("Title: ");
		Get_Line(title, last);

		Put_Line("- [1] cd");
		Put_Line("- [2] dvd");
		Put_Line("- [3] blueray");
		Put_Line("- [4] vhs");
		Put_Line("- [5] hddvd");
		Put("Support: ");
		Get(choice_input);
		Skip_Line;
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

		Put_Line("- [1] film");
		Put_Line("- [2] game");
		Put_Line("- [3] album");
		Put_Line("- [4] other");
		Put("Category: ");
		Get(choice_input);
		Skip_Line;
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
				Get_Line(director, last);
				New_Line;

				Get_Yes_No("Is it in vf?", is_vf);
				artwork := (CATEGORY_FILM, title, support, rating, director, is_vf);

			when CATEGORY_GAME =>
				Put_Line("- [1] nes");
				Put_Line("- [2] ps1");
				Put_Line("- [3] pc");
				Put_Line("- [4] nintendo64");
				Put("Console: ");
				Get(choice_input);
				case choice_input is
					when 1 => console := CONSOLE_NES;
					when 2 => console := CONSOLE_PS1;
					when 3 => console := CONSOLE_PC;
					when 4 => console := CONSOLE_NINTENDO64;
					when others => Put_Line("Not a valid choice");
				end case;
				Get_Yes_No("Have you finished this game?", finished);
				artwork := (CATEGORY_GAME, title, support, rating, console, finished);

			when CATEGORY_ALBUM =>
				Put("Artist: ");
				Get_Line(artist, last);
				New_Line;
				Put_Line("Enter Songs (enter empty line to finish)");
				for i in songs'Range loop
					Put(">song> ");
					Get_Line(song_str, last);
					exit when last = 0;
					songs(i)(songs(i)'First..last) := song_str(song_str'First..last);
				end loop;
				artwork := (CATEGORY_ALBUM, title, support, rating, artist, songs);

			when CATEGORY_OTHER => artwork := (CATEGORY_OTHER, title, support, rating);
		end case;
	end Get;

	procedure Save(artwork: T_Artwork) is
		file:			P_Artwork_Sequential.File_Type;
	begin
		Open_Artwork_File(artwork.category, file, Append_File);
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
		file:		P_Artwork_Sequential.File_Type;
		artwork:	T_Artwork;
		index:		Natural;
	begin
		for category in T_Category loop
			index := 1;
			Open_Artwork_File(category, file, In_File);
			if not End_Of_File(file) then
				Put_Line(T_Category'Image(category));
				Put_Line(T_Category'Image(category)'Length * "=");
				New_Line;
			end if;

			while not End_Of_File(file) loop
				Read(file, artwork);
				Put_Line("Record" & Integer'Image(index));
				Put_Line("    Title:    " & artwork.title);
				Put_Line("    Support:  " & T_Support'Image(artwork.support));
				Put_Line("    Rating:  " & Integer'Image(artwork.rating));
				Put_Line("    Category: " & T_Category'Image(artwork.category));
				case artwork.category is
					when CATEGORY_FILM =>
						Put_Line("    Director: " & artwork.director);
						Put_Line("    VF: " & (if artwork.is_vf then "Yes" else "No"));
					when CATEGORY_GAME =>
						Put_Line("    Console: " & T_Console'Image(artwork.console));
						Put_Line("    Finished: "
						         & (if artwork.finished then "Yes" else "No"));
					when CATEGORY_ALBUM =>
						Put_Line("    Artist: " & artwork.artist);
						if artwork.songs'Length /= 0 then
							Put_Line("    Songs:");
						end if;
						for i in artwork.songs'Range loop
							exit when artwork.songs(i)(1) = Character'Val(0);
							Put_Line("    - " & artwork.songs(i));
						end loop;
					when CATEGORY_OTHER => null;
				end case;
				New_Line;
				index := index + 1;
			end loop;
			Close(file);
		end loop;
	end Display;


	procedure Open_Artwork_File(category: T_Category;
							    file: out P_Artwork_Sequential.File_Type;
								mode: P_Artwork_Sequential.File_Mode := In_File)
	is
	begin
		case category is
			when CATEGORY_FILM  => Open(file, mode, filename_film);
			when CATEGORY_GAME  => Open(file, mode, filename_game);
			when CATEGORY_ALBUM => Open(file, mode, filename_album);
			when CATEGORY_OTHER => Open(file, mode, filename_other);
		end case;
	end Open_Artwork_File;

	procedure Get_Yes_No(msg: String;
						 yes_no: out Boolean)
	is
		user_input:		String(1..256);
		user_input_len:	Natural;
	begin
		loop
			Put(msg & "[Y/n] ");
			Get_Line(user_input, user_input_len);
			user_input := to_lower(user_input);
			if user_input_len /= 1 or
			   (user_input(1) /= 'y' and user_input(1) /= 'n') then
				Put_Line("Bad choice");
			else
				yes_no := user_input(1) = 'Y';
				exit;
			end if;
		end loop;
		New_Line;
	end Get_Yes_No;

	procedure Get_Select(selection: String;
						 choice: Natural)
	is
	begin


		null;

	end Get_Select;

end Artwork_DB;
