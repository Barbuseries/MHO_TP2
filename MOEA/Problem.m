%% IMPORTANT: To make functions work with plots, they must accept
%% matrices as variables (i,e., x = [x11, x12, ...; x21, x22, ...;
%% ...], y = [y11, y12, ...; y21, y22, ...; ...]).
%% Remember that when writing them!

function Problem
  global PROBLEM;
  
  PROBLEM.TOTO = @TOTO;
  PROBLEM.kursawe = @kursawe;
  PROBLEM.shaffer = @shaffer;
  PROBLEM.fonsecaFlemming = @fonsecaFlemming;
end

%% TOTO
function result = TOTO(ga)
  result.objective_vector = {@TOTO_f1_, @TOTO_f2_};
  result.constraints = [[0, 10]
					    [0, 10]];

  result.optimize = optimize_(ga, result, 0);
end

function result = TOTO_f1_(x, y)
  result = x - 3 * y;
end

function result = TOTO_f2_(x, y)
  result = 3 * x + y;
end

%% Kursawe
function result = kursawe(ga, n)
  result.objective_vector = {generate_fn_n_(n, @kursawe_f1_), generate_fn_n_(n, @kursawe_f2_)};
  result.constraints = repmat([-5, 5], n, 1);
  
  result.optimize = optimize_(ga, result, 0);
end

function result = kursawe_f1_(n, varargin)
  xi = shapeVariables(n, varargin{:});
  
  xi_sq = xi(:, :, 1:end-1) .^ 2;
  xi_plus_one_sq = xi(:, :, 2:end) .^ 2;
  
  BY_DEPTH = 3;
  result = sum(-10 * exp(-0.2 * sqrt(xi_sq  + xi_plus_one_sq)), BY_DEPTH);
end

function result = kursawe_f2_(n, varargin)
  xi = shapeVariables(n, varargin{:});
  
  BY_DEPTH = 3;
  result = sum(abs(xi).^0.8 + 5*sin(xi.^3), BY_DEPTH);
end


%% Shaffer
function result = shaffer(ga)
  result.objective_vector = {@shaffer_f1_, @shaffer_f2_};
  result.constraints = [-10^3, 10^3];

  result.optimize = optimize_(ga, result, 0);
end

function result = shaffer_f1_(x)
  result = x .^ 2;
end

function result = shaffer_f2_(x)
  result = (x  - 2) .^ 2;
end

%% Fonseca Flemming
function result = fonsecaFlemming(ga, n)
  result.objective_vector = {generate_fn_n_(n, @fonsecaFlemming_f1_), generate_fn_n_(n, @fonsecaFlemming_f2_)};
  result.constraints = repmat([-4, 4], n, 1);

  result.optimize = optimize_(ga, result, 0);
end

function result = fonsecaFlemming_f1_(n, varargin)
  xi = shapeVariables(n, varargin{:});

  BY_DEPTH = 3;
  inv_sqrt3 = 1 / sqrt(3);
  result = 1 - exp(-sum((xi - inv_sqrt3) .^2, BY_DEPTH));
end

function result = fonsecaFlemming_f2_(n, varargin)
  xi = shapeVariables(n, varargin{:});

  BY_DEPTH = 3;
  inv_sqrt3 = 1 / sqrt(3);
  result = 1 - exp(-sum((xi + inv_sqrt3) .^2, BY_DEPTH));
end


function result = optimize_(ga, problem, maximize)
    result = @(config) ga.optimize(maximize, problem.objective_vector, problem.constraints, config);
end

function h = generate_fn_n_(n, fn)
  h = @(varargin) fn(n, varargin{:});
end

%% IMPORTANT: To sum variables (x + y, ...), the sum must be done on
%% the _depth_ (i.e, sum(..., 3)).
function result = shapeVariables(n, varargin)
  %% Reshape to have separated variables represented by the depth
  %% (v(:, :, i)) (so it works with matrices)
  [N, ~] = size(varargin{1});
  result  = reshape([varargin{:}], [], N, n);
end
