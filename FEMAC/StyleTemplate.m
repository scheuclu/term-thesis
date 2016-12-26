classdef StyleTemplate < handle                                                 %
  %short descripption                                                           % no tabs just spaces
  %detailed description(one or more lines)                                      % indentation size 2
                                                                                %
  properties(Access=private)                                                    % always use Access specifiers
    vardouble_@double=[]  %short descripton                                     % class variable names consist of lowercase letters and numbers
    obj_@Classname        %short descripton                                     % class variable names end with '_'
    num_@double=[]        %short descripton                                     % provide short description for all variables
  end                                                                           %
                                                                                % one empty line between properties and methods sections
  methods(Access=public)                                                        %
    function this = StyleTemplate(arg1,arg2)                                    % constructor is always the first function to be defined
      %comments @authorlastname MM/YY                                           % object pointer is always denoted by 'this'
      validateattributes(varname,{'classnames'},{'attributes'},'funcname',...   % all attributes must be validated
                         'varname',  varnum);                                   %
      validateattributes(varname,{'classnames'},{'attributes'},'funcname',...   %
                         'varname',  varnum);                                   %
                                                                                % one empty line after comments and validation
      %/***code***/                                                             %
      %/***code***/                                                             %
      %/***code***/                                                             %
    end                                                                         %                                                                 %
                                                                                %
    function result = gNum(this)                                                % getters are always named with a preceding 'g'
      %comment @authorlastname MM/YY                                            % function names are partwise capitalized for better readability
                                                                                %
      %/***code***/                                                             %
      %/***code***/                                                             %
      %/***code***/                                                             %
    end                                                                         %
                                                                                %
    function result = gVar(this)                                                %
      %comment  @authorlastname MM/YY                                           % return values of getters are always are always named 'result'
                                                                                %
      %/***code***/                                                             %
      %/***code***/                                                             %
      %/***code***/                                                             %
    end                                                                         %
                                                                                %
    function [] = sNum(this,val)                                                % getters are always named with a preceding 's'
      %comment @authorlastname MM/YY                                            %
      validateattributes(varname,{'classnames'},{'attributes'},'funcname',...   %
                         'varname',  varnum);                                   % this pointer is not counted for varnum (val is argument 1 here)
                                                                                %
      %/***code***/                                                             %
      %/***code***/                                                             %
      %/***code***/                                                             %
    end                                                                         %
                                                                                %
    function [] = sVar(this,val)                                                %
      %comment @authorlastname MM/YY                                            % every function must be commented
      validateattributes(varname,{'classnames'},{'attributes'},'funcname',...   %
                         'varname',  varnum);                                   %
                                                                                %
      %/***code***/                                                             %
      %/***code***/                                                             %
      %/***code***/                                                             %
    end                                                                         % functions must be in the following order
                                                                                %  1) getter functions
  end                                                                           %  2) setter functions
                                                                                %  3) other  functions
  methods(Access=private)                                                       %
                                                                                %
    function [] = PerformSomeAction(this,attribute1)                            %
      %comment  @authorlastname MM/YY                                           %
      validateattributes(varname,{'classnames'},{'attributes'},'funcname',...   %
                         'varname',  varnum);                                   %
                                                                                %   
      %/***code***/                                                             %
      %/***code***/                                                             %
      %/***code***/                                                             % 
    end                                                                         %
  end                                                                           %
                                                                                %
end                                                                             %

