function [] = consoleinfo(text)

if (ispc()||ismac())
    line='                                                                           |';
else
    line='                                                                               ┃';
end

line(1:length(text))=text;
disp(line);

end