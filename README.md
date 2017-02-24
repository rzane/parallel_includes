# ParallelIncludes

:warning: :warning: **DO NOT USE THIS!!** :warning: :warning:

[Ecto](https://github.com/elixir-ecto/ecto), the database wrapper for Elixir, preloads associated records in parallel. Active Record does not.

So I thought to myself, hmmm... wouldn't it be cool if Active Record loaded includes in parallel? Why yes, that would be cool.

As it turns out, it's not that cool. Based on my benchmarks, it's actually slower than loading them synchronously. So, I'm going to chalk this up to being a failed experiment.

## Usage

**Don't. Just don't.**

But, if you absolutely must:

```ruby
gem 'parallel_includes', github: 'rzane/parallel_includes'
```


```ruby
SomeModel.includes(:some_assoc, :some_other_assoc, :yet_another_assoc).parallel
```

## Benchmarks

Here are the results on a small dataset:

```
Warming up --------------------------------------
        non-parallel    11.000  i/100ms
            parallel    10.000  i/100ms
Calculating -------------------------------------
        non-parallel    119.339  (± 6.7%) i/s -    605.000  in   5.099080s
            parallel     99.357  (±11.1%) i/s -    490.000  in   5.007942s

Comparison:
        non-parallel:      119.3 i/s
            parallel:       99.4 i/s - 1.20x  slower
```

Here are the results on a larger dataset:

```
Warming up --------------------------------------
        non-parallel   329.000  i/100ms
            parallel    82.000  i/100ms
Calculating -------------------------------------
        non-parallel      3.083k (±13.4%) i/s -     15.134k in   5.080703s
            parallel    883.428  (± 2.6%) i/s -      4.428k in   5.015859s

Comparison:
        non-parallel:     3083.2 i/s
            parallel:      883.4 i/s - 3.49x  slower
```

As you can see, these are pretty ugly results.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rzane/parallel_includes.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
