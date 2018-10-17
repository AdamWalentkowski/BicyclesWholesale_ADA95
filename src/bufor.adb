package body Bufor is
   task body TBufor is

      Pojemnosc_Magazynu: constant Integer := 30;
      type Typ_Magazynu is array (Typ_Wyrobow) of Integer;
      Magazyn: Typ_Magazynu
	:= (0, 0, 0, 0, 0);
      Sklad_Zestawu: array(Typ_Zestawow, Typ_Wyrobow) of Integer
	:= ((1, 0, 1, 0, 2),
	    (2, 1, 1, 2, 2),
	    (3, 1, 1, 1, 2));
      Max_Sklad_Zestawu: array(Typ_Wyrobow) of Integer;
      Numer_Zestawu: array(Typ_Zestawow) of Integer
	:= (1, 1, 1);
      W_Magazynie: Integer := 0;
      Dzien: Integer := 1;

      procedure Ustaw_Zmienne is
      begin
	 for W in Typ_Wyrobow loop
	    Max_Sklad_Zestawu(W) := 0;
	    for Z in Typ_Zestawow loop
	       if Sklad_Zestawu(Z, W) > Max_Sklad_Zestawu(W) then
		  Max_Sklad_Zestawu(W) := Sklad_Zestawu(Z, W);
	       end if;
	    end loop;
	 end loop;
      end Ustaw_Zmienne;

      function Mozna_Przyjac(Wyrob: Typ_Wyrobow) return Boolean is
	 Wolne: Integer;		--  wolne miejsce w magazynie
	 -- ile brakuje wyrobów w magazynie do produkcji dowolnego zestawu
	 Brak: array(Typ_Wyrobow) of Integer;
	 -- ile potrzeba miejsca w magazynie, by wyprodukować dowolny wyrób
	 Braki: Integer;
	 MP: Boolean;			--  można przyjąć
      begin
	 if W_Magazynie >= Pojemnosc_Magazynu then
	    return False;
	 end if;
	 -- W magazynie są wolne miejsca
	 Wolne := Pojemnosc_Magazynu - W_Magazynie;
	 MP := True;
	 for W in Typ_Wyrobow loop
	    if Magazyn(W) < Max_Sklad_Zestawu(W) then
	       MP := False;
	    end if;
	 end loop;
	 if MP then
	    return True;		--  w magazynie są już części na dowolny
	       				--  zestaw
	 end if;
	 if Integer'Max(0, Max_Sklad_Zestawu(Wyrob) - Magazyn(Wyrob)) > 0 then
	    -- właśnie tego wyrobu brakuje
	    return True;
	 end if;
	 Braki := 1;			--  dodajemy bieżący wyrób
	 for W in Typ_Wyrobow loop
	    Brak(W) := Integer'Max(0, Max_Sklad_Zestawu(W) - Magazyn(W));
	    Braki := Braki + Brak(W);
	 end loop;
	 if Wolne >= Braki then
	    -- w magazynie jest miejsce, żeby skompletować dowolny wyrób
	    return True;
	 else
	    -- brakuje miejsca dla takiej części
	    return False;
	 end if;
      end Mozna_Przyjac;

      function Mozna_Wydac(Zestaw: Typ_Zestawow) return Boolean is
      begin
	 for W in Typ_Wyrobow loop
	    if Magazyn(W) < Sklad_Zestawu(Zestaw, W) then
	       return False;
	    end if;
	 end loop;
	 return True;
      end Mozna_Wydac;

      procedure Sklad_Magazynu is
      begin
	 for W in Typ_Wyrobow loop
	    Put_Line("Skład magazynu: " & Integer'Image(Magazyn(W)) & " "
		       & Nazwa_Wyrobu(W));
	 end loop;
      end Sklad_Magazynu;

   begin
      Put_Line("Otwarto magazyn");
      Ustaw_Zmienne;
      loop
         Put_Line("Dzien: " & Integer'Image(Dzien));
         Dzien := Dzien + 1;
         select
               accept Przyjmij(Wyrob: in Typ_Wyrobow; Numer: in Integer; Przyjelo: in out Integer) do
                  if Mozna_Przyjac(Wyrob) then
                     Put_Line("Przyjęto wyrób " & Nazwa_Wyrobu(Wyrob) & " nr " &
                                Integer'Image(Numer));
                     Magazyn(Wyrob) := Magazyn(Wyrob) + 1;
                     W_Magazynie := W_Magazynie + 1;
                     Przyjelo := 1;
                  else 
                     Przyjelo := 0;
                  end if;
               end Przyjmij;
               Sklad_Magazynu;
         or 
               accept Wydaj(Zestaw: in Typ_Zestawow; Numer: out Integer) do
                  if Mozna_Wydac(Zestaw) then
                     Put_Line("Wydano zestaw " & Nazwa_Zestawu(Zestaw) & " nr " &
                                Integer'Image(Numer_Zestawu(Zestaw)));
                     for W in Typ_Wyrobow loop
                        Magazyn(W) := Magazyn(W) - Sklad_Zestawu(Zestaw, W);
                        W_Magazynie := W_Magazynie - Sklad_Zestawu(Zestaw, W);
                     end loop;
                     Numer := Numer_Zestawu(Zestaw);
                     Numer_Zestawu(Zestaw) := Numer_Zestawu(Zestaw) + 1;
                  else
                     Put_Line("Brak części dla zestawu " & Nazwa_Zestawu(Zestaw));
                     Numer := 0;
                  end if;
               end Wydaj;
               Sklad_Magazynu;
         end select;
      end loop;
   end TBufor;
end Bufor;
