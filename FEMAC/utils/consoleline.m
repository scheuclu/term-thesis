function [] = consoleline(text,linebreak)

if (ispc()||ismac())%windows and mac
    line='---------------------------------------------------------------------------';
else%linux
    line='━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
    if linebreak==true
      line(end+1)='┛';
    else
      line(end+1)='┓';
    end
end

line(1:length(text))=text;
if usejava('Desktop')
  %fprintf('<strong>%s</strong>\n',line);
  disp(line);
else
 disp(line);
end
if linebreak
  disp(' ');
end

end