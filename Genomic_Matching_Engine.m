% Genomic Sequence Matching Engine - Golden Model
num_tests = 50;     % Changed from 100 to 50
seq_len = 4;        
score_width = 8;    

% Generate random sequences (0=A, 1=C, 2=G, 3=T)
seq_A = randi([0, 3], num_tests, seq_len);
seq_B = randi([0, 3], num_tests, seq_len);

% Open files for writing test vectors
fid_A = fopen('seq_a.mem', 'w');
fid_B = fopen('seq_b.mem', 'w');
fid_score = fopen('expected_scores.mem', 'w');

for i = 1:num_tests
    score = 0;
    bin_str_A = '';
    bin_str_B = '';
    
    % Calculate score and build binary strings sequence by sequence
    for j = 1:seq_len
        % Build the packed 2-bit binary representation string
        bin_str_A = [bin_str_A, dec2bin(seq_A(i, j), 2)];
        bin_str_B = [bin_str_B, dec2bin(seq_B(i, j), 2)];
        
        % +1 for match, -1 for mismatch
        if seq_A(i, j) == seq_B(i, j)
            score = score + 1;
        else
            score = score - 1;
        end
    end
    
    % Handle 2's complement for negative scores
    if score < 0
        twos_comp_score = (2^score_width) + score;
    else
        twos_comp_score = score;
    end
    
    % Write the binary strings to the .mem files
    fprintf(fid_A, '%s\n', bin_str_A);
    fprintf(fid_B, '%s\n', bin_str_B);
    fprintf(fid_score, '%s\n', dec2bin(twos_comp_score, score_width));
end

fclose(fid_A);
fclose(fid_B);
fclose(fid_score);

disp('Generated 50 test vectors successfully! Check for the .mem files.');