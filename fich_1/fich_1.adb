with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure Fich_1 is
  package ASU renames Ada.Strings.Unbounded;

  Fich: Ada.Text_IO.File_Type;
  L: ASU.Unbounded_String;

begin

  Ada.Text_IO.Open(Fich, Ada.Text_IO.In_File, "prueba.txt");
  L := ASU.To_Unbounded_String(Ada.Text_IO.Get_Line(Fich));
  Ada.Text_IO.Put_Line(ASU.To_String(L));

end Fich_1;
