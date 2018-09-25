with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.IO_Exceptions; --Para lo de elevar los errores
with Ada.Command_Line; --Para poder meter comandos después del ./
with Word_Lists; -- EL que hemos hecho nosotros con el ads
with Ada.Exceptions;
with Ada.Characters.Handling; --minuscualas
with Ada.Strings.Maps;

procedure Words is

  package ATI renames Ada.Text_IO;  -- Los renombras para ahorrarte poner mierda abajo
  package ASU renames Ada.Strings.Unbounded;
  package ACL renames Ada.Command_Line;
  package EXCP renames Ada.IO_Exceptions;
  package ACH renames Ada.Characters.Handling;

  Usage_Error: exception;

  procedure Cut_Line(Line: in out ASU.Unbounded_String; List: in out Word_Lists.Word_List_Type) is --Esto es un subprograma y lo de in out es como un ref
    Eol: Boolean := False; --A la vez que declaras la variable le das su valor(False)
    Posicion: Natural; --Numero entero natural
    Word: ASU.Unbounded_String; -- Ponemos la palabra en unbounded para poder comparar y jugar con ella sin que de error
    Lower_Line: ASU.Unbounded_String;
    Lower_Word: ASU.Unbounded_String;
  begin
    while not Eol loop -- Eol ahora mismo esta a false
      Posicion := ASU.Index(Line, Ada.Strings.Maps.To_Set(" ,.:;_-<>´¨{}*`[]¿?'¡^ºª!""@#·$~%&¬/()=+€¶æßðđŋ¶¢ð“ħŧ↓µ”ŧ←↓→øþ«»ł" & Character'Val(9))); --Busca dentro de Line un " " espacio en blanco y te da un numero natural de donde lo encuentra
      if ASU.Length(Line) = 0 then --Esto te da si la longitud de linea es 0
        Eol := True; -- Si es 0 es decir linea vacia EOL es true y se sale del bucle
      else
        if Posicion = 0 then -- Posibilidad de que no tenga espacios en blanco
          Lower_Line := ASU.To_Unbounded_String(ACH.To_Lower(ASU.To_String(Line)));
          Word_Lists.Add_Word(List, Lower_Line);-- Mete la palabra a la lista directamente
          Eol := True; -- Como no tienes espacios suponemos que es una palabra y en cuanto la meta se acabara la linea
          elsif Posicion = 1 then -- Posibilidad de que la linea empiece por un espacio antes que la palabra, si le restas una posicion al resto de frase se quedaria bien
            Line:= ASU.Tail(Line, ASU.Length(Line)-1); -- Tail lo que hace es se queda con todo de la derecha desde lo que busca el primer index
          else
            Word := ASU.Head(Line, Posicion-1); -- Head se queda con todo lo de la izquierda desde lo que busca en index
            Lower_Word := ASU.To_Unbounded_String(ACH.To_Lower(ASU.To_String(Word)));
            Line := ASU.Tail(Line, ASU.Length(Line)- Posicion); --La va dividiendo poco a poco se queda con lo de la derechay a dar otra vuelta
            Word_Lists.Add_Word(List, Lower_Word);
          end if; -- La ruuuuueeeeda de las palabras esto da vueltas hasta que la linea este a 0 y marque EOL true
        end if;
      end loop;
  end Cut_Line;

  procedure Cut_Text(Fich: in ATI.File_Type; List: in out Word_Lists.Word_List_Type) is -- Este el fich no lo edita pero si la List (in out e in)
    Eof: Boolean:= False;
    Line: ASU.Unbounded_String;
  begin
    while not Eof loop
      begin
        Line := ASU.To_Unbounded_String(Ada.Text_IO.Get_Line(Fich));   -- Pasas la linea a ilimitada y asi la puedes trocear
        Cut_Line(Line, List);
      exception
        when Ada.IO_Exceptions.End_Error =>   --Cuando se acabe el fichero saltara este error
          Eof := True; -- Y asi se salen cuando se le acaben las lineas
      end;
    end loop;
  end Cut_Text;

  procedure Delete_Word (List: in out Word_Lists.Word_List_Type; Word: in ASU.Unbounded_String) is
    Lower_Word: ASU.Unbounded_String;
  begin
    Lower_Word := ASU.To_Unbounded_String(ACH.To_Lower(ASU.To_String(Word)));
    Word_Lists.Delete_Word(List, Lower_Word);
    ATI.Put_Line("|" & ASU.To_String(Lower_Word)& "| Deleted"); --Evitamos que escriba words_list

  exception
    when Word_Lists.Word_List_Error => --Excepcion de nuestro paquete
      ATI.Put_Line("Word List Error: Not found this word in the list");

  end Delete_Word;

  Procedure Search_Word (List: in out Word_Lists.Word_List_Type; Word: in ASU.Unbounded_String) is
      C: Natural := 0;
      Lower_Word: ASU.Unbounded_String;
  begin
    Lower_Word := ASU.To_Unbounded_String(ACH.To_Lower(ASU.To_String(Word)));
    Word_Lists.Search_Word(List, Lower_Word, C); -- Hacemos que nos pase le count en out (definido en el paquete)
    ATI.Put_Line("|" & ASU.To_String(Lower_Word)& "|" & Integer'Image(C)); --Evitamos que Word_Lists escriba cosas

  exception
    when Constraint_Error => -- Este error salta si no encuentra la palabra
      ATI.Put_Line("|" & ASU.To_String(Lower_Word) & "| 0"); -- Pone esto

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
    when Word_Lists.Word_List_Error => --Excepcion del paquete Word List
        ATI.Put_Line("Word List Error: Not found words in list");

  end Most_Frecuent_Word;

  procedure Show_Menu is
    begin
      ATI.New_Line(1); -- Deja linea en blanco
      ATI.Put_Line("Options");
      ATI.Put_Line("1 Add word");
      ATI.Put_Line("2 Delete word");
      ATI.Put_Line("3 Search word");
      ATI.Put_Line("4 Show all words");
      ATI.Put_Line("5 Quit");
      ATI.New_Line(1); -- Deja un espacio alfinal
    end Show_Menu;

  procedure Main_Menu(Option: in out Natural; List: in out Word_Lists.Word_List_Type) is
    Word: ASU.Unbounded_String;
    Finish: Boolean := False;
    begin
      while not Finish loop
        begin
          Show_Menu;
          ATI.Put("Your option? ");
          Option := Integer'Value(Ada.Text_IO.Get_Line); -- Pasa un string a int
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

  if ACL.Argument_Count = 1  then -- El caso de que solo le pases un argumento (el nombre del fichero)
    File := ASU.To_Unbounded_String(ACL.Argument(1)); -- Guardas el nombre de ese fichero (el argumento 1) en una variable
    ATI.Open(Fich, ATI.In_File, ASU.To_String(File)); -- Abres el fichero de la manera normal y como nombre de fichero le pasas la variable transformada a string de ada      Cut_Text(Fich, List);
    Cut_Text(Fich, List); -- Crea la lista
    Most_Frecuent_Word(List); -- Muestra la mas frecuente
    Word_Lists.Delete_List(List);
    Word_Lists.Print_All(List);
    ATI.Close(Fich);
  elsif ACL.Argument_Count = 2 and ACL.Argument(1) = ("-i") then
    File := ASU.To_Unbounded_String(ACL.Argument(2));
    ATI.Open(Fich, ATI.In_File, ASU.To_String(File)); -- Abres el fichero de la manera normal y como nombre de fichero le pasas la variable transformada a string de ada
    Cut_Text(Fich, List); -- Crea la lista
    Main_Menu(N, List); -- Entras en el menu interactivo
    Word_Lists.Delete_List(List);
    ATI.Close(Fich);
  else
    raise Usage_Error; -- Si le pasas cualquier otra cosa da error
  end if;

exception
  when Usage_Error =>
    ATI.Put_Line("usage: words [-i] <filename>");
  when Except: Constraint_Error =>
    ATI.Put_Line("usage: words [-i] <filename>");
    ATI.Put_Line(Ada.Exceptions.Exception_Name(Except) & "!!");
  when Ada.IO_Exceptions.Name_Error =>
    ATI.Put(ASU.To_String(File));
    ATI.Put_Line(": File not found");
  when Except:others =>
    ATI.Put("UNEXPECTED ERROR: ");
    ATI.Put_Line(Ada.Exceptions.Exception_Name(Except) & "!!");

end Words;
