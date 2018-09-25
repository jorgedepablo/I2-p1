with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Exceptions;
with Ada.IO_Exceptions;

procedure Divide_Words is
  package ASU renames Ada.Strings.Unbounded;
  package ATI renames Ada.Text_IO;

  procedure Trocear_Linea(Linea:in out ASU.Unbounded_String) is --Esto es un subprograma y lo de in out es como un ref
  Eol: Boolean := False; --A la vez que declaras la variable declaras su valor, esto en picky se hacia justo antes de empezar el procedure
  Palabra: ASU.Unbounded_String;
  Posicion: Natural;
  begin
    while not Eol loop --Eol esta a False ahora mismo
      Posicion:= ASU.Index(Linea, " "); -- Busca dentro de Linea un espacio (" ") y te devuelve la posicion en la que está en un numero natural
      if ASU.Length(Linea) = 0 then -- Esto es que la longitud de la linea es 0 y hay que saltarla
        Eol:= True;
        elsif Posicion = 0 then -- Posibilidad de que no tenga espacios en blanco
             ATI.Put_Line(ASU.To_String(Linea)); -- Devuelve la palabra a su sitio pero trnasformandola en un string que pueda manejar Ada
             Eol:=True;
        elsif Posicion = 1 then -- Posibilidad de que la linea empiece por un espacio antes que la palabra, si le restas una posicion al resto de frase se quedaria bien
              Linea:= ASU.Tail(Linea, ASU.Length(Linea)-1); -- Tail lo que hace es se queda con todo de la derecha desde lo que busca el primer index
        else
          Palabra:= ASU.Head(Linea, Posicion-1); -- Head se queda con todo lo de la izquierda desde lo que busca en index
          Linea:= ASU.Tail(Linea, ASU.Length(Linea)- Posicion); --La va dividiendo poco a poco se queda con lo de la derechay a dar otra vuelta
          ATI.Put_Line(ASU.To_String(Palabra));
        end if; -- La ruuuuueeeeda de las palabras esto da vueltas hasta que todas es esta troceaditas
    end loop;
  end Trocear_Linea;

  procedure Trocear_Texto(Fich: in ATI.File_Type) is   -- Otro subprograma, in solo lee dentro del procedimiento pero no modifica
		Eof: Boolean:= False;
		Linea: ASU.Unbounded_String;
		begin
			while not Eof loop
				begin
					Linea := ASU.To_Unbounded_String(Ada.Text_IO.Get_Line(Fich));   -- Pasas la linea a ilimitada y asi la puedes trocear
					Trocear_Linea(Linea);
				exception
					when Ada.IO_Exceptions.End_Error =>   --Cuando se acabe el fichero saltara este error
						Eof := True;
				end;
			end loop;
	end Trocear_Texto;

    Fich: ATI.File_Type;  --Asi se declara la variable de un fichero

begin

  ATI.Open(Fich, ATI.In_File, "f1.txt");
  Trocear_Texto(Fich);
  ATI.Close(Fich);

end Divide_Words;
