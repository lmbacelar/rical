require 'spec_helper'

describe Rical do
  f  = -> (x) { x**2 - 2 }
  df = -> (x) { 2*x }

  context 'Newton-Raphson method' do
    context 'root computation' do
      it 'yields +√2 for f(x) = x²-2' do
        expect(Rical.root_for f: f, df: df, x0: 10, method: :newton).to be_within(1e-6).of(2**0.5)
      end

      it 'yields -√2 for f(x) = x²-2' do
        expect(Rical.root_for f: f, df: df, x0: -10, method: :newton).to be_within(1e-6).of(-2**0.5)
      end

      it 'rescues when df(x0) = 0' do
        expect(Rical.root_for f: f, df: df, x0: 0.0, method: :newton).to be_within(1e-6).of(2**0.5)
      end
    end

    context 'inverse computation' do
      it 'yields +2.0 for y=2, f(x)=y=x²-2' do
        expect(Rical.inverse_for f: f, df: df, y: 2, x0: 0, method: :newton).to be_within(1e-6).of(2.0)
      end
    end

  end

  context 'Secant method' do
    context 'root computation' do
      it 'yields +√2 for f(x) = x²-2' do
        expect(Rical.root_for f: f, x0: 10, x1: 9, method: :secant).to be_within(1e-6).of(2**0.5)
      end

      it 'yields -√2 for f(x) = x²-2' do
        expect(Rical.root_for f: f, x0: -10, x1: -9, method: :secant).to be_within(1e-6).of(-2**0.5)
      end

      it 'rescues when f(x1) - f(x0) = 0' do
        # converges but to either one of the roots
        expect(Rical.root_for(f: f, x0: 9, x1: -9, method: :secant).abs).to be_within(1e-6).of(2**0.5)
      end
    end

    context 'inverse computation' do
      it 'yields +2.0 for y=2, f(x)=y=x²-2' do
        expect(Rical.inverse_for f: f, y: 2, x0: 0, x1: 1, method: :secant).to be_within(1e-6).of(2.0)
      end
    end
  end

  context 'error handling' do
    it 'raises ArgumentError when f is not callable' do
      expect{ Rical.root_for f: :dummy, df: df, method: :newton  }.to raise_error ArgumentError
      expect{ Rical.root_for f: :dummy, x0: 0, x1: 1, method: :secant }.to raise_error ArgumentError
    end

    it 'raises ArgumentError when no df given and method is Newton-Raphson' do
      expect{ Rical.root_for f: f, method: :newton    }.to raise_error ArgumentError
      expect{ Rical.inverse_for f: f, method: :newton }.to raise_error ArgumentError
    end

    it 'raises ArgumentError when df is not callable and method is Newton-Raphson' do
      expect{ Rical.root_for f: f, df: :dummy, method: :newton }.to raise_error ArgumentError
    end

    it 'raises NoConvergenceError when Newton-Raphson does not converge' do
      expect{ Rical.root_for f: f, df: df, x0: 1e32, method: :newton, num: 10 
      }.to raise_error Rical::NoConvergenceError
    end

    it 'raises NoConvergenceError when Secant does not converge' do
      expect{ Rical.root_for f: f, x0: 1e32, x1: 1.1e32, method: :secant, num: 10 
      }.to raise_error Rical::NoConvergenceError
    end
  end
end
