% The following function is used to detect errors possible errors

%received is the received codeword and generator is the generated codeword

%Outputs of the function
%rec is the received codeword
%syndrome is the syndrome i.e remainder of after division
%err is a flag if err = 1 error is detected else error is not detected

function [rec, syndrome, err] = detect(received, generator)
    lenR = length(received);
    lenGW = length(generator);
    z = received;
    i = 1;
    
    %This loop does xor division
    while i<=lenR - lenGW + 1
        if z(1,i) == 1
            z(1,i:i+lenGW-1) =  bitxor(z(1,i:i+lenGW-1),generator);
        end
        i = i+1;
    end      
    rec = received;
    
    %syndrome is now equal to the remainder
    syndrome = z(1, lenR - lenGW + 2: lenR);
    check = [ones(1, lenGW - 1)*0];
    
    %check if syndrome is 0
    %if 0 then no error
    if isequal(syndrome, check)
        err = 0;
    else
        err = 1;
    end
end

                