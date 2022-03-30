<p align="center">
<!-- I probably spent more time redrawing & optimizing this crewmate... -->
<!-- But hey! They're cute! -->
  <img width="200" alt="Among Us crewmate" src="./logo.svg">
</p>
<h1 align="center">🍋 pog 🍋</h1>
<h4 align="center">A faster <code>npm run</code> & <code>npx</code></h4>
<p align="center">
  <br />
    <a href="https://github.com/GeopJr/pog/blob/main/CODE_OF_CONDUCT.md"><img src="https://img.shields.io/badge/Contributor%20Covenant-v2.1-409f00.svg?style=for-the-badge&labelColor=f6f657" alt="Code Of Conduct" /></a>
    <a href="https://github.com/GeopJr/pog/blob/main/LICENSE"><img src="https://img.shields.io/badge/LICENSE-BSD--2--Clause-409f00.svg?style=for-the-badge&labelColor=f6f657" alt="BSD-2-Clause" /></a>
    <a href="https://github.com/GeopJr/pog/actions"><img src="https://img.shields.io/github/workflow/status/geopjr/pog/Specs%20&%20Lint/main?labelColor=f6f657&style=for-the-badge" alt="ci action status" /></a>
</p>

#

## What is pog?

It's an extremely fast & dependency-less replacement for `npm run` and `npx`.

Pog is inspired by [@egoist](https://github.com/egoist/)'s [dum](https://github.com/egoist/dum/), but written in Crystal instead of Rust.

> It was really fun trying to optimize it as much as possible!

They are mostly on par in terms of speed and functionality. Pog however is missing the "interactive" mode as I'd rather keep it dependency-less.

#

## Installation

### Pre-built

You can download one of the pre-built binaries from the [releases page](https://github.com/GeopJr/pog/releases/latest) for Linux & MacOS.

For Linux, there's a static build available (and is recommended).

They are built & published by our lovely [actions](https://github.com/GeopJr/pog/actions/workflows/release.yml).

### Building

#### Dependencies

- `crystal` - `1.3.2`

#### Makefile

- `$ make` (or `$ make static` on Alpine Linux for a static build)
- `# make install`

##### Enable Deep-Search

If you build with the `POG_ENABLE_DEEPSEARCH=true` env var, you'll enable deep-search.

Instead of looking for binaries in `node_modules/.bin` it will look through all folders/dependencies.

#

## Benchmarks

`$ hyperfine "./pog-static foo" "./pog foo" "./dum foo" "npm run foo" --warmup 10`

|     Command      |  Mean [ms]   | Min [ms] | Max [ms] |  Relative   |
| :--------------: | :----------: | :------: | :------: | :---------: |
| `pog-static foo` |  51.4 ± 8.4  |   38.4   |   69.9   |    1.00     |
|    `dum foo`     |  51.9 ± 9.2  |   40.9   |   72.1   | 1.01 ± 0.24 |
|    `pog foo`     |  52.5 ± 8.8  |   40.0   |   77.3   | 1.02 ± 0.24 |
|  `npm run foo`   | 376.2 ± 10.5 |  352.9   |  385.3   | 7.31 ± 1.21 |

<details><summary>Full Log</summary>
<p>

```
Benchmark 1: ./pog-static foo
  Time (mean ± σ):      51.4 ms ±   8.4 ms    [User: 40.9 ms, System: 11.3 ms]
  Range (min … max):    38.4 ms …  69.9 ms    66 runs

Benchmark 2: ./pog foo
  Time (mean ± σ):      52.5 ms ±   8.8 ms    [User: 41.5 ms, System: 12.6 ms]
  Range (min … max):    40.0 ms …  77.3 ms    53 runs

Benchmark 3: ./dum foo
  Time (mean ± σ):      51.9 ms ±   9.2 ms    [User: 41.2 ms, System: 11.1 ms]
  Range (min … max):    40.9 ms …  72.1 ms    47 runs

Benchmark 4: npm run foo
  Time (mean ± σ):     376.2 ms ±  10.5 ms    [User: 423.6 ms, System: 51.5 ms]
  Range (min … max):   352.9 ms … 385.3 ms    10 runs

Summary
  './pog-static foo' ran
    1.01 ± 0.24 times faster than './dum foo'
    1.02 ± 0.24 times faster than './pog foo'
    7.31 ± 1.21 times faster than 'npm run foo'
```

</p>
</details>

|                                           Whisker Plot                                           |                                            Histogram                                            |
| :----------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------: |
| ![whisker plot of the benchmarks](https://cdn.jsdelivr.net/gh/GeopJr/pog@benchmarks/whisker.svg) | ![histogram of the benchmarks](https://cdn.jsdelivr.net/gh/GeopJr/pog@benchmarks/histogram.svg) |

> Please don't take these benchmarks too seriously.

#

```
$ pog -h

pog v1.0.0

USAGE:
    pog [OPTIONS] COMMAND [ARGS]

COMMANDS:
    <script_name>             Run a script
    run                       List available scripts
    run <script_name>         Same as <script_name>
    add <packages>            Same as (p)npm i or yarn add <packages>
    i, install                Same as (p)npm/yarn install
    remove, uninstall         Same as (p)npm/yarn remove

FLAGS:
    -c INPUT, --cd=INPUT             Change working directory
    -h, --help                       Show this help
```

```
$ pog foo

🍋 foo
🍋 node stuff/example-script
from example []
```

```
$ pog test --1312

🍋 test
🍋 echo "hello test" && npm run foo -- arg
hello test

> foo
> node stuff/example-script "arg" "--1312"

from example [ 'arg', '--1312' ]
```

> You can find the above scripts (including the one used in benchmarks) on [dum's repo](https://github.com/egoist/dum/).

#

## Contributing

1. Read the [Code of Conduct](https://github.com/GeopJr/pog/blob/main/CODE_OF_CONDUCT.md)
2. Fork it ( https://github.com/GeopJr/pog/fork )
3. Create your feature branch (git checkout -b my-new-feature)
4. Commit your changes (git commit -am 'Add some feature')
5. Push to the branch (git push origin my-new-feature)
6. Create a new Pull Request

#

## Sponsors

<p align="center">

[![GeopJr Sponsors](https://cdn.jsdelivr.net/gh/GeopJr/GeopJr@main/sponsors.svg)](https://github.com/sponsors/GeopJr)

</p>
