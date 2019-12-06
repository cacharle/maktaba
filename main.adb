with Ada.Text_IO, Ada.Integer_Text_IO;
use  Ada.Text_IO, Ada.Integer_Text_IO;

with Artwork_DB;
use  Artwork_DB;


procedure Main is
	filename_manual: constant String := "manual.txt";
	procedure Put_Manual is
		file: File_Type;
		line: String(1..256);
		last: Natural;
	begin
		Open(file, In_File, filename_manual);
		while not End_Of_File(file) loop
			Get_Line(file, line, last);
			Put_Line(line(line'First..last));
		end loop;
		Close(file);
	end Put_Manual;

	user_input:		String(1..256) := (others => Character'Val(0));
	user_input_len:	Natural;
	tmp_artwork:	T_Artwork;
begin
	Put_Line("enter 'manual' for more information");
	loop
		Put("> ");
		user_input := (others => Character'Val(0));
		Get_Line(user_input, user_input_len);

		if    user_input(1..3) = "add" then
			Get(tmp_artwork);
			Save(tmp_artwork);
		elsif user_input(1..6) = "modify" then
			Put_line("bonjour");
		elsif user_input(1..6) = "delete" then
			Put_line("bonjour");
		elsif user_input(1..5) = "print" then
			Display;
		elsif user_input(1..6) = "manual" then
			Put_Manual;
		elsif user_input(1..4) = "exit" then
			exit;
		else
			Put_Line("Invalid command enter: 'manual' for more information");
		end if;
		new_line;
	end loop;
end Main;
