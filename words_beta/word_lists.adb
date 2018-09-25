with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Unchecked_Deallocation; -- Este paquete sirve para dejar libre un puntero
with Ada.IO_Exceptions;

package body Word_Lists is

  package ATI renames Ada.Text_IO;
  package EXC renames Ada.IO_Exceptions;
      -- ASU esta definido en el ads no hace falta definirlo aqui
  use type ASU.Unbounded_String;

  procedure Free is new Ada.Unchecked_Deallocation(Cell, Word_List_Type); -- Este procedure sirve para dejar libre un puntero

  procedure Add_Word (List: in out Word_List_Type; Word: in ASU.Unbounded_String) is
    Aux_List: Word_List_Type := List; -- Declaras el puntero auxiliar del mismo tipo que el principal (List) y le das el valor(ojo posible error)
    Last_Word: Word_List_Type := List;
    Finish: Boolean := False; -- A la vez que declaras el boolean le puedes dar el valor(False en este caso)
  begin
    if List = null then -- Si el primeto esta vacio lo que hace es :
      List := new Cell; -- Asignarle una nueva celda
      List.Word := Word; -- Guardar la palabra en esa celda
      List.Count := 1;  -- Poner el contador a uno en esa celda
    else
      while not Finish and Aux_List /= null loop --Pones esto primero para evitar que se te metan palabras repetidas en la lista
        if Word = Aux_List.Word then  -- Si ya existe la va a meter simplemente sumando uno al contador
          Aux_List.Count := Aux_List.Count + 1;
          Finish := True;
        else
          Last_Word := Aux_List; --Auxiliar para guardar la palabra anterior que luego necesitaremos
          Aux_List := Aux_List.Next;
        end if;
      end loop;
      if not Finish then
        Last_Word.Next := new Cell'(Word,1,null); -- Cuando ya estas en el siguiente creas una nueva celd
      end if;
    end if;
  end Add_Word;

  procedure Delete_Word (List: in out Word_List_Type; Word: in ASU.Unbounded_String) is
    Aux_1: Word_List_Type := List;
    Aux_2: Word_List_Type := List;
    Finish: Boolean := False;
  begin
    if List = null then  -- Caso en el que la lista sea nula
      ATI.Put_Line("Empty List");
    elsif Word = List.Word then  -- SI la palabra esta al pricipio de la lista
      Aux_2 := Aux_1.Next;
      Free(List);
      List := Aux_2;
    else -- Caso de que la palabra que buscas este por medio de la lista
      Aux_1 := Aux_2.Next;
      while not Finish loop
        if Word = Aux_1.Word then --Busca la palabra en la lista
          Aux_2.Next := Aux_1.Next;
          Free(Aux_1);
          Finish := True; -- Si la encuentra se sale del bucle
        else                  --Esto va iterando pasando a la siguiente palabra si no la encuente
          Aux_1 := Aux_1.Next;
          Aux_2 := Aux_2.Next;
          if Aux_2.Next = null then -- Si ha llegado al final de lista y no lo ha encontrado es que no esta
            raise Word_List_Error; -- Si no la encuentra eleva el error
          end if;
        end if;
      end loop;
    end if;
  end Delete_Word;

  procedure Search_Word (List: in Word_List_Type; Word: in ASU.Unbounded_String; Count: out Natural) is
    Aux_List: Word_List_Type := List;
    Finish: Boolean := False;
  begin
    if List = null then -- HABLAR CON PROFE A VER SI SE HACE ASI
      ATI.Put_Line("Empty List");
    end if;
    while not Finish loop
      if Word = Aux_List.Word and Aux_List /= null then -- si la palabra es igual al puntero al que esta apuntando
        Count := Aux_List.Count;
        Finish := True; -- Escribe la palabra y finaliza el program
      else
        Aux_List := Aux_List.Next;  -- Si no esta pasará  al siguiente puntero de manera infinita
      end if;
    end loop;
  end Search_Word;

  procedure Max_Word (List: in Word_List_Type; Word: out ASU.Unbounded_String; Count: out Natural) is
      Aux_List: Word_List_Type := List;
    begin
      Count := 0;
      if List = null then --SI la lista esta vacia eleva a word list error
        raise Word_List_Error;
      end if;
      while Aux_List /= null loop
        if Aux_List.Count > Count then --si el count de la que estas es mas grande
          Word := Aux_List.Word;  --Guarda el la palabra y el count
          Count := Aux_List.Count;
        else
          Aux_List := Aux_List.Next; -- Si el count es mas pequeño va iterando hasta que salta un error que se resuelve en el programa principal
        end if;
      end loop;
    end Max_Word;

    procedure Print_All (List: in Word_List_Type) is
      Aux_List: Word_List_Type := List;
    begin
      if List /= null then -- Si la primera palabra de la lista no esta vacia :
        while Aux_List /= null loop -- Mientras sea la ultima palabra, pones la word de ese puntero y el count
          ATI.Put_Line("|" & ASU.To_String(Aux_List.Word) & "|" & Integer'Image(Aux_List.Count)); -- Manera de poner el count
          Aux_List := Aux_List.Next; -- Pasas al siguiente puntero y entrara en bucle mientras no des con un null
        end loop;
      else
        ATI.Put_Line("No words."); -- En caso de que la primera de la lista sea null pones un no words y fuera
      end if;
    end Print_All;

    procedure Delete_List (List: in out Word_List_Type) is
      Aux_1: Word_List_Type := List;
      Aux_2: Word_List_Type := List;
      Finish: Boolean := False;
    begin
    if List = null then
      null;
    elsif List.Next = null then --Si llega al ultimo
      Aux_2 := Aux_1.Next; --Usa el auxiliar para guardar al que apunta
      Free(Aux_1); -- BORRA ese
      List := Aux_2; -- y vuelve a igualar list al aux1.next
    else
       Aux_1 := Aux_2.Next; -- Si hay varias
      while not Finish loop
        if Aux_1 /= null then
          Aux_2.Next := Aux_1.Next;
          Free(Aux_1); --Las va borrando
          Finish := True;
        elsif Aux_1 = null then
          raise Word_List_Error;
        else
          Aux_1 := Aux_1.Next; -- e itera hasta que o se borren todas o salte Word_List_Error
          Aux_2 := Aux_2.Next;
        end if;
      end loop;
    end if;
end Delete_List;

end Word_Lists;
