Puppet Cleaner
==============

Puppet DSL source code cleaner and helper utilities

Requirements
------------

  * puppet

it has been tested with puppet 2.7.11 only

Utilities
------------

### puppet-clean

Receives a puppet manifest file as input and outputs the result of
applying a set of transformation rules that makes it comply with
a subset of the current puppet style guide.

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
