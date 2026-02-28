% --- Conversión a SI ---
inch = 0.0254;                % m
Ap   = 30 * inch^2;           % m^2
A    = 64.35 * inch^2;        % m^2
mL   = 1 * inch;              % m (izq/der)
mT   = 1.5 * inch;            % m (sup/inf)

% Función f(W) = 0
f = @(W) (W - 2*mL) .* (A./W - 2*mT) - Ap;

% Intervalo que encierra la raíz (en metros)
a = 0.12;
b = 0.14;

fa = f(a); fb = f(b);
if fa*fb > 0
  error('No hay cambio de signo en [a,b]. Cambia el intervalo.');
end

tol = 1e-8;
maxit = 1000;

tabla = [];
xr_prev = NaN;

fprintf('n\t a\t\t\t b\t\t\t xr\t\t\t f(xr)\t\t\t error\n');

for n = 1:maxit
  % Fórmula de Regula Falsi
  xr = b - fb*(b-a)/(fb-fa);
  fxr = f(xr);

  if n == 1
    err = abs(fxr);          % primera fila
  else
    err = abs(xr - xr_prev); % luego diferencia entre aproximaciones
  end

  tabla(n,:) = [n a b xr fxr err];

  fprintf('%d\t %.15f\t %.15f\t %.15f\t %.15e\t %.15e\n', ...
          n, a, b, xr, fxr, err);

  % Criterio de paro (precisión 1e-8)
  if err < tol
    break;
  end

  % Actualizar intervalo según signo
  if fa*fxr < 0
    b = xr; fb = fxr;
  else
    a = xr; fa = fxr;
  end

  xr_prev = xr;
end

W = xr;
H = A / W;

fprintf('\n--- RESULTADOS (SI) ---\n');
fprintf('Ancho W = %.15f m\n', W);
fprintf('Alto  H = %.15f m\n', H);

% Verificación del área de impresión
Ap_calc = (W - 2*mL) * (H - 2*mT);
fprintf('Area impresion calculada = %.15f m^2\n', Ap_calc);
fprintf('Area impresion objetivo  = %.15f m^2\n', Ap);

% (Opcional) también en pulgadas para comprobar
fprintf('\n(Comprobacion en pulgadas)\n');
fprintf('W = %.15f in\n', W/inch);
fprintf('H = %.15f in\n', H/inch);

% Mostrar tabla completa al final (por si la necesitas para el PDF)
% disp('Tabla completa: [n a b xr f(xr) error]');
% disp(tabla);
