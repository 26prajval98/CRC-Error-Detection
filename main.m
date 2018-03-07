dataT = [];
prob = [];

% CRCN divisors
% Each CRCN matrix has k divsiors Of N bit
CRC2 = [1 0 0; 1 0 1];
CRC3 = [1 0 0 0; 1 0 1 1];
CRC4 = [1 0 0 0 0; 1 0 0 1 1];
CRC5 = [1 0 0 0 0 0; 1 0 1 0 0 1; 1 1 0 1 0 1; 1 0 0 1 0 1];
CRC6 = [1 0 0 0 0 0 0; 1 0 0 1 1 1 1; 1 0 1 1 1 1 1; 1 0 0 0 0 1 1; 1 0 0 1 0 1 0];
CRC7 = [1 0 0 0 0 0 0 0; 1 0 0 0 1 0 0 1; 1 0 1 0 1 0 0 1; 1 0 0 0 1 0 1 1];

% Inputting N for CRCN to which dataword has to be converted
x = input('Which CRC to be used\nEnter from 2 to 7\n');
% Inputting dataword
dataword = input('Vector dataword\n');      %[1 0 0 0 1 1 0 1 1]

% Test will have the CRCN corresponding to inputted N
Test = [];

% Selecting Required CRC
switch(x)
    case 2 
        Test = CRC2;
    case 3 
        Test = CRC3;
    case 4 
        Test = CRC4;
    case 5 
        Test = CRC5;
    case 6 
        Test = CRC6;
    case 7 
        Test = CRC7;
end

for i = 1:size(Test,1)
    % select generator from ith row of matrix Test
    generator = Test(i,:);
    
    % generate each codeword from dataword wrt to the selected generator
    x = generate(dataword, generator);
    
    % detect all possible errors from 2 to length of codeword
    % err is an array containing number of errors detected from 2 bit to length of codeword
    % total is an array containing number of errors from 2 bit to length of codeword
    % pro is an array containing probablity of correcting errors from 2 bit
    % to length of codeword
    [err,total,pro] = perDetect(x,generator);
    
    % Add the acquired probablity of the given genrator to the next column 
    prob = [prob; pro];
    
    % each element in err / corresponding element in total gives % error
    % detection
    % Add the acquired error detect of the given genrator to the next column
    dataT = [dataT; (err./total)*100];
end

% preparing the data to pass to the bar graph making function and the bar
% graph takes in only one input which is a single row array
% nth bit error 
data2 = transpose(dataT);
probT = transpose(prob);

% As the probablity of correcting a error is probablity of detecting that
% error * percentage error correction of that error
probT = probT.*data2;

for i = 1:size(data2,1)
    % generating a bar graph for each generator with i bit error
    figure;
    data = data2(i,:);
    labels = probT(i,:);
    bar(data);
    
    % displaying percentage error detection and correction
    text(1:length(data),data,strcat(num2str(data'),' and ',num2str(labels')),'vert','bottom','horiz','center');   
    box off;
    c = cell(1:size(Test,1));
    for k = 1:size(Test,1)
       c{k} = num2str(Test(k,:)); 
    end
    set(gca,'XTickLabel',c);
    
    % setting labels
    ylabel('Perentage');
    xlabel(strcat('No Of bit errors :', num2str(i+1)));
end