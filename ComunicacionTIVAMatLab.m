%% Conexion UART TIVA-MATLAB

% Definir el baudaje y el puerto serial
baudrate = 115200;  % Baudaje usado en la Tiva C
port = 'COM3';    % Puerto serial donde está conectada la Tiva C

% Configurar el objeto serial
s = serialport(port, baudrate);

% Eliminar datos viejos que puedan haber llegado al puerto
flush(s);

% fopen(s); % Abre el puerto serial

% Para enviar datos debemos enviar primero un comando y luego el dato
% 1 - Modo
% 2 - lambda1 
% 3 - lambda2
% 4 - Fs
% 4 -> 5 porque Fs necesita 16 bits

% Enviar comando para cambiar variables en la TIVA

%% Cerrar puerto serial
clear s
%% Obtencion de coeficientes

mode = 1;
Fs = 1000;

b = zeros(1,5);
a = zeros(1,5);

% Creacion de filtro pasa bajas y pasa altas
Fc = 100;
Fc2 = 400;
order = 1;      % Orden de 1 a 4
order2 = 2;     % Orden de 1 a 2

% Filtro pasa bajas
% [b,a] = butter(order, Fc/(Fs/2), 'low')

% Filtro pasa altas
% [b,a] = butter(order, Fc/(Fs/2), 'high');

% b = padarray(b, [0,4-order], 'post');
% a = padarray(a, [0, 4-order], 'post');

% Filtro pasa bandas
[b,a] = butter(order2, [Fc/(Fs/2) Fc2/(Fs/2)], 'stop');

% Filtro corta bandas
% [b,a] = butter(order2, [Fc/(Fs/2) Fc2/(Fs/2)], 'stop');

b = padarray(b, [0, 4-2*order2], 'post');
a = padarray(a, [0, 4-2*order2], 'post');

% Trasladar los coeficientes para enviar a la TIVA

% freqz(b,a,[],Fs);

coef(1:5) = b;
coef(6:9) = a(2:5);

%% Envio de TODOS los datos

delay = 0.1;
% Orden de los datos
% 0 - Modo
% 1 - Fs
% 2-10 - Coeficientes

% Modo
dato = sprintf('%0.1f', mode);
write(s, dato, 'char');
pause(delay);

% Fs
dato = sprintf('%0.1f', Fs);
write(s, dato, 'char');
pause(delay);

% % Tipo de filtro
% dato = sprintf('%0.1f', filterType);
% write(s, dato, 'char');
% pause(delay);

% Coeficiente 1
dato = sprintf('%0.5f', coef(1));
write(s, dato, 'char');
pause(delay);

% Coeficiente 2
dato = sprintf('%0.5f', coef(2));
write(s, dato, 'char');
pause(delay);

% Coeficiente 3
dato = sprintf('%0.5f', coef(3));
write(s, dato, 'char');
pause(delay);

% Coeficiente 4
dato = sprintf('%0.5f', coef(4));
write(s, dato, 'char');
pause(delay);

% Coeficiente 5
dato = sprintf('%0.5f', coef(5));
write(s, dato, 'char');
pause(delay);

% Coeficiente 6
dato = sprintf('%0.5f', coef(6));
write(s, dato, 'char');
pause(delay);

% Coeficiente 7
dato = sprintf('%0.5f', coef(7));
write(s, dato, 'char');
pause(delay);

% Coeficiente 8
dato = sprintf('%0.5f', coef(8));
write(s, dato, 'char');
pause(delay);

% Coeficiente 9
dato = sprintf('%0.5f', coef(9));
write(s, dato, 'char');
pause(delay);

%% ----- Modo On Demand ---------------------------------------------------
    
% Leer datos del puerto serial y guardarlos en el vector

% Definir la duración de la adquisición (en segundos)
duration = 5;
num_muestras = duration * Fs;

% Inicializar vector para almacenar los datos
data = zeros(num_muestras, 1);

for i = 1:num_muestras
    % Leer dato del puerto serial
    UART_data = readline(s);
    
    % Convertir cadena a número
    temp_data = str2double(UART_data);
    
    % Guardar valor numérico en el vector de datos
    data(i) = temp_data;
end

% Cerrar puerto serial
% clear s;


