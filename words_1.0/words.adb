with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.IO_Exceptions;
with Ada.Command_Line;
with Word_Lists;
with Ada.Exceptions;
with Ada.Characters.Handling;
with Ada.Strings.Maps;

procedure Words is

  package ATI renames Ada.Text_IO;
  package ASU renames Ada.Strings.Unbounded;
  package ACL renames Ada.Command_Line;
  package EXCP renames Ada.IO_Exceptions;
  package ACH renames Ada.Characters.Handling;

  Usage_Error: exception;

  procedure Cut_Line(Line: in out ASU.Unbounded_String; List: in out Word_Lists.Word_List_Type) is
    Eol: Boolean := False;
    Posicion: Natural;
    Word: ASU.Unbounded_String;
    Lower_Line: ASU.Unbounded_String;
    Lower_Word: ASU.Unbounded_String;
  begin
    while not Eol loop
      Posicion := ASU.Index(Line, Ada.Strings.Maps.To_Set(" ,.:;_-<>´¨{}*`[]¿?'¡^ºª!""@#·$~%&¬/()=+€¶æßðđŋ¶¢ð“ħŧ↓µ”ŧ←↓→øþ«»ł" & Character'Val(9)));
      if ASU.Length(Line) = 0 then
        Eol := True;
      else
        if Posicion = 0 then
          Lower_Line := ASU.To_Unbounded_String(ACH.To_Lower(ASU.To_String(Line)));
          Word_Lists.Add_Word(List, Lower_Line);
          Eol := True;
        elsif Posicion = 1 then
          Line:= ASU.Tail(Line, ASU.Length(Line)-1);
        else
          Word := ASU.Head(Line, Posicion-1);
          Lower_Word := ASU.To_Unbounded_String(ACH.To_Lower(ASU.To_String(Word)));
          Line := ASU.Tail(Line, ASU.Length(Line)- Posicion);
          Word_Lists.Add_Word(List, Lower_Word);
        end if;
      end if;
    end loop;
  end Cut_Line;

  procedure Cut_Text(Fich: in ATI.File_Type; List: in out Word_Lists.Word_List_Type) is
    Eof: Boolean:= False;
    Line: ASU.Unbounded_String;
  begin
    while not Eof loop
      begin
        Line := ASU.To_Unbounded_String(Ada.Text_IO.Get_Line(Fich));
        Cut_Line(Line, List);
      exception
        when Ada.IO_Exceptions.End_Error =>
          Eof := True;
      end;
    end loop;
  end Cut_Text;

  procedure Delete_Word (List: in out Word_Lists.Word_List_Type; Word: in ASU.Unbounded_String) is
    Lower_Word: ASU.Unbounded_String;
  begin
    Lower_Word := ASU.To_Unbounded_String(ACH.To_Lower(ASU.To_String(Word)));
    Word_Lists.Delete_Word(List, Lower_Word);
    ATI.Put_Line("|" & ASU.To_String(Lower_Word)& "| Deleted");

  exception
    when Word_Lists.Word_List_Error =>
      ATI.Put_Line("Word List Error: Not found this word in the list");

  end Delete_Word;

  Procedure Search_Word (List: in out Word_Lists.Word_List_Type; Word: in ASU.Unbounded_String) is
      C: Natural := 0;
      Lower_Word: ASU.Unbounded_String;
  begin
    Lower_Word := ASU.To_Unbounded_String(ACH.To_Lower(ASU.To_String(Word)));
    Word_Lists.Search_Word(List, Lower_Word, C);
    ATI.Put_Line("|" & ASU.To_String(Lower_Word)& "|" & Integer'Image(C));

  exception
    when Constraint_Error =>
      ATI.Put_Line("|" & ASU.To_String(Lower_Word) & "| 0");

  end Search_Word;

  procedure Most_Frecuent_Word (List: in out Word_Lists.Word_List_Type) is
    Word: ASU.Unbounded_String;
    C: Natural := 0;
  begin
    Word_Lists.Max_Word(List, Word, C);
    ATI.Put("The most frequent word: ");
    ATI.Put_Line("|" & ASU.To_String(Word) & "| - " & Integer'Image(C));
    ATI.New_Line(1);

  exception
    when Word_Lists.Word_List_Error =>
        ATI.Put_Line("Word List Error: Not found words in list");

  end Most_Frecuent_Word;

  procedure Show_Menu is
  begin
    ATI.New_Line(1);
    ATI.Put_Line("Options");
    ATI.Put_Line("1 Add word");
    ATI.Put_Line("2 Delete word");
    ATI.Put_Line("3 Search word");
    ATI.Put_Line("4 Show all words");
    ATI.Put_Line("5 Quit");
    ATI.New_Line(1);
  end Show_Menu;

  procedure Main_Menu(Option: in out Natural; List: in out Word_Lists.Word_List_Type) is
    Word: ASU.Unbounded_String;
    Finish: Boolean := False;
    begin
      while not Finish loop
        begin
          Show_Menu;
          ATI.Put("Your option? ");
          Option := Integer'Value(Ada.Text_IO.Get_Line);
          case Option is
            when 1 =>
              ATI.Put("Word? ");
              Word := ASU.To_Unbounded_String(ATI.Get_Line);
              ATI.Put_Line("Word |" & ASU.To_String(Word) & "| added");
              Cut_Line(Word, List);
            when 2 =>
              ATI.Put("Word? ");
              Word := ASU.To_Unbounded_String(ATI.Get_Line);
              Delete_Word(List, Word);
            when 3 =>
              ATI.Put("Word? ");
              Word := ASU.To_Unbounded_String(ATI.Get_Line);
              Search_Word(List, Word);
            when 4 =>
              ATI.New_Line(1);
              Word_Lists.Print_All(List);
            when 5 =>
              Most_Frecuent_Word(List);
              Finish := True;
            when others =>
              ATI.Put_Line("Option out of range");
            end case;
        exception
          when Except: others =>
            ATI.Put_Line("Invalid Option");
        end;
      end loop;
    end Main_Menu;

    List: Word_Lists.Word_List_Type;
    Fich: ATI.File_Type;
    File: ASU.Unbounded_String;
    N: Natural := 0;

begin

  if ACL.Argument_Count = 1  then
    File := ASU.To_Unbounded_String(ACL.Argument(1));
    ATI.Open(Fich, ATI.In_File, ASU.To_String(File));
    Cut_Text(Fich, List);
    Most_Frecuent_Word(List);
    Word_Lists.Delete_List(List);
    ATI.Close(Fich);
  elsif ACL.Argument_Count = 2 and ACL.Argument(1) = ("-i") then
    File := ASU.To_Unbounded_String(ACL.Argument(2));
    ATI.Open(Fich, ATI.In_File, ASU.To_String(File));
    Cut_Text(Fich, List);
    Main_Menu(N, List);
    Word_Lists.Delete_List(List);
    ATI.Close(Fich);
  else
    raise Usage_Error;
  end if;

exception
  when Usage_Error =>
    ATI.Put_Line("usage: words [-i] <filename>");
  when Constraint_Error =>
    ATI.Put_Line("usage: words [-i] <filename>");
  when Ada.IO_Exceptions.Name_Error =>
    ATI.Put(ASU.To_String(File));
    ATI.Put_Line(": File not found");
  when Except:others =>
    ATI.Put("UNEXPECTED ERROR: ");
    ATI.Put_Line(Ada.Exceptions.Exception_Name(Except) & "!!");

end Words;
