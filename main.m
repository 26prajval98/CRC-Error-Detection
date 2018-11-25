% dataT is a 2D matrix where the number of rows will be equal to the number of 
% generators corresponding to the given CRCN
% kth column in a row will depict the percentage of error detection corresponding to that generator
dataT = [];

% prob is a 2D matrix where the number of rows will be equal to the number of 
% generators corresponding to the given CRCN
% kth column in a row will depict the probability of error correction corresponding to that generator
prob = [];

% CRCN generators
% Each CRCN matrix has k generators of N bit
CRC1 = [1 1];
CRC2 = [1 0 0; 1 0 1];
CRC3 = [1 0 0 0; 1 0 1 1];
CRC4 = [1 0 0 0 0; 1 0 0 1 1];
CRC5 = [1 0 0 0 0 0; 1 0 1 0 0 1; 1 1 0 1 0 1; 1 0 0 1 0 1];
CRC6 = [1 0 0 0 0 0 0; 1 0 0 1 1 1 1; 1 0 1 1 1 1 1; 1 0 0 0 0 1 1; 1 0 0 1 0 1 0];
CRC7 = [1 0 0 0 0 0 0 0; 1 0 0 0 1 0 0 1; 1 0 1 0 1 0 0 1; 1 0 0 0 1 0 1 1];

% Inputting N for CRCN to which dataword has to be converted
x = input('Which CRC to be used\nEnter from 1 to 7 (if i is the input divisors will have i+1 bits)\n');
% Inputting dataword
dataword = input('Vector dataword\n');      %[1 0 0 0 1 1 0 1 1]

% Test will have the CRCN corresponding to inputted N
Test = [];

% Selecting Required CRC
switch(x)
    case 1
        Test = CRC1;
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
    % total is an array containing total number of errors from 2 bit to length of codeword
    % pro is an array containing probablity of correcting errors from 2 bit
    % to length of codeword
    [err,total,pro] = perDetect(x,generator);
    
    % Add the acquired probablity of the given genrator to the next row 
    prob = [prob; pro];
    
    % each element in err / corresponding element in total gives % error
    % detection
    % Add the acquired error detect of the given genrator to the next row
    dataT = [dataT; (err./total)*100];
end

% preparing the data to pass to the bar graph making function and the bar
% graph takes in only one input which is a single row array
% we want to compare all the percentage of k-bit error from all the generators in CRCN
% as the bar graph making function takes a single row array data, we need to transpose the 
% dataT and prob 
data2 = transpose(dataT);
probT = transpose(prob);

% As the percentage of correcting an error is probablity of correcting that
% error * percentage error detection of that error
probT = probT.*data2;

% for generating i figures corresponding to 2 to length of codeword bit error, 
% error detection of all the generators corresponding to CRCN 
for i = 1:size(data2,1)
    % generating a bar graph for each generator with i+1 bit error
    figure;                     % this generates a figure in a new window
    data = data2(i,:);          % selecting percentage error detection of ith row corresponding to i+1 bit error
    labels = probT(i,:);        % selecting percentage error correction of ith row corresponding to i+1 bit error
    bar(data);                  % this generates the bar graph according to data which is a single row array
    
    % displaying percentage error detection and correction
    text(1:length(data),data,strcat(num2str(data'),' and ',num2str(labels')),'vert','bottom','horiz','center');   
    box off;
    c = cell(1:size(Test,1));   % set function takes a cell
    for k = 1:size(Test,1)
       c{k} = num2str(Test(k,:)); % converting a single row matrix to string which depicts the generator
    end
    set(gca,'XTickLabel',c);    % putting the generators name in the x-axis of the bar graph
    
    % setting labels
    ylabel('Perentage');
    xlabel(strcat('No Of bit errors :', num2str(i+1)));
end
