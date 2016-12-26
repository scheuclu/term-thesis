function str = locstring(stack)
validateattributes(stack,{'struct'},...
  {isfield(stack, 'file'),isfield(stack, 'name'),isfield(stack, 'line')},...
  'locstring','stack',1);

str=[stack.file,'::',stack.name,'::',num2str(stack.line)];

end