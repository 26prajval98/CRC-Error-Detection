% This function generates the codeword 

% input dataword and generator
% output y is the codeword

function y = generate(dataword, generator)
    lenDW = length(dataword);   % length of dataword
    
    % x checks if the 1-lenDW bits of z is 0 to stop division
    x = [ones(1,lenDW)*0];
    
    lenGW = length(generator);  % length of generator
    
    % z will be the dividend with length of remainder number of 0s concatenated
    z = [dataword ones(1,lenGW-1)*0];
    
    i = 1;

    while ~isequal(z(1:lenDW),x)
        
        % checks if number MSB is 1, if 1 bitwise XOR is done
     
        % basically the algorithm to generate
        if z(1,i) == 1
            z(1,i:i+lenGW-1) =  bitxor(z(1,i:i+lenGW-1),generator);
        end
        i = i+1;
    end
    
    % append remainder to dataword making the codeword
    y = [dataword z(1, lenDW+1:lenGW+lenDW-1)];        
end