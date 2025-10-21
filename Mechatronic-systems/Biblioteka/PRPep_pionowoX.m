function PRPep_pionowoX(D, a2, d1min, d1max, th2min, th2max, d3min, d3max, n)
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%Autor:                  Patryk Pytko
%Ostatnia aktualizacja:  29.03.2010 r
%Kierunek:               Robotyka i Automatyka, IMIR, AGH
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%Funkcja rysuje wykres meshz, b��du pozycji od po�o�enia efektora dla 
%struktury CYLINDRYCZNEJ PRP w przekroju, pionow� plaszczyzn� X=D.
%
% Parametry zadane:
% D  - wsp�rz�dna X, pionowej p�aszczyzny przekroju, jed. [metry]
% a2 - d�ugo�� drugiego cz�onu, jed. [metry]
% d1min  - dolny zakres przesuwu pierwszego cz�onu, jed. [metry]
% d1max  - g�rny zakres przesuwu pierwszego cz�onu, jed. [metry]
% th2min - dolny zakres k�ta obrotu drugiego przegubu, jed. [/degree]
% th2max - g�rny zakres k�ta obrotu drugiego przegubu, jed. [/degree]
% d3min  - dolny zakres przesuwu trzeciego cz�onu, jed. [metry]
% d3max  - g�rny zakres przesuwu trzeciego cz�onu. jed. [metry]
%
% Domy�lne warto�ci parametr�w:
% D=2, a2=2, d1min=0, d1max=1, th2min=-55, th2max=55, d3min=0, 
% d3max=1, n=25
%
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%n - dok�adno�� z jak� wykre�lana b�dzie przestrze�
% ustawienie domy�lnej warto�ci parametr�w:
if nargin < 9 || isempty(n),        n         = 25;        end
if nargin < 8 || isempty(d3max),    d3max     = 1;         end
if nargin < 7 || isempty(d3min),    d3min     = 0;         end
if nargin < 6 || isempty(th2max),   th2max    = 55;        end
if nargin < 5 || isempty(th2min),   th2min    = -55;       end
if nargin < 4 || isempty(d1max),    d1max     = 1;         end
if nargin < 3 || isempty(d1min),    d1min     = 0;         end
if nargin < 2 || isempty(a2),       a2        = 2;         end
if nargin < 1 || isempty(D),        D         = 2;         end

%warunek sprawdzaj�cy dobrane parametry:
if (d3min < d3max && d1min < d1max && th2min < th2max)


D1=d1min : (d1max-d1min)/n : d1max; %zdefiniowanie d1
TH2=th2min*pi/180 : (th2max-th2min)*pi/180/n : th2max*pi/180; %zdefiniowanie /theta2
D3 =d3min : (d3max-d3min)/n : d3max;                      %zdefiniowanie d3

[d1,th2]  = meshgrid(D1,TH2);           %tablica /theta1 i /theta2
[t2, d3w] = meshgrid(TH2,D3);              %tablica do obliczenia warunku na zakres X1.

X1 = a2.*cos(t2) - d3w.*sin(t2);             %obliczanie warto�ci Z aby sprawdzi� zakresy min(X1) i max(X1)

if ( D <= max(X1(:)) && D >= min(X1(:)) ) %warunek sprawdzaj�cy czy p�aszczyzna X=D przecina przestrze� robocz�.

    % Z uk�adu r�wnan: p�aszczyzny X=D i X = a2.*cos(th2) - d3.*sin(th2), obliczam d3.
     d3=(-D+a2.*cos(th2))./sin(th2); 
     
[p,q]=size(d3);     %sprawdzenie wymiaru macierzy d3 i przypisanie warto�ci do p i q.
v=0; %parametr do tworzenia tablic X(v,:,:) ...
%% P�tla da warunku sprawdzaj�cego czy obliczone wcze�niej d3 nale�y do
% dziedziny czyli przedzia�u < d3min, d3max >
for i=1:p
    for j=1:q
if ( d3(i,j) < d3max) && ( d3(i,j) > d3min)
    v=v+1;

    %Symetryczno�� manipulatora wzgl�dem osi X pozwala na rozbicie
    %przekroju na dwa p�aty, dodatni i ujemny. Mo�na oczywi�cie zilustrowa�
    %tylko jeden p�at.
    
    Z(v,:,:) = d1;
    [m,n]=size(d1);   % wymiary macierzy d1, aby zapisa� macierzowo X,Y
  %  Wsp�rz�dna X struktury PRP
    %X(v,:,:) = (a2.*cos(th2(i,j)) - d3(i,j).*sin(th2(i,j))).*ones(m,n);
  %  %wsp�rz�dna X zapisana tablicowo, 
  %  Wsp�rz�dna Y struktury PRP
  %  Je�li przestrze� robocza b�dzie mia�a dwa osobne przekroje to mesh
  %  jest po��czy w jedne i wynik nie b�dzie mia� sensu, mog� narysowa� dwa
  %  osobne oddzielaj�c warto�ci dodatnie od ujemnych ale to w p�tli jest
  %  czasoch�onne. Najlepiej rozpatrywa� tylko warto�ci dodatnie przyjmuj�c
  %  Y1(v,:,:) jako warto�� bezwzgl�dn� z Y(v,:,:).
        Y(v,:,:) = (a2.*sin(th2(i,j)) + d3(i,j).*cos(th2(i,j))).*ones(m,n);
        Y1(v,:,:) = abs((a2.*sin(th2(i,j)) + d3(i,j).*cos(th2(i,j)))).*ones(m,n);

  %wsp�rz�dna Y zapisana tablicowo liczona z przerobionego wzoru wynikowego
  %funkcji bladPRP().
    X(v,:,:) = (((1/10000*sin(1/1800*pi) + (sin(1/1800*pi)^2 - cos(1/1800*pi)^2*sin(1/1800*pi))*(1/10000*sin(899/1800*pi) + 1/10000) + (cos(1/1800*pi + th2(i,j))*(a2 + 1/10000) + 1/10000*cos(899/1800*pi)*sin(1/1800*pi + th2(i,j)))*(cos(1/1800*pi)*sin(1/1800*pi) + cos(1/1800*pi)*sin(1/1800*pi)^2) + (d3(i,j) + 1/10000*sin(1/1800*pi) + 1/10000)*(cos(1/1800*pi)^2*(sin(1/1800*pi)*sin(1/1800*pi + th2(i,j)) - cos(1/1800*pi)*sin(899/1800*pi)*cos(1/1800*pi + th2(i,j))) + (sin(1/1800*pi)*cos(1/1800*pi + th2(i,j)) + cos(1/1800*pi)*sin(899/1800*pi)*sin(1/1800*pi + th2(i,j)))*(cos(1/1800*pi)*sin(1/1800*pi) + cos(1/1800*pi)*sin(1/1800*pi)^2) - cos(1/1800*pi)*cos(899/1800*pi)*(sin(1/1800*pi)^2 - cos(1/1800*pi)^2*sin(1/1800*pi))) + (1/10000*cos(1/1800*pi) - 1/10000*cos(1/1800*pi)*sin(1/1800*pi))*(cos(1/1800*pi)^2*(cos(1/1800*pi)*sin(1/1800*pi + th2(i,j)) + sin(1/1800*pi)*sin(899/1800*pi)*cos(1/1800*pi + th2(i,j))) + (cos(1/1800*pi)*cos(1/1800*pi + th2(i,j)) - sin(1/1800*pi)*sin(899/1800*pi)*sin(1/1800*pi + th2(i,j)))*(cos(1/1800*pi)*sin(1/1800*pi) + cos(1/1800*pi)*sin(1/1800*pi)^2) + cos(899/1800*pi)*sin(1/1800*pi)*(sin(1/1800*pi)^2 - cos(1/1800*pi)^2*sin(1/1800*pi))) + 1/10000*cos(1/1800*pi)^2 + d3(i,j)*cos(th2(i,j)) + cos(1/1800*pi)^2*(sin(1/1800*pi + th2(i,j))*(a2 + 1/10000) - 1/10000*cos(899/1800*pi)*cos(1/1800*pi + th2(i,j))) - a2*sin(th2(i,j)) + (1/10000*sin(1/1800*pi) + 1/10000*cos(1/1800*pi)^2)*(sin(899/1800*pi)*(sin(1/1800*pi)^2 - cos(1/1800*pi)^2*sin(1/1800*pi)) + cos(899/1800*pi)*sin(1/1800*pi + th2(i,j))*(cos(1/1800*pi)*sin(1/1800*pi) + cos(1/1800*pi)*sin(1/1800*pi)^2) - cos(1/1800*pi)^2*cos(899/1800*pi)*cos(1/1800*pi + th2(i,j))))^2 + (1/10000*cos(1/1800*pi) + (1/10000*sin(899/1800*pi) + 1/10000)*(cos(1/1800*pi)*sin(1/1800*pi) + cos(1/1800*pi)*sin(1/1800*pi)^2) + (1/10000*sin(1/1800*pi) + 1/10000*cos(1/1800*pi)^2)*(sin(899/1800*pi)*(cos(1/1800*pi)*sin(1/1800*pi) + cos(1/1800*pi)*sin(1/1800*pi)^2) + cos(899/1800*pi)*sin(1/1800*pi + th2(i,j))*(cos(1/1800*pi)^2 - sin(1/1800*pi)^3) + cos(1/1800*pi)*cos(899/1800*pi)*sin(1/1800*pi)*cos(1/1800*pi + th2(i,j))) - 1/10000*cos(1/1800*pi)*sin(1/1800*pi) - a2*cos(th2(i,j)) - d3(i,j)*sin(th2(i,j)) - (cos(1/1800*pi)*cos(899/1800*pi)*(cos(1/1800*pi)*sin(1/1800*pi) + cos(1/1800*pi)*sin(1/1800*pi)^2) - (sin(1/1800*pi)*cos(1/1800*pi + th2(i,j)) + cos(1/1800*pi)*sin(899/1800*pi)*sin(1/1800*pi + th2(i,j)))*(cos(1/1800*pi)^2 - sin(1/1800*pi)^3) + cos(1/1800*pi)*sin(1/1800*pi)*(sin(1/1800*pi)*sin(1/1800*pi + th2(i,j)) - cos(1/1800*pi)*sin(899/1800*pi)*cos(1/1800*pi + th2(i,j))))*(d3(i,j) + 1/10000*sin(1/1800*pi) + 1/10000) + (cos(1/1800*pi)^2 - sin(1/1800*pi)^3)*(cos(1/1800*pi + th2(i,j))*(a2 + 1/10000) + 1/10000*cos(899/1800*pi)*sin(1/1800*pi + th2(i,j))) + (1/10000*cos(1/1800*pi) - 1/10000*cos(1/1800*pi)*sin(1/1800*pi))*((cos(1/1800*pi)*cos(1/1800*pi + th2(i,j)) - sin(1/1800*pi)*sin(899/1800*pi)*sin(1/1800*pi + th2(i,j)))*(cos(1/1800*pi)^2 - sin(1/1800*pi)^3) + cos(899/1800*pi)*sin(1/1800*pi)*(cos(1/1800*pi)*sin(1/1800*pi) + cos(1/1800*pi)*sin(1/1800*pi)^2) - cos(1/1800*pi)*sin(1/1800*pi)*(cos(1/1800*pi)*sin(1/1800*pi + th2(i,j)) + sin(1/1800*pi)*sin(899/1800*pi)*cos(1/1800*pi + th2(i,j)))) - cos(1/1800*pi)*sin(1/1800*pi)*(sin(1/1800*pi + th2(i,j))*(a2 + 1/10000) - 1/10000*cos(899/1800*pi)*cos(1/1800*pi + th2(i,j))))^2 + (1/10000*sin(1/1800*pi) + sin(1/1800*pi)*(sin(1/1800*pi + th2(i,j))*(a2 + 1/10000) - 1/10000*cos(899/1800*pi)*cos(1/1800*pi + th2(i,j))) - (1/10000*sin(1/1800*pi) + 1/10000*cos(1/1800*pi)^2)*(cos(899/1800*pi)*sin(1/1800*pi)*cos(1/1800*pi + th2(i,j)) - cos(1/1800*pi)^2*sin(899/1800*pi) + cos(1/1800*pi)*cos(899/1800*pi)*sin(1/1800*pi)*sin(1/1800*pi + th2(i,j))) - (cos(1/1800*pi)^3*cos(899/1800*pi) - sin(1/1800*pi)*(sin(1/1800*pi)*sin(1/1800*pi + th2(i,j)) - cos(1/1800*pi)*sin(899/1800*pi)*cos(1/1800*pi + th2(i,j))) + cos(1/1800*pi)*sin(1/1800*pi)*(sin(1/1800*pi)*cos(1/1800*pi + th2(i,j)) + cos(1/1800*pi)*sin(899/1800*pi)*sin(1/1800*pi + th2(i,j))))*(d3(i,j) + 1/10000*sin(1/1800*pi) + 1/10000) + cos(1/1800*pi)^2*(1/10000*sin(899/1800*pi) + 1/10000) + (1/10000*cos(1/1800*pi) - 1/10000*cos(1/1800*pi)*sin(1/1800*pi))*(sin(1/1800*pi)*(cos(1/1800*pi)*sin(1/1800*pi + th2(i,j)) + sin(1/1800*pi)*sin(899/1800*pi)*cos(1/1800*pi + th2(i,j))) + cos(1/1800*pi)^2*cos(899/1800*pi)*sin(1/1800*pi) - cos(1/1800*pi)*sin(1/1800*pi)*(cos(1/1800*pi)*cos(1/1800*pi + th2(i,j)) - sin(1/1800*pi)*sin(899/1800*pi)*sin(1/1800*pi + th2(i,j)))) - cos(1/1800*pi)*sin(1/1800*pi)*(cos(1/1800*pi + th2(i,j))*(a2 + 1/10000) + 1/10000*cos(899/1800*pi)*sin(1/1800*pi + th2(i,j))) + 1/10000)^2)^(1/2)).*ones(m,n);

