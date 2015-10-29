%% Squeezzzzzzzzzzzzzzzzzzzzzze !
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Squeeze the cell by the dimension of its %
% element array. By default, if there are  %
% 2 identical dimension, concatenate the   %
% array vertically.                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function C_squeeze = CellSqueeze(C)
    flag_hori = true;
    flag_vert = true;
    hori_dim = size(C{1},1);
    vert_dim = size(C{1},2);
    for i = 2:length(C)
        if hori_dim ~= size(C{i},1)
            flag_hori = false;
            break;
        end
    end
    for i = 2:length(C)
        if vert_dim ~= size(C{i},2)
            flag_vert = false;
            break;
        end
    end
    
    if flag_vert
        total_len = 0;
        for i = 1:length(C)
            total_len = total_len + size(C{i},1);
        end
        C_squeeze = zeros(total_len,vert_dim);
        begin = 1;
        total_len = 0;
        for i = 1:length(C)
            total_len = total_len + size(C{i},1);
            if total_len > begin
                C_squeeze(begin:total_len,:) = C{i};
            else
                C_squeeze(begin,:) = C{i};
            end
            begin = total_len + 1;
        end
    elseif flag_hori
        total_len = 0;
        for i = 1:length(C)
            total_len = total_len + size(C{i},2);
        end
        C_squeeze = zeros(hori_dim,total_len);
        begin = 1;
        total_len = 0;
        for i = 1:length(C)
            total_len = total_len + size(C{i},2);
            if total_len > begin
                C_squeeze(:,begin:total_len) = C{i};
            else
                C_squeeze(:,begin) = C{i};
            end
            begin = total_len + 1;
        end
    else error('No match dimension !');
    end
end
% by Tommy Liu