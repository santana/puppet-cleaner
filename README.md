Puppet Cleaner
==============

Puppet DSL source code cleaner and helper utilities

Motivation
----------
http://santanatechnotes.blogspot.mx/2013/04/puppet-cleaner-010-released.html

Requirements
------------

  * puppet

it has been tested with puppet 2.7.11 only

Utilities
------------

### puppet-clean

Receives a puppet manifest file as input and outputs the result of
applying the set of transformation rules that you select. If no options
are selected all of them are applied, which currently is a subset of the
puppet style guide.

    Usage:
    
        puppet-clean [-h] [-t n] [-abedlmovw ] file.pp [file2.pp...]
    
    Options:
        -h, --help              this help message
        -d, --debug             prints tokens before and after the transformation
    
        -a, --alignfarrow       aligns fat arrow (=>)
        -b, --quotedbooleans    removes unneeded quotes around boolean literals
        -e, --ensurefirst       moves 'ensure' parameter to the top
        -l, --link              uses ensure => link and target for symbolic links
        -m, --mlcomments        converts /* */ style comments into #
        -o, --octalmode         uses a 4 digit string for file modes
        -t n, --softtabs n      indents by n spaces
        -v, --quotedvariables   removes unneeded quotes around variables
        -w, --trailingws        removes trailing white space

### puppet-diff

Receives two puppet manifest files and outputs its difference, after
converting them to YAML. Useful for verifying what (if anything) has
changed after applying puppet-clean.

### puppet-inspect

Receives a puppet manifest file and converts its objects (defined types,
classes and nodes) to YAML.

Help & Feedback
------------

Mail me directly if you need help or have any feedback about it.
