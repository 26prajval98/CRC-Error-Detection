%perDetect detects the all possible errors that a generator is able to
%detect from a codeword

%input is the generator and codeword

%output:

%errors is a 2d array containing in each row for the corresponding
%generator and columns representing k+1 bit error detected

%total_error is a 2d array containing in each row for the corresponding
%generator and columns representing total k+1 bit error


%pec is a 2d array containing in each row for the corresponding
%generator and columns representing probablity of k+1 bit error detection

function [errors, total_error, pec]  = perDetect(codeword, generator)
    %length of generator
    lenGW = length(generator);
    %length of codeword
    lenCW = length(codeword);
    %length of dataword
    lenDW = lenCW - lenGW + 1;
    
    %A row array containing numbers from 1 to lenCW
    z = 1:lenCW;
    errors = [];
    total_error = [];
    pec = [];
    for i = 2:lenCW
        detectedErrors = 0;
        Errors = 0;
        
        %Choose all possible combinations of selecting i numbers from
        %1 to lenCW
        
        A = nchoosek(z,i);
        
        %run this loop the total number of rows in A
        for j = 1:size(A,1)
            
            %make a temp variable equal to codeword
            x = codeword(1,:);
            
            %error flag is 0
            err = 0;
            
            %select all possible error locations
            for k = 1:i
                index = uint32(A(j,k));
                %make a error in CW by inverting the bits
                x(1,index) = ~x(1,index);
            end
            
            %check if the error can be detected
            [~,~,err] = detect(x,generator);
            
            %if error is detected increment detectedError bit by 1
            if err == 1
                detectedErrors = detectedErrors + 1;
            end
            
            %increment number of errors
            Errors = Errors + 1;
        end
        
        %only 1 in nChoosei will be correct
        prob = 1/(nchoosek(lenCW,i));
        pec = [pec prob];
        errors = [errors detectedErrors];
        total_error = [total_error Errors];
    end
end

