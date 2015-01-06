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
%% @deftypefn  {Function File} {@var{y} =} vpasolve (@var{e})
%% @deftypefnx {Function File} {@var{y} =} vpasolve (@var{e}, @var{x})
%% @deftypefnx {Function File} {@var{y} =} vpasolve (@var{e}, @var{x}, @var{x0})
%% Numerical solution of a symbolic equation.
%%
%% @example
%% syms x
%% e = exp(x) == x + 2
%% vpa_solve(e, x, 0.1)
%% @end example
%%
%% @seealso{vpa}
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function r = vpasolve(e, x, x0)

  if (nargin < 3)
    x0 = sym(0);
  end
  if (nargin < 2)
    x = symvar(e, 1);
  end

  n = digits();

  % nsolve gives back mpf object: https://github.com/sympy/sympy/issues/6092

  % FIXME: 0.7.5 nonsense here?  On fedora, uses system mpmath?
  % Ubuntu needs sympy.mpmath etc
  % Update: 0.7.6 needs this too, at least on Fedora 21.  Later
  % sympy will not have bundled mpmath and hopefully this can all
  % go away.
  cmd = {
    '(e, x, x0, n) = _ins'
    'if sympy.__version__ in ("0.7.5", "0.7.6"):'
    '    try:'
    '        sympy.mpmath.mp.dps = n'
    '    except AttributeError:'
    '        import mpmath'
    '        mpmath.mp.dps = n'
    'else:'
    '    sympy.mpmath.mp.dps = n'
    'r = nsolve(e, x, x0)'
    'r = sympy.N(r, n)'
    'return r,' };

  r = python_cmd (cmd, sym(e), x, x0, n);

end


%!test
%! syms x
%! vpi = vpa(sym(pi), 64);
%! e = tan(x/4) == 1;
%! q = vpasolve(e, x, 3.0);
%! w = q - vpi ;
%! assert (double(w) < 1e-30)

%!test
%! syms x
%! vpi = vpa(sym(pi), 64);
%! e = tan(x/4) == 1;
%! q = vpasolve(e, x);
%! w = q - vpi;
%! assert (double(w) < 1e-30)
%! q = vpasolve(e);
%! w = q - vpi;
%! assert (double(w) < 1e-30)

%!test
%! % very accurate pi
%! syms x
%! e = tan(x/4) == 1;
%! m = digits(256);
%! q = vpasolve(e, x, 3);
%! assert (double(abs(sin(q))) < 1e-256)
%! digits(m);

%!test
%! % very accurate sqrt 2
%! syms x
%! e = x*x == 2;
%! m = digits(256);
%! q = vpasolve(e, x, 1.5);
%! assert (double(abs(q*q - 2)) < 1e-256)
%! digits(m);

%!xtest
%! % very accurate sqrt pi
%! % fails: https://github.com/sympy/sympy/issues/8564
%! syms x
%! e = x*x == sym(pi);
%! m = digits(256);
%! q = vpasolve(e, x, 3);
%! q*q - vpa(pi)
%! sin(q*q)
%! assert (double(abs(sin(q))) < 1e-256)
%! digits(m);