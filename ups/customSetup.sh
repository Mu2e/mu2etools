#!/bin/bash
#
# This is a sourced script.
#
# Andrei Gaponenko, 2016

if [[ -n "${MU2E_UPS_QUALIFIERS}" ]]; then
    setup mu2ebintools -q ${MU2E_UPS_QUALIFIERS}
    return 0;
else
    cat >&2 <<EOF
Error: MU2E_UPS_QUALIFIERS environment variable is not set.
It is needed for setting up the mu2ebintools package.
Source Offline/setup.sh, or export MU2E_UPS_QUALIFIERS by hand prior to doing "setup mu2etools".
EOF
    return 1;
fi
