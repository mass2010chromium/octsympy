%% Copyright (C) 2014 Colin B. Macdonald
%% Copyright (C) 2016 Lagu
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
%% @deftypefn {Function File}  {@var{r} =} setdiff (@var{A}, @var{B})
%% Set subtraction.
%%
%% @seealso{union, intersect, setxor, unique, ismember}
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function r = setdiff(a, b)

  cmd = {
         'a, b = _ins'
         'if isinstance(a, sp.Set) or isinstance(b, sp.Set):'
         '    return a - b,'
         ''
         'A = sp.FiniteSet(*(list(a) if isinstance(a, sp.MatrixBase) else [a]))'
         'B = sp.FiniteSet(*(list(b) if isinstance(b, sp.MatrixBase) else [b]))'
         'C = A - B'
         'return sp.Matrix([list(C)]),'
        };

    r = python_cmd (cmd, sym(a), sym(b));

end


%!test
%! A = sym([1 2 3]);
%! B = sym([1 2 4]);
%! C = setdiff(A, B);
%! D = sym([3]);
%! assert (isequal (C, D))

%!test
%! % one nonsym
%! A = sym([1 2 3]);
%! B = [1 2 4];
%! C = setdiff(A, B);
%! D = sym([3]);
%! assert (isequal (C, D))

%!test
%! % empty
%! A = sym([1 2 3]);
%! C = setdiff(A, A);
%! assert (isempty (C))

%!test
%! % empty input
%! A = sym([1 2]);
%! C = setdiff(A, []);
%! assert (isequal (C, A) || isequal (C, sym([2 1])))

%!test
%! % scalar
%! syms x
%! assert (isequal (setdiff([x 1], x), sym(1)))
%! assert (isempty (setdiff(x, x)))

%!test
%! A = interval(sym(1), 3);
%! B = interval(sym(2), 5);
%! C = setdiff(A, B);
%! assert( isequal( C, interval(sym(1), 2, false, true)))