end
    
    end 
end
%figure(1)
%plot3k({Z(:),Y1(:),X(:)});

X1=reshape(X,v,size(Y,2)*size(X,3));  %zmiana wymiaru tablicy X ( x3) na x2, aby m�g� j� obs�u�y� mesh
Y1=reshape(Y1,v,size(Y,2)*size(Y1,3));  % -- || --
Z1=reshape(Z,v,size(Y,2)*size(Z,3));  % -- || -- 

%% Wykre�lanie bry�y metod� mesh.
%figure(2)
h=meshz(Y1,Z1,X1);
colormap cool;
%whitebg('w');
light('Style','infinite');
lighting gouraud;
rotate3d;
shading interp;
grid on;
set(gca,'FontName','Arial','FontSize',10,'FontWeight','bold');
xlabel('po�o�enie Y [m]')
ylabel('po�o�enie Z [m]')
zlabel('B��d pozycji e_{p} [m]')

title('Wizualizacja b��du pozycji e_{p} struktury PRP, w przekroju p�aszczyzn� pionow� X=D')
%view([-133,33,90])
set(h,'SpecularColorReflectance',1,'AmbientStrength',0.5,'EdgeColor',...
'none','facecolor', 'interp','LineStyle','none','FaceLighting','gouraud');
hold on


%% B��dy dla wprowadzonych z�ych parametr�w.
else
    error('P�aszczyzna X nie przecina si� z przestrzeni� robocz�, "D" musi by� z przedzia�u <%d,%d> \n',min(X1(:)),max(X1(:)))

end
         else
   error('Warto�ci d3min i d3max, th2min, th2max oraz th1min, th1max s� �le dobrane: \n Musz� by� spe�nione warunki: d3min<d3max, th2min<th2max, th1min<th1max \n Twoje warto�ci: d3min=%d, d3max=%d, th2min=%d, th2max=%d, th1min=%d, th1max=%d \n',d3min,d3max,th2min,th2max, th1min, th1max)

end