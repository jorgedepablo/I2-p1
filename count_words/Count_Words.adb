with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure Count_Words is
  package ASU renames Ada.Strings.Unbounded;
  package ATI renames Ada.Text_IO;

  Fich: ATI.File_Type;
  Palabra: ASU.Unbounded_String;

begin

  ATI.Open(Fich, ATI.In_File, "f1.txt");
  Palabra: ASU.To_Unbounded_String(ATI.Get_Line(Fich));




end Count_Words;
