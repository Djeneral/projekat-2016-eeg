function [ col_id, row_id ] = Char2ColRow ( screen, char )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
        let_id = find(screen == char);
        col_id = mod(let_id, 6);
        row_id = (let_id - col_id)/6 + 1;
end

