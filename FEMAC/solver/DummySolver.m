classdef DummySolver < handle
  %UNTITLED2 Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    dis_
    condlist_
    sol_
  end
  
  methods
    function this = DummySolver(dis,condlist)
      this.dis_=dis;
      this.condlist_=condlist;
    end
    
    function sol = Solve(this)

      numdof=this.dis_.gNumDof();
      this.sol_   =sparse(numdof,1);

    end
    
    function sol = Solution(this)
      sol=this.sol_;
    end
    
  end
  
end

