function list = CreateOrString(list)
  numentries=length(list);
  for iter=2:length(list)
    list{iter}=['|',list{iter}];
  end
  list=['(',cell2mat(list),')'];
end