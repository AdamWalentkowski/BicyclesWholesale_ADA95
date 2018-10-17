package body Konsument is
   task body TKonsument is
      G: Losowa_Konsumpcja.Generator;	--  generator liczb losowych (czas)
      G2: Losowy_Zestaw.Generator;	--  też (zestawy)
      Nr_Konsumenta: Typ_Konsumenta;
      Numer_Zestawu: Integer;
      Konsumpcja: Integer;
      Rodzaj_Zestawu: Integer;
      Nazwa_Konsumenta: constant array (1 .. Liczba_Konsumentow)
	of String(1 .. 6)
	:= ("Jarek ", "Darek ");
   begin
      accept Zacznij(Numer_Konsumenta: in Typ_Konsumenta;
		     Czas_Konsumpcji: in Integer) do
	 Losowa_Konsumpcja.Reset(G);	--  ustaw generator
         Losowy_Zestaw.Reset(G2);	--  też
	 Nr_Konsumenta := Numer_Konsumenta;
	 Konsumpcja := Czas_Konsumpcji;
      end Zacznij;
      Put_Line("Pojawil sie konsument " & Nazwa_Konsumenta(Nr_Konsumenta));
      loop
	 delay Duration(Losowa_Konsumpcja.Random(G)); --  symuluj konsumpcję
	 Rodzaj_Zestawu := Losowy_Zestaw.Random(G2);
         -- pobierz zestaw do konsumpcji
         select
            B.Wydaj(Rodzaj_Zestawu, Numer_Zestawu);
            if Numer_Zestawu = 0 then
               Put_Line("Nie pobrano zestawu: " & Nazwa_Zestawu(Rodzaj_Zestawu));
            else
               Put_Line(Nazwa_Konsumenta(Nr_Konsumenta) & ": pobrano zestaw " &
                          Nazwa_Zestawu(Rodzaj_Zestawu) & " numer " &
                          Integer'Image(Numer_Zestawu));
            end if;
         else
               Put_Line(Nazwa_Konsumenta(Nr_Konsumenta)
                        & " zniecierpliwil sie i zrezygnowal z zakupu.");
         end select;
      end loop;
   end TKonsument;
end Konsument;
