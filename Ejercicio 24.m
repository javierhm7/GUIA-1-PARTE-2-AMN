%% PROBLEMA DE ESCALERAS CRUZADAS - MÉTODO DE POSICIÓN FALSA
% Este programa resuelve el problema de dos escaleras que se cruzan
% en un pasillo entre dos edificios

clear all;
clc;
format long;

%% EXPLICACIÓN DEL MÉTODO Y LA ECUACIÓN
fprintf('========================================================================\n');
fprintf('PROBLEMA DE ESCALERAS CRUZADAS\n');
fprintf('========================================================================\n\n');
fprintf('EXPLICACIÓN DE LA ECUACIÓN:\n');
fprintf('---------------------------\n');
fprintf('Cuando dos escaleras de longitudes a y b se apoyan en edificios\n');
fprintf('opuestos y se cruzan a una altura c, podemos usar:\n\n');
fprintf('  - TEOREMA DE PITÁGORAS: Para encontrar las alturas donde las escaleras\n');
fprintf('    tocan las paredes en función del ancho x del pasillo\n');
fprintf('  - TRIÁNGULOS SEMEJANTES: Para relacionar las proporciones geométricas\n\n');
fprintf('La relación matemática que se obtiene es:\n\n');
fprintf('     1/c = 1/?(a² - x²) + 1/?(b² - x²)\n\n');
fprintf('Para resolver, definimos:\n');
fprintf('  f(x) = 1/?(a² - x²) + 1/?(b² - x²) - 1/c = 0\n\n');
fprintf('========================================================================\n\n');

%% ENTRADA DE DATOS
fprintf('ENTRADA DE DATOS:\n');
fprintf('-----------------\n');
a = input('Ingrese la longitud de la primera escalera (a) en pies: ');
b = input('Ingrese la longitud de la segunda escalera (b) en pies: ');
c = input('Ingrese la altura donde se cruzan (c) en pies: ');
n = input('Ingrese el número de decimales para la precisión (ej. 7 para 10^-7): ');
precision = 10^(-n);

fprintf('\n========================================================================\n\n');

%% DEFINICIÓN DE LA FUNCIÓN
fprintf('DEFINICIÓN DE LA FUNCIÓN:\n');
fprintf('------------------------------------\n');
% Se usa una función anónima vectorial en lugar de cálculo simbólico (más rápido y no colapsa)
f = @(x) 1./sqrt(a^2 - x.^2) + 1./sqrt(b^2 - x.^2) - 1/c;
fprintf('f(x) = 1/?(%.0f² - x²) + 1/?(%.0f² - x²) - 1/%.0f\n\n', a, b, c);

%% SUGERENCIA DE RANGO INICIAL
fprintf('========================================================================\n\n');
fprintf('SUGERENCIA DE RANGO INICIAL:\n');
fprintf('-----------------------------\n');
fprintf('Para que las escaleras puedan cruzarse, el ancho del pasillo (x)\n');
fprintf('debe ser positivo y menor que ambas longitudes de escalera.\n\n');
x_max = min(a, b);
fprintf('Restricción física: 0 < x < min(a, b) = min(%.0f, %.0f) = %.0f\n\n', a, b, x_max);

% Definir rango inicial seguro
x_left = 0.1; %(Esto es porque no puede medir 0 o menos)
x_right = x_max - 0.1; %(Esto es porque no puede medir más que la escalera mas corta)

fprintf('Rango sugerido para el método: [%.1f, %.1f]\n\n', x_left, x_right);

% Verificar que hay cambio de signo
f_left = f(x_left);
f_right = f(x_right);

fprintf('Verificación de cambio de signo:\n');
fprintf('  f(%.1f) = %.6f\n', x_left, f_left);
fprintf('  f(%.1f) = %.6f\n', x_right, f_right);

