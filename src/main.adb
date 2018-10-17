-- Szkielet programu do zadania z języków programowania
-- Studenci powinni przemianować zadania producentów, konsumentów i bufora
-- Powinni następnie zmienić je tak, by odpowiadały ich własnym zadaniom
-- Powinni także uzupełnić kod o brakujące konstrucje
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; 
with Ada.Numerics.Discrete_Random;
with Ada.Exceptions;
with Bufor;
with Producent;
with konsument;
use Bufor;
use Producent;
use konsument;


procedure main is
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
   
   P: array ( 1 .. Liczba_Wyrobow ) of TProducent;
   K: array ( 1 .. Liczba_Konsumentow ) of TKonsument;
   B: TBufor;
-------------------------------------------------------------------
begin
   for I in 1 .. Liczba_Wyrobow loop
      P(I).Zacznij(I, 10);
   end loop;
   for J in 1 .. Liczba_Konsumentow loop
      K(J).Zacznij(J,12);
   end loop;
end main;


