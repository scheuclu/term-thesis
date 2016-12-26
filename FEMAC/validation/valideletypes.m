function list = valideletypes(listtype)
   validatestring(listtype,validelelists(),'validelements','listtype',1);
   switch listtype
     case 'stiff'
       list={'EleTri3','EleQuad4','EleTet4','EleHex8'};
     case 'dirich'
       list={'CondElePoint1','CondEleLine2','CondEleTri3','CondEleQuad4'};
     case 'neumann'
       list={'CondElePoint1','CondEleLine2','CondEleTri3','CondEleQuad4'};
     case 'all'
       list={'EleTri3','EleTet4','EleHex8','CondElePoint1','CondEleLine2','CondEleTri3','CondEleQuad4'};
     otherwise
       error('listtype not recognized');
   end
       

end