#!/bin/bash -e

mix compile
mix dialyzer
mix test
# MIX_ENV=docs mix inch
# mix docs
