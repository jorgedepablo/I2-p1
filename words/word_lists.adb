with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Unchecked_Deallocation;

package body Word_Lists is

  package ATI renames Ada.Text_IO;

  use type ASU.Unbounded_String;

  procedure Free is new Ada.Unchecked_Deallocation(Cell, Word_List_Type);

  procedure Add_Word (List: in out Word_List_Type; Word: in ASU.Unbounded_String) is
    Aux_List: Word_List_Type := List;
    Last_Word: Word_List_Type := List;
    Finish: Boolean := False;
  begin
    if List = null then
      List := new Cell;
      List.Word := Word;
      List.Count := 1;
    else
      while not Finish and Aux_List /= null loop
        if Word = Aux_List.Word then
          Aux_List.Count := Aux_List.Count + 1;
          Finish := True;
        else
          Last_Word := Aux_List;
          Aux_List := Aux_List.Next;
        end if;
      end loop;
      if not Finish then
        Last_Word.Next := new Cell'(Word,1,null);
      end if;
    end if;
  end Add_Word;

  procedure Delete_Word (List: in out Word_List_Type; Word: in ASU.Unbounded_String) is
    Aux_1: Word_List_Type := List;
    Aux_2: Word_List_Type := List;
    Finish: Boolean := False;
  begin
    if List = null then
      raise Word_List_Error;
    end if;

    if Word = List.Word then
      Aux_2 := Aux_1.Next;
      Free(List);
      List := Aux_2;
    else
      Aux_1 := Aux_2.Next;
      while not Finish loop
        if Word = Aux_1.Word then
          Aux_2.Next := Aux_1.Next;
          Free(Aux_1);
          Finish := True;
        else
          Aux_1 := Aux_1.Next;
          Aux_2 := Aux_2.Next;
          if Aux_2.Next = null then
            raise Word_List_Error;
          end if;
        end if;
      end loop;
    end if;
  end Delete_Word;

  procedure Search_Word (List: in Word_List_Type; Word: in ASU.Unbounded_String; Count: out Natural) is
    Aux_List: Word_List_Type := List;
    Finish: Boolean := False;
  begin
    if List = null then
      Count := 0;
      return;
    end if;

    while not Finish loop
      if Word = Aux_List.Word and Aux_List /= null then
        Count := Aux_List.Count;
        Finish := True;
      else
        Aux_List := Aux_List.Next;
      end if;
    end loop;
  end Search_Word;

  procedure Max_Word (List: in Word_List_Type; Word: out ASU.Unbounded_String; Count: out Natural) is
      Aux_List: Word_List_Type := List;
    begin
      Count := 0;
      if List = null then
        raise Word_List_Error;
      end if;

      while Aux_List /= null loop
        if Aux_List.Count > Count then
          Word := Aux_List.Word;
          Count := Aux_List.Count;
        else
          Aux_List := Aux_List.Next;
        end if;
      end loop;
    end Max_Word;

    procedure Print_All (List: in Word_List_Type) is
      Aux_List: Word_List_Type := List;
    begin
      if List /= null then
        while Aux_List /= null loop
          ATI.Put_Line("|" & ASU.To_String(Aux_List.Word) & "|" & Integer'Image(Aux_List.Count));
          Aux_List := Aux_List.Next;
        end loop;
      else
        ATI.Put_Line("No words.");
      end if;
    end Print_All;

    procedure Delete_List (List: in out Word_List_Type) is
        Aux_List: Word_List_Type := List;
        Word: ASU.Unbounded_String;
    begin
      while Aux_List /= null loop
        Word := Aux_List.Word;
        Delete_Word(List, Word);
        Aux_List := Aux_List.Next;
      end loop;
  end Delete_List;

end Word_Lists;
