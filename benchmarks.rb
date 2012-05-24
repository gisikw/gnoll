require "rubygems"
require "benchmark"
require "./lib/gnoll"

# Rails 4.0.0.beta implementation of Object#try
class Object
  def try(*a,&b)
    if a.empty? && block_given?
      yield self
    else
      __send__(*a,&b)
    end
  end
end

class NilClass
  def try(*args)
    nil
  end
end

def run_benchmarks(foo)
  n = 100000
  Benchmark.bm(12) do |x|
    x.report('Object#try')    {n.times do;  foo.try(:foo).try(:bar).try(:baz).try(:qux).try(:foo);  end}
    x.report('rescue nil')    {n.times do;  foo.foo.bar.baz.qux.foo rescue nil;                     end}
    x.report('foo &&') do
      n.times do  
        foo && foo.foo && foo.foo.bar && foo.foo.bar.baz && foo.foo.bar.baz.qux && foo.foo.bar.baz.qux.foo 
      end
    end
    x.report('Object.nil!')   {n.times do;  foo.nil!.foo.bar.baz.qux.foo;                           end}
  end
end

puts "\nFirst-order failure"
foo = nil
run_benchmarks(foo)

puts "\nSecond-order failure"
foo = Struct.new(:foo).new
run_benchmarks(foo)

puts "\nThird-order failure"
foo.foo = Struct.new(:bar).new
run_benchmarks(foo)

puts "\nFourth-order failure"
foo.foo.bar = Struct.new(:baz).new
run_benchmarks(foo)

puts "\nFifth-order failure"
foo.foo.bar.baz = Struct.new(:qux).new
run_benchmarks(foo)

puts "\nValid"
foo.foo.bar.baz.qux = Struct.new(:foo).new
run_benchmarks(foo)
