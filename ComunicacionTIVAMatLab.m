%% Conexion UART TIVA-MATLAB

% Definir el baudaje y el puerto serial
baudrate = 115200;  % Baudaje usado en la Tiva C
port = 'COM3';    % Puerto serial donde está conectada la Tiva C

% Configurar el objeto serial
s = serialport(port, baudrate);

% Eliminar datos viejos que puedan haber llegado al puerto
flush(s);

fopen(s); % Abre el puerto serial

% Para enviar datos debemos enviar primero un comando y luego el dato
% 1 - Modo
% 2 - lambda1 
% 3 - lambda2
% 4 - Fs
% 4 -> 5 porque Fs necesita 16 bits

modo = 0;
lambda1 = 0.9;
lambda2 = 0.9;
Fs = 1000;

% Enviar comando para cambiar variables en la TIVA

%% ----- Modo TIVA SPI con DAC -------------------------------------------- 

fwrite(s, 1, "int8");           % Comando para cambiar modo
fwrite(s, 0, "int8");           % Modo SPI con DAC


%% ----- Modo On Demand ---------------------------------------------------

fwrite(s, 1, "int8");           % Comando para cambiar modo     
fwrite(s, 1, "int8");           % Modo envio constante de datos
    
% Leer datos del puerto serial y guardarlos en el vector

% Definir la duración de la adquisición (en segundos)
duracion = 5;

% Determinar el número de muestras correspondientes a 5 segundos
Fs = 1000; % Frecuencia de muestreo (ejemplo)
num_muestras = duracion * Fs;

% Inicializar vector para almacenar los datos
datos = zeros(num_muestras, 1);

for i = 1:num_muestras
    % Leer dato del puerto serial
    dato_serial = readline(s);
    
    % Convertir cadena a número
    dato_numerico = str2double(dato_serial);
    
    % Guardar valor numérico en el vector de datos
    datos(i) = dato_numerico;
end

% Cerrar puerto serial
clear s;


%% ------ Modo Tiempo Real ------------------------------------------------

fwrite(s, 1, "int8");           % Comando para cambiar modo
fwrite(s, 1, "int8");           % Modo envio constante de datos

%% Enviar lambda1

fwrite(s, 2, "int8");           % Comando para enviar lambda1
fwrite(s, int8(lambda1*255), "int8");       % Enviar 0-1 mapeado a 0-255

%% Enviar lambda2

fwrite(s, 3, "int8");           % Comando para enviar lambda2
fwrite(s, int8(lambda1*255), "int8");       % Enviar 0-1 mapeado a 0-255

%% Enviar Fs

fwrite(s, 4, "int8");           % Comando para enviar Fs
fwrite(s, bitand(Fs, int16(255)), "int8");  % Enviamos 8 bits menos significativos
fwrite(s, bitshift(Fs, -8), "int8");        % Enviamos 8 bits mas significativos




