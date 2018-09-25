with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure Reverse_Line is

  package ASU renames Ada.Strings.Unbounded;
  package ATI renames Ada.Text_IO;

  type Cell;

  type Let_List is access Cell;

  type Cell is record
    Leter: ASU.Unbounded_Strings;
    Next: Let_List;
  end record;

begin

  null;

end Reverse_Line;
