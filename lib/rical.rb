require 'rical/version'
require 'rical/errors'

module Rical
  extend self

  def root_for f:, fargs: nil,
               df: nil, dfargs: nil,
               x0: 0.0, x1: 1.0, method:, num: 100, err: 1e-6
    raise ArgumentError, 'f must respond_to call'    unless f.respond_to? :call

    case method
    when :n, :newton, :newton_raphson
      raise ArgumentError, 'df is required'          unless df
      raise ArgumentError, 'df must respond_to call' unless df.respond_to? :call
      newton_raphson_root_for f, fargs, df, dfargs, Float(x0), num, err
    when :s, :sec, :secant
      secant_root_for f, fargs, Float(x0), Float(x1), num, err
    else
      raise ArgumentError, 'unexpected method (allowed :newton, :secant)'
    end
  end

  def inverse_for f:, y: 0.0, **args
    f_1= -> (x) { f.call(x) - Float(y) }
    root_for f: f_1, **args
  end
  alias_method :inv_for, :inverse_for

private
  def newton_raphson_root_for f, fargs, df, dfargs, x, n, err
    n.times do
      fx  = compute  f, x, fargs
      dfx = compute df, x, dfargs
      dfx = [1e-3, err * 1e3].max if dfx == 0.0
      x = x - ( fx / dfx )
      return x if compute(f, x, fargs).abs < err
    end
    raise NoConvergenceError
  end

  def secant_root_for f, fargs, x0, x1, n, err
    n.times do
      fx0 = compute f, x0, fargs
      fx1 = compute f, x1, fargs
      delta = fx1 - fx0
      delta = [1e-3, err * 1e3].max if delta == 0.0
      x = x1 - (fx1 * (x1 - x0)) / delta
      return x if compute(f, x, fargs).abs < err
      x0, x1 = x1, x
    end
    raise NoConvergenceError
  end

  def compute f, x, fargs
    return f.call x          unless fargs
    return f.call x, **fargs if     fargs.is_a? Hash
    return f.call x, *fargs
  end
end
