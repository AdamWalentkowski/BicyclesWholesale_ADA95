-- Szkielet programu do zadania z języków programowania
-- Studenci powinni przemianować zadania producentów, konsumentów i bufora
-- Powinni następnie zmienić je tak, by odpowiadały ich własnym zadaniom
-- Powinni także uzupełnić kod o brakujące konstrucje
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Numerics.Discrete_Random;

procedure main is
   Indeks_Wyrobu: constant Integer := 5;
   Indeks_Zestawu: constant Integer := 3;
   Indeks_Konsumenta: constant Integer := 2;
   subtype Zakres_Czasu_Produkcji is Integer range 3 .. 6;
   subtype Zakres_Czasu_Konsumpcji is Integer range 4 .. 8;
   --tablice musza miec okreslony zasieg
   subtype Rodzaj_Wyrobu is Integer range 1 .. Indeks_Wyrobu;
   subtype Rodzaj_Zestawu is Integer range 1 .. Indeks_Zestawu;
   subtype Rodzaj_Konsumenta is Integer range 1 .. Indeks_Konsumenta;
   --stringi trzeba dopelniac
   Nazwa_Wyrobu: constant array (Rodzaj_Wyrobu) of String(1 .. 8)
     := ("Kolo    ", "Siodelko", "Rama    ", "Pedal   ", "Hamulec ");
   Nazwa_Zestawu: constant array (Rodzaj_Zestawu) of String(1 .. 10)
     := ("Monocykl  ", "Gorski    ", "Trojkolowy");
   package Losowa_Konsumpcja is new
     Ada.Numerics.Discrete_Random(Zakres_Czasu_Konsumpcji); --co ile ktos kupi
   package Losowy_Zestaw is new
     Ada.Numerics.Discrete_Random(Rodzaj_Zestawu); --jaki zestaw sie zachce kupic
   type My_Str is new String(1 ..256);

   
   
   -- Producent produkuje określony wyrób
   task type Producent is
      -- Nadaj Producentowi tożsamość, czyli rodzaj wyrobu
      entry Zacznij(Wyrob: in Rodzaj_Wyrobu; Czas_Produkcji: in Integer);
   end Producent;

   
   
   -- Konsument pobiera z Bufora dowolny zestaw składający się z wyrobów
   task type Konsument is
      -- Nadaj Konsumentowi tożsamość
      entry Zacznij(Konsument: in Rodzaj_Konsumenta;
		    Czas_Konsumpcji: in Integer);
   end Konsument;

   
   
   -- W Buforze następuje składanie wyrobów w zestawy
   task type Bufor is
      -- Przyjmij wyrób do magazynu, o ile jest miejsce
      entry Przyjmij(Wyrob: in Rodzaj_Wyrobu; Numer: in Integer);
      -- Wydaj zestaw z magazynu, o ile są części (wyroby)
      entry Wydaj(Zestaw: in Rodzaj_Zestawu; Numer: out Integer);
   end Bufor;
   
-------------------------------BODIES---------------------------------

   LISTA_PRODUCENTOW: array ( 1 .. Indeks_Wyrobu ) of Producent;
   LISTA_KONSUMENTOW: array ( 1 .. Indeks_Konsumenta ) of Konsument;
   B: Bufor;
   
   

   task body Producent is
      package Losowa_Produkcja is new
	Ada.Numerics.Discrete_Random(Zakres_Czasu_Produkcji);
      LOSOWA_LICZBA: Losowa_Produkcja.Generator;  --generator liczb losowych
      Nr_Typu_Wyrobu: Integer;
      Numer_Wyrobu: Integer;
      Produkcja: Integer;
   begin
      accept Zacznij(Wyrob: in Rodzaj_Wyrobu; Czas_Produkcji: in Integer) do  --solo czesc randki
	 Losowa_Produkcja.Reset(LOSOWA_LICZBA);	 --zacznij generator liczb losowych
	 Numer_Wyrobu := 1;
	 Nr_Typu_Wyrobu := Wyrob;
	 Produkcja := Czas_Produkcji;
      end Zacznij;
      Put_Line("Zacze�to producenta wyrobu " & Nazwa_Wyrobu(Nr_Typu_Wyrobu));
      loop
	 delay Duration(Losowa_Produkcja.Random(LOSOWA_LICZBA));  --symuluj produkcje
	 Put_Line("Wyprodukowano wyrob " & Nazwa_Wyrobu(Nr_Typu_Wyrobu)
		    & " numer "  & Integer'Image(Numer_Wyrobu));
	 --Wstaw do magazynu
	 B.Przyjmij(Nr_Typu_Wyrobu, Numer_Wyrobu);
	 Numer_Wyrobu := Numer_Wyrobu + 1;
      end loop;
   end Producent;

   
   
   
   task body Konsument is
      LOSOWA_LICZBA_KONSUMPCJI: Losowa_Konsumpcja.Generator;	--generator liczb losowych (czas)
      LOSOWA_LICZBA_ZESTAWU: Losowy_Zestaw.Generator;	--tez (zestawy)
      Nr_Konsumenta: Rodzaj_Konsumenta;
      Numer_Zestawu: Integer;
      Konsumpcja: Integer;
      Rodzaj_Zestawu: Integer;
      Nazwa_Konsumenta: constant array (1 .. Indeks_Konsumenta)
	of String(1 .. 10) := ("Konsument1", "Konsument2");
   begin
      accept Zacznij(Konsument: in Rodzaj_Konsumenta;
		     Czas_Konsumpcji: in Integer) do
	 Losowa_Konsumpcja.Reset(LOSOWA_LICZBA_KONSUMPCJI);  --ustaw generator
	 Losowy_Zestaw.Reset(LOSOWA_LICZBA_ZESTAWU);  --tez
	 Nr_Konsumenta := Konsument;
	 Konsumpcja := Czas_Konsumpcji;
      end Zacznij;
      Put_Line("Zacze�to konsumenta " & Nazwa_Konsumenta(Nr_Konsumenta));
      loop
	 delay Duration(Losowa_Konsumpcja.Random(LOSOWA_LICZBA_KONSUMPCJI));  --symuluj konsumpcje
	 Rodzaj_Zestawu := Losowy_Zestaw.Random(LOSOWA_LICZBA_ZESTAWU);
	 -- pobierz zestaw do konsumpcji
	 B.Wydaj(Rodzaj_Zestawu, Numer_Zestawu);
	 Put_Line(Nazwa_Konsumenta(Nr_Konsumenta) & ": pobrano zestaw " &
		    Nazwa_Zestawu(Rodzaj_Zestawu) & " numer " &
		    Integer'Image(Numer_Zestawu));
      end loop;
   end Konsument;
   
   

   task body Bufor is
      Pojemnosc_Magazynu: constant Integer := 30;
      type Typ_Magazynu is array (Rodzaj_Wyrobu) of Integer;
      Magazyn: Typ_Magazynu := (0, 0, 0, 0, 0);
      Sklad_Zestawu: array(Rodzaj_Zestawu, Rodzaj_Wyrobu) of Integer
	:= ((1, 1, 0, 2, 0),
	    (2, 1, 1, 2, 2),
	    (3, 1, 1, 2, 1));
      Max_Sklad_Zestawu: array(Rodzaj_Wyrobu) of Integer;
      Numer_Zestawu: array(Rodzaj_Zestawu) of Integer := (1, 1, 1);
      W_Magazynie: Integer := 0;

      procedure Ustaw_Zmienne is
      begin
	 for W in Rodzaj_Wyrobu loop
	    Max_Sklad_Zestawu(W) := 0;
	    for Z in Rodzaj_Zestawu loop
	       if Sklad_Zestawu(Z, W) > Max_Sklad_Zestawu(W) then
		  Max_Sklad_Zestawu(W) := Sklad_Zestawu(Z, W);
	       end if;
	    end loop;
	 end loop;
      end Ustaw_Zmienne;

      function Mozna_Przyjac(Wyrob: Rodzaj_Wyrobu) return Boolean is
	 Wolne: Integer;		--  wolne miejsce w magazynie
	 -- ile brakuje wyrobów w magazynie do produkcji dowolnego zestawu
	 Brak: array(Rodzaj_Wyrobu) of Integer;
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
	 for W in Rodzaj_Wyrobu loop
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
	 for W in Rodzaj_Wyrobu loop
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

      function Mozna_Wydac(Zestaw: Rodzaj_Zestawu) return Boolean is
      begin
	 for W in Rodzaj_Wyrobu loop
	    if Magazyn(W) < Sklad_Zestawu(Zestaw, W) then
	       return False;
	    end if;
	 end loop;
	 return True;
      end Mozna_Wydac;

      procedure Sklad_Magazynu is
      begin
	 for W in Rodzaj_Wyrobu loop
	    Put_Line("Skl�ad magazynu: " & Integer'Image(Magazyn(W)) & " "
		       & Nazwa_Wyrobu(W));
	 end loop;
      end Sklad_Magazynu;

   begin
      Put_Line("Zacze�to Bufor");
      Ustaw_Zmienne;
      loop
	 accept Przyjmij(Wyrob: in Rodzaj_Wyrobu; Numer: in Integer) do
	   if Mozna_Przyjac(Wyrob) then
	      Put_Line("Przyjeto wyrob " & Nazwa_Wyrobu(Wyrob) & " nr " &
		Integer'Image(Numer));
	      Magazyn(Wyrob) := Magazyn(Wyrob) + 1;
               W_Magazynie := W_Magazynie + 1;
               -----------------------------------------
  	   else
	      Put_Line("Odrzucono wyrob " & Nazwa_Wyrobu(Wyrob) & " nr " &
		    Integer'Image(Numer));
	   end if;
	 end Przyjmij;
	 Sklad_Magazynu;
	 accept Wydaj(Zestaw: in Rodzaj_Zestawu; Numer: out Integer) do
	    if Mozna_Wydac(Zestaw) then
	       Put_Line("Wydano zestaw " & Nazwa_Zestawu(Zestaw) & " nr " &
			  Integer'Image(Numer_Zestawu(Zestaw)));
	       for W in Rodzaj_Wyrobu loop
		  Magazyn(W) := Magazyn(W) - Sklad_Zestawu(Zestaw, W);
		  W_Magazynie := W_Magazynie - Sklad_Zestawu(Zestaw, W);
	       end loop;
	       Numer := Numer_Zestawu(Zestaw);
               Numer_Zestawu(Zestaw) := Numer_Zestawu(Zestaw) + 1;
               -----------------------------------------
	    else
	       Put_Line("Brak czes�ci dla zestawu " & Nazwa_Zestawu(Zestaw));
	       Numer := 0;
	    end if;
	 end Wydaj;
	 Sklad_Magazynu;
      end loop;
   end Bufor;
   
begin
   for I in 1 .. Indeks_Wyrobu loop
      LISTA_PRODUCENTOW(I).Zacznij(I, 10);
   end loop;
   for J in 1 .. Indeks_Konsumenta loop
      LISTA_KONSUMENTOW(J).Zacznij(J,12);
   end loop;
end main;


