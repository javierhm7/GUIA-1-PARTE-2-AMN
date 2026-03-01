clear; clc;
format long;

% Constante gravitacional
g = 9.81; % m/s²

fprintf('=========================================================================\n');
fprintf('    MÉTODO DE STEFFENSEN - VELOCIDAD VERTICAL DE COHETE\n');
fprintf('=========================================================================\n\n');

% -------------------------------------------------------------------------
% ENTRADA DE DATOS
% -------------------------------------------------------------------------
u_kmh = input('Velocidad de expulsión del combustible u (km/h): ');
m0 = input('Masa inicial del cohete m0 (kg): ');
q = input('Tasa de consumo de combustible q (kg/s): ');
v_objetivo = input('Velocidad objetivo v (m/s): ');
exponente = input('Precisión (ingrese el exponente, ej: 12 para 10^-12): ');

% Conversión de u de km/h a m/s
u = u_kmh / 3.6; 

% Precisión
precision = 10^(-exponente);

fprintf('\n--- INFORMACIÓN IMPORTANTE ---\n');
t_max = m0 / q;
fprintf('Tiempo máximo antes de agotar combustible: t_max = m0/q = %.2f s\n', t_max);

t0 = input('\nIngrese el valor inicial t0 (segundos): ');

% -------------------------------------------------------------------------
% DEFINICIÓN DE FUNCIONES
% -------------------------------------------------------------------------
% 1. Función original solo para verificación final f(t) = 0
f = @(t) u * log(m0 / (m0 - q*t)) - g*t - v_objetivo;

% 2. Función de Punto Fijo t = g(t) 
% Despejada analíticamente para evitar logaritmos negativos
% (Despeje manual para evitar error en el cálculo)
g_fun = @(t) (m0 / q) * (1 - exp(-(v_objetivo + g*t) / u));

% -------------------------------------------------------------------------
% MÉTODO DE STEFFENSEN (VERSIÓN PUNTO FIJO)
% -------------------------------------------------------------------------
fprintf('\n=========================================================================\n');
fprintf('                    ITERACIONES DEL MÉTODO DE STEFFENSEN\n');
fprintf('=========================================================================\n');
fprintf('Fórmula: t_{n+1} = t_n - (t1 - t_n)^2 / (t2 - 2*t1 + t_n)\n\n');

fprintf('%-6s | %-18s | %-18s | %-18s | %-15s\n', 'Iter', 't_n', 't1=g(t_n)', 't2=g(t1)', 'Error');
fprintf('%s\n', repmat('-', 1, 90));

t_n = t0;
max_iter = 100;
convergio = false;

for iter = 1:max_iter
    
    % Calcular pasos intermedios de la función g(t)
    t1 = g_fun(t_n);
    t2 = g_fun(t1);
    
    % Denominador del método
    denominador = t2 - 2*t1 + t_n;
    
    if abs(denominador) < eps
        fprintf('\nDenominador cero detectado (convergencia exacta alcanzada).\n');
        break;
    end
    
    % Fórmula de Steffensen
    t_nuevo = t_n - ((t1 - t_n)^2) / denominador;
    
    % Calcular error absoluto
    error_val = abs(t_nuevo - t_n);
    
    % Mostrar iteración con los 15 decimales solicitados
    fprintf('%-6d | %18.15f | %18.15f | %18.15f | %15.6e\n', iter, t_n, t1, t2, error_val);
    
    % Verificar convergencia
    if error_val < precision
        convergio = true;
        t_n = t_nuevo;
        break;
    end
    
    t_n = t_nuevo;
end

% -------------------------------------------------------------------------
% RESULTADOS FINALES
% -------------------------------------------------------------------------
fprintf('\n=========================================================================\n');
fprintf('                           RESULTADOS\n');
fprintf('=========================================================================\n');

if convergio
    fprintf(' El método CONVERGIÓ en %d iteraciones\n\n', iter);
    
    fprintf('SOLUCIÓN ENCONTRADA:\n');
    fprintf('   t = %.15f segundos\n\n', t_n);
    
    % Verificación
    v_calculada = u * log(m0 / (m0 - q*t_n)) - g*t_n;
    
    fprintf('VERIFICACIÓN:\n');
    fprintf('   Diferencia con ecuación original = %.15e m/s\n', abs(v_calculada - v_objetivo));
else
    fprintf(' El método NO CONVERGIÓ\n');
end
fprintf('=========================================================================\n');