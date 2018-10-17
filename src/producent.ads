with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; 
with Ada.Numerics.Discrete_Random;
with Bufor;
use Bufor;
package Producent is
   Liczba_Wyrobow: constant Integer := 5;
   Liczba_Zestawow: constant Integer := 3;
   Liczba_Konsumentow: constant Integer := 2;
   subtype Zakres_Czasu_Produkcji is Integer range 3 .. 6;
   subtype Zakres_Czasu_Konsumpcji is Integer range 4 .. 8;
   subtype Typ_Wyrobow is Integer range 1 .. Liczba_Wyrobow;
   subtype Typ_Zestawow is Integer range 1 .. Liczba_Zestawow;
   subtype Typ_Konsumenta is Integer range 1 .. Liczba_Konsumentow;
   Nazwa_Wyrobu: constant array (Typ_Wyrobow) of String(1 .. 9)
     := ("Kolo     ", "Rama     ", "Siodelko ", "Hamulec  ", "Pedal    ");
   Nazwa_Zestawu: constant array (Typ_Zestawow) of String(1 .. 11)
     := ("Monocykl   ", "Gorski     ", "Trojkolowy ");
   package Losowa_Konsumpcja is new
     Ada.Numerics.Discrete_Random(Zakres_Czasu_Konsumpcji);
   package Losowy_Zestaw is new
     Ada.Numerics.Discrete_Random(Typ_Zestawow);
   type My_Str is new String(1 ..256);
   B: TBufor;
   task type TProducent is
      -- Nadaj Producentowi tożsamość, czyli rodzaj wyrobu
      entry Zacznij(Wyrob: in Typ_Wyrobow; Czas_Produkcji: in Integer);
   end TProducent;
end Producent;
