% The following function is used to detect possible errors
% Inputs
% received is the received codeword and generator is the generated codeword

% Outputs of the function
% rec is the received codeword
% syndrome is the syndrome i.e remainder of after division
% err is a flag. if err = 1 error is detected else error is not detected or the codeword received is correct

function [rec, syndrome, err] = detect(received, generator)
    lenR = length(received);    % length of the received codeword
    lenGW = length(generator);  % length of the generator
    z = received;               % copy of received codeword
    i = 1;                      % i = iterator
    
    % This loop does xor division
    while i<=lenR - lenGW + 1
        if z(1,i) == 1
            z(1,i:i+lenGW-1) = bitxor(z(1,i:i+lenGW-1),generator);
        end
        i = i+1;
    end

    rec = received;             % a copy of received is sent as output rec
    
    % syndrome is now equal to the remainder of xor division
    syndrome = z(1, lenR - lenGW + 2: lenR);
    check = [ones(1, lenGW - 1)*0]; % a 1D row array with length = length of remainder all containing 0s
    
    % check if syndrome is 0
    % if 0 then no error or untraceable error else there is an error
    if isequal(syndrome, check)
        err = 0;
    else
        err = 1;
    end
end