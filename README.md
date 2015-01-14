# **RICAL**
### **R**oot and **I**nverse **CAL**culator

Using Newton-Raphson or Secant methods, and within an arbitrary error:

* Computes the values of a root of an arbitrary function _f(x, a, b, ...)_
* Computes the value of inverse function _f<sup>-1</sup>(y, a, b, ...) = x_ at point _y_
* Handles functions _f(x, a, b, ...)_, when fixed _f<sub>args</sub>_ = _a, b, ..._ are set
* Handles additional function arguments either as Array or Hash (matching positional or named parameters)

The Newton-Raphson requires:

* one "close enough" estimate - _x<sub>0</sub>_ - of the root or inverse value
* the derivative function _f'(x, a, b, ...)_
* _f<sub>args</sub>_ containing _a, b, ..._ when existing
* _f'<sub>args</sub>_ containing _a, b, ..._ when existing (Note _f<sub>args</sub>_ are independent of _f'<sub>args</sub>_)

The Secant method requires:

* two "close enough" estimates - _x<sub>0</sub>_, _x<sub>1</sub>_ - of the root or inverse value
* _f<sub>args</sub>_ containing _a, b, ..._ when existing

If the estimates are not "close enough" (and what that means depends on _f(x, a, b, ...)_), the methods may not converge to a solution.
This may also happen for a "low" number of iterations and/or a "low" error limit.
When no convergence is possible on the set conditions, a `NoConvergenceError` is raised.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rical'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rical


## Usage examples

1. Set function(s) as lambdas

```ruby
fx1  = -> (x) { x**2 - 2 }
dfx1 = -> (x) { 2*x }
```

or set function(s) as Proc

```ruby
fx2 = Proc.new do |x, a, b|
  a*x**2 + b
end

dfx2 = Proc.new do |x, a|
  2*a*x
end
```

or set function(s) as existing method(s)

```ruby
def f3(x, a:, b:)
  a*x**2 + b
end

fx3 = method(:f3)
```

2. Call `root_for` of `inverse_for` passing function(s) and estimate(s):

**Newton-Raphson's Method**

```ruby
Rical.root_for f: fx1, df: dfx1, x0: 1.0, method: :newton_raphson    # :newton_raphson aliased to :n, :newton
Rical.inverse_for f: fx1, df: dfx1, x0: 1.0, y: 2.0, method: :newton

# with fargs and dfargs
Rical.root_for f: fx2, fargs: [1, -2], df: dfx2, dfargs: 2, x0: 1.0, method: :newton
Rical.root_for f: fx3, fargs: { a: 1, b: -2 }, df: dfx3, dfargs: { a: 2 }, x0: 1.0, method: :newton
```

**Secant's Method**

```ruby
Rical.root_for f: fx, x0: 0.0, x1: 1.0, method: :secant              # :secant aliased to :sec, :s
Rical.inverse_for f: fx, x0: 0.0, x1: 1.0, y: 2.0, method: :secant

# with fargs and dfargs
Rical.inverse_for f: fx, fargs: [1, -2], x0: 0.0, x1: 1.0, y: 2.0, method: :secant
```

3. Change number of iterations - _num_ - or maximum allowable error - _err_ - if needed:

```ruby
Rical.root_for f: fx, ......, num: 1e3, err: 1e-12      # defaults num: 100, err: 1e-6
Rical.inverse_for f: fx, ......, num: 1e3, err: 1e-12   # defaults num: 100, err: 1e-6
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/rical/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
