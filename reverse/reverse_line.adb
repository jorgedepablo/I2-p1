with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure Reverse_Line is

  package ASU renames Ada.Strings.Unbounded;
  package ATI renames Ada.Text_IO;

  type Cell;

  type Let_List is access Cell;

  type Cell is record
    Leter: Character;
    Next: Let_List;
  end record;

  procedure Add_Char(List: in out Let_List; C: Character) is
  begin
    null;
  end Add_Char;


  Frase: ASU.Unbounded_String;
begin

    Frase := ASU.To_Unbounded_String(ATI.Get_Line);

end Reverse_Line;
