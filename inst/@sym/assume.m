%% Copyright (C) 2014 Colin B. Macdonald
%%
%% This file is part of OctSymPy.
%%
%% OctSymPy is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 3 of the License,
%% or (at your option) any later version.
%%
%% This software is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty
%% of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
%% the GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public
%% License along with this software; see the file COPYING.
%% If not, see <http://www.gnu.org/licenses/>.

%% -*- texinfo -*-
%% @deftypefn  {Function File} {} assume (@var{x}, @var{cond})
%% @deftypefnx {Function File} {@var{x} =} assume (@var{x}, @var{cond})
%% New assumptions on a symbolic variable (replace old if any).
%%
%% Note: operates on the caller's workspace via evalin/assignin.
%% So if you call this from other functions, it will operate in
%% your function's  workspace (not the @code{base} workspace).
%%
%% FIXME: idea of rewriting all sym vars is a bit of a hack, not
%% well tested (for example, with global vars.)
%%
%% @seealso{assumeAlso, assumptions, sym, syms}
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function varargout = assume(x, cond, varargin)

  ca.(cond) = true;

  xstr = strtrim(disp(x));
  newx = sym(xstr, ca);

  % hack: traverse caller's workspace and replace x with newx
  assignin('caller', 'hack__newx__', newx);
  evalin('caller', 'fix_assumptions_script');

  if (nargout > 0)
    varargout{1} = newx;
  end
end


%!test
%! syms x
%! assume(x, 'positive')
%! a = assumptions(x);
%! assert(strcmp(a, 'x: positive'))
%! assume(x, 'even')
%! a = assumptions(x);
%! assert(strcmp(a, 'x: even'))
%! assume(x, 'odd')
%! a = assumptions(x);
%! assert(strcmp(a, 'x: odd'))