if f_left * f_right > 0
    fprintf('\n¡ADVERTENCIA! No hay cambio de signo en el rango sugerido.\n');
    fprintf('Ajustando el rango...\n\n');
    x_left = 0.1;
    for i = 1:20
        x_test = x_left + i * (x_max - x_left) / 20;
        if f(x_left) * f(x_test) < 0
            x_right = x_test;
            break;
        end
    end
    fprintf('Nuevo rango: [%.2f, %.2f]\n', x_left, x_right);
    fprintf('  f(%.2f) = %.6f\n', x_left, f(x_left));
    fprintf('  f(%.2f) = %.6f\n', x_right, f(x_right));
end

fprintf('\n========================================================================\n\n');

%% MÉTODO DE POSICIÓN FALSA (REGULA FALSI)
fprintf('ITERACIONES DEL MÉTODO DE POSICIÓN FALSA:\n');
fprintf('------------------------------------------\n\n');
% Ajustado para mostrar 15 decimales según el enunciado
fprintf('%4s %18s %18s %18s %15s %15s\n', 'Iter', 'x_left', 'x_right', 'x_new', 'f(x_new)', 'Error');
fprintf('------------------------------------------------------------------------------------------------\n');

iter = 0;
error = Inf;
x_new = x_left;

while error > precision && iter < 1000
    iter = iter + 1;
    
    f_left = f(x_left);
    f_right = f(x_right);
    
    x_new_prev = x_new;
    
    % Fórmula de posición falsa
    x_new = x_right - (f_right * (x_right - x_left)) / (f_right - f_left);
    f_new = f(x_new);
    
    % Calcular error
    if iter > 1
        error = abs(x_new - x_new_prev);
    end
    
    % Mostrar iteración con 15 decimales
    fprintf('%4d %18.15f %18.15f %18.15f %15.6e %15.6e\n', ...
        iter, x_left, x_right, x_new, f_new, error);
    
    % Actualizar intervalo
    if f_left * f_new < 0
        x_right = x_new;
    else
        x_left = x_new;
    end
    
    % Evitar división por cero
    if abs(f_new) < 1e-15
        break;
    end
end

fprintf('\n========================================================================\n\n');

%% RESULTADOS FINALES
fprintf('RESULTADOS FINALES:\n');
fprintf('-------------------\n');
fprintf('Número de iteraciones: %d\n', iter);
fprintf('Precisión alcanzada: %.2e\n', error);
fprintf('Precisión solicitada: %.2e\n\n', precision);
fprintf('ANCHO DEL PASILLO (x) = %.15f pies\n\n', x_new);

%% VERIFICACIÓN DE LA SOLUCIÓN
fprintf('========================================================================\n\n');
fprintf('VERIFICACIÓN DE LA SOLUCIÓN:\n');
fprintf('----------------------------\n');
fprintf('Sustituyendo x = %.15f en la ecuación original:\n\n', x_new);

% Calcular cada término
term1 = 1/sqrt(a^2 - x_new^2);
term2 = 1/sqrt(b^2 - x_new^2);
term3 = 1/c;
sum_left = term1 + term2;

fprintf('Lado izquierdo: 1/?(a² - x²) + 1/?(b² - x²)\n');
fprintf('              = 1/?(%.0f² - %.15f²) + 1/?(%.0f² - %.15f²)\n', a, x_new, b, x_new);
fprintf('              = %.15f + %.15f\n', term1, term2);
fprintf('              = %.15f\n\n', sum_left);

fprintf('Lado derecho:  1/c = 1/%.0f = %.15f\n\n', c, term3);

% --- AQUÍ ESTÁ EL CAMBIO A 15 DECIMALES FIJOS ---
fprintf('Diferencia: |Lado izquierdo - Lado derecho| = %.15f\n\n', abs(sum_left - term3));

if abs(sum_left - term3) < 1e-6
    fprintf(' La solución es CORRECTA\n');
else
    fprintf(' Advertencia: La diferencia es mayor que el umbral esperado\n');
end

fprintf('\n========================================================================\n');
fprintf('PROGRAMA FINALIZADO\n');
fprintf('========================================================================\n');