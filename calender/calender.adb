with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Strings.Maps;

procedure Calender is

  package ATI renames Ada.Text_IO;
  package ASU renames Ada.Strings.Unbounded;

  Mes_1: Integer;
  Year_1: Integer;
  Mes_2: Integer;
  Year_2: Integer;
  Fich: ATI.File_Type;

begin
  ATI.Put("Introduce mes inicial: ");
  Mes_1 := Integer'Value(ATI.Get_Line);
  ATI.New_Line(1);
  ATI.Put("Introduce año inicial: ");
  Year_1 := Integer'Value(ATI.Get_Line);
  ATI.New_Line(1);
  ATI.Put("Introduce mes final: ");
  Mes_2 := Integer'Value(ATI.Get_Line);
  ATI.New_Line(1);
  ATI.Put("Introduce año fianl: ");
  Year_2 := Integer'Value(ATI.Get_Line);
  ATI.Create(Fich, ATI.Out_FIle, "prueba.txt");
  ATI.Put_Line(Fich, Mes_1 & Year_1 & "Desde este año");
  ATI.Put_Line(Fich, Mes_2 & Year_2 & "Hasta este año");
end Calender;
