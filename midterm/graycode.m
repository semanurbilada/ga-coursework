%% Gray Code
clc; clear;

n_bits = 4;

fprintf('Decimal  Binary  GrayCode\n');
fprintf('--------------------------\n');

for d = 0 : 2^n_bits - 1
    gray = bitxor(d, bitshift(d, -1));  % one line gray code
    fprintf('  %2d      %s      %s\n', d, dec2bin(d, n_bits), dec2bin(gray, n_bits));
end

%{

Binary:    1  0  1  1
           |  |  |  |
G1 = B1           ->  1 (MSB)
G2 = B1 XOR B2    ->  1 XOR 0 = 1
G3 = B2 XOR B3    ->  0 XOR 1 = 1
G4 = B3 XOR B4    ->  1 XOR 1 = 0

Gray Code: 1  1  1  0

%}