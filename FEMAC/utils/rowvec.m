function v = rowvec(v)

  if size(v,1)>1
    v=reshape(v,1,length(v(:)));
  end

end