package body Producent is
   task body TProducent is
   package Losowa_Produkcja is new
	Ada.Numerics.Discrete_Random(Zakres_Czasu_Produkcji);
      G: Losowa_Produkcja.Generator;	--  generator liczb losowych
      Nr_Typu_Wyrobu: Integer;
      Numer_Wyrobu: Integer;
      Produkcja: Integer;
      Czy_Przyjelo: Integer;
      Przekroczenie_limitu: exception;
   begin
      accept Zacznij(Wyrob: in Typ_Wyrobow; Czas_Produkcji: in Integer) do
	 Losowa_Produkcja.Reset(G);	--  zacznij generator liczb losowych
	 Numer_Wyrobu := 1;
	 Nr_Typu_Wyrobu := Wyrob;
         Produkcja := Czas_Produkcji;
         Czy_Przyjelo := 0;
      end Zacznij;
      Put_Line("Otwarto produkcje wyrobu " & Nazwa_Wyrobu(Nr_Typu_Wyrobu));
      loop
	 delay Duration(Losowa_Produkcja.Random(G)); --  symuluj produkcję
	 Put_Line("Wyprodukowano wyrób " & Nazwa_Wyrobu(Nr_Typu_Wyrobu)
		    & " numer "  & Integer'Image(Numer_Wyrobu));
         -- Wstaw do magazynu
         select
            B.Przyjmij(Nr_Typu_Wyrobu, Numer_Wyrobu, Czy_Przyjelo);
            if Czy_Przyjelo = 0 then
               Put_Line("Odrzucono wyrób " & Nazwa_Wyrobu(Nr_Typu_Wyrobu) & " nr " &
                          Integer'Image(Numer_Wyrobu) & ". Probuje ponownie..");
               delay Duration(1.0);
               B.Przyjmij(Nr_Typu_Wyrobu, Numer_Wyrobu, Czy_Przyjelo);
               if Czy_Przyjelo = 0 then
                     raise Przekroczenie_limitu;
               else
                  Numer_Wyrobu := Numer_Wyrobu + 1;
               end if;
            else
               Numer_Wyrobu := Numer_Wyrobu + 1;
            end if;
         else
            Put_Line(Nazwa_Wyrobu(Nr_Typu_Wyrobu)
                    & " numer "  & Integer'Image(Numer_Wyrobu)
                     & " zardzewial, zostaje wyrzucony.");
         end select;
      end loop;
      exception
         when Przekroczenie_limitu => Put_Line("Przekroczono ilosc prob");
   end TProducent;
end Producent;
