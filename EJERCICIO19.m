clc; clear; format long;

disp('-------------------- METODO DE LA SECANTE --------------------')

%% ===== Definición incial =====
syms t

%% ===== Datos del problema =====
V0 = 3925;
theta = 57.82*pi/180;
m = 159.09;
k = 9.5;
g = 9.8;

C  = m/k;
Vx = V0*cos(theta);
Vy = V0*sin(theta);

%% ===== Funciones del proyectil =====
fx  = C*Vx*(1 - exp(-t/C));
fy  = (C*Vy + g*C^2)*(1 - exp(-t/C)) - (g*C)*t;
dfy = diff(fy,t);

%% ===== Entradas =====
f = input('Ingresar la funcion f(x): ');   % se debe escribir fy o dfy dependiendo lo que se busque
x0 = input('Ingresar el primer valor inicial x0: ');
x1 = input('Ingresar el segundo valor inicial x1: ');
tol = input('Margen de error: ');

%% ===== Encabezado de la tabla =====
fprintf('\n n | %22s | %22s | %22s | %12s\n','X0','X1','X2','Error');
fprintf('--------------------------------------------------------------------------\n');

%% ===== Método de la secante =====
cont = 0;
error = tol + 1;

while error > tol
    cont = cont + 1;

    f0 = double(subs(f, t, x0));
    f1 = double(subs(f, t, x1));

    x2 = x1 - f1*(x1 - x0)/(f1 - f0);
    error = abs(x2 - x1);

    fprintf('%2d | %22.15f | %22.15f | %22.15f | %12.6e\n', ...
            cont, x0, x1, x2, error);

    x0 = x1;
    x1 = x2;
end

fprintf('\nEl valor aproximado de X es: %.15f\n', x2);

%% ===== Evaluaciones de salida =====
if isequal(f, fy)
    distanciaX = double(subs(fx, t, x2));
    fprintf('\nEl tiempo al llegar al suelo es de: %.15f s y su distancia horizontal es: %.15f\n', ...
            x2, distanciaX);
end

if isequal(f, dfy)
    alturaMaxima = double(subs(fy, t, x2));
    distanciaX = double(subs(fx, t, x2));
    fprintf('\nLa altura maxima es: %.15f y su distancia horizontal es: %.15f\n', ...
            alturaMaxima, distanciaX);
end