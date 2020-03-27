# cppcheck-action
A simple Cppcheck static code analysis for GitHub Actions

## Example usage
In you workflow file, first checkout the repository (using, for instance, a simple but powerful `actions/checkout@v2` action)
```yml
jobs:
  analyse:
    name: Run Cppcheck
    runs-on: ubuntu-latest
    steps:
    - name: Check out repository
      uses: actions/checkout@v2
      with:
        depth: 1
        submodules: 'recursive'
```
then continue with this action:
```yml
    - name: Run Cppcheck
      uses: Bedzior/cppcheck-action@v1.0
      with:
        enabled checks: all
        enable inconclusive: true
        generate report: true
```
This will enable all Cppchecks, including inconclusive ones, and generate the report in `output` directory.
Uploading the result is then as trial as calling:
```yml
    - name: Upload report
      uses: actions/upload-artifact@v1
      with:
        name: report
        path: output
```

Enjoy!

## Full reference

### `debug`
```yml
debug:
  description: 'Debug script run to troubleshoot configuration errors'
  required: false
  default: false
```
Uses `set -x` to see commands passed to `sh`
### `enabled checks`
```yml
enabled checks:
  description: 'Which checks are enabled'
  required: false
  default: 'all'
```
See [wiki](https://sourceforge.net/p/cppcheck/wiki/ListOfChecks/) for a full reference.

### `enable inconclusive`
```yml
enable inconclusive:
  description: 'Enable inconclusive checks'
  required: false
  default: false
```

### `exclude from check`
```yml
exclude from check:
  description: 'Which directories or files to exclude from analysis; format: paths prefixed with `-i`, space-delimited'
  required: false
  default: ''
```
For now it's a space-delimited list of paths, each prefixed with `-i`. E.g.
* `-ivendor`
* `-itools -iexternals -isrc/single_file_library.c`

### `generate report`
```yml
generate report:
  description: 'Whether to generate an XML report'
  required: false
  default: true
```

### `include directories`
```yml
include directories:
  description: 'Include paths; format: directories prefixed with `-I`, space-delimited'
  required: false
  default: ''
```
For now it's a space-delimited list of directories, each prefixed with `-I`. E.g.
* `-I3rdparty/super_library/include`
* `-Iincludes -Iexternal/includes`

### `path`
```yml
path:
  description: 'Path to your project'
  required: true
  default: '.'
```

### `report name`
```yml
report name:
  description: 'Name of your report'
  required: false
  default: ${{ github.repository }}
```
Report title, as displayed in resulting `index.html`

### `verbose`
```yml
verbose:
  description: 'Verbose Cppcheck error descriptions'
  required: false
  default: false
```
For all you wishing to know, exactly why something was marked as dubious or wrong by Cppcheck

# Acknowledgments
I would like to thank `dbeef` for providing a suiting testbed for this GitHub Action in form of his spelunky-psp project repository. Check it out [here](https://github.com/dbeef/spelunky-psp)!

# License
All content in this repository is licensed under the [MIT License](LICENSE).

Copyright (c) 2020 Rafał Będźkowski
