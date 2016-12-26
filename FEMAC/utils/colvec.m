function v = colvec(v)
% write the columns of a matrix one below the other
  if size(v,2)>1
    v=reshape(v,length(v(:)),1);
  end

end