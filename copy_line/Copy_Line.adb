with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure Copy_Line is

  package ASU renames Ada.Strings.Unbounded;
  package ATI renames Ada.Text_IO;

  type Word_Record;

  type Word_Pointer is access Word_Record;

  type Word_Record is record
    Word: ASU.Unbounded_String;
    Next: Word_Pointer;
  end record;

  Lista_Frases : Word_Pointer;
  Aux : Word_Pointer;

procedure Guardar (Linea: ASU.Unbounded_String) is

  begin
    if Lista_Frases = null then
    Lista_Frases := new Word_Record;
    Lista_Frases.Word := Linea;
    Lista_Frase.Next := null;
    Aux := new Word_Record(null,null);
    Aux :=

  Linea : ASU.Unbounded_String;
  Final: boolean;


begin
  Final:= False;
  Lista_Frase :=
  while not Final loop
    Linea := ASU.To_Unbounded_String(ATI.Get_Line);
    if ASU.To_String(Frase) = "Fin" then
      Final := True;
    else
      ATI.Put_Line(ASU.To_String(Linea));
    end if;
  end loop;
end Copy_Line;
