function result = InputSection(sectionname,sectioncontent)
  %takes a datfile section as argument annd calls the approriate subroutine
  %to process that @scheucher 05/16
  validatestring(sectionname,validdatsections(),'InputSection','sectionname',1);
  validateattributes(sectioncontent,{'char'},{'nonempty'},'InputSection','sectioncontent',2);

  result=[];

  switch sectionname
    case 'MATERIALS'
      result=InputMaterial(sectioncontent);
    case 'CONDITIONS'
      result=InputCondition(sectioncontent);
    otherwise
      result=InputGeneral(strsplit(sectioncontent,{'\r\n','\r','\n'},'CollapseDelimiters',true));
  end

end