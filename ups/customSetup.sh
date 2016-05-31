#!/bin/bash
#
# This is a sourced script.
#
# Andrei Gaponenko, 2016

if [[ -n "${MU2EBINTOOLS_VERSION}" ]]; then
    # mu2ebintools already setup
    return 0
fi

if [[ -z "${MU2E_UPS_QUALIFIERS}" ]]; then
    cat >&2 <<EOF
Error: MU2E_UPS_QUALIFIERS environment variable is not set.
It is needed for setting up the mu2ebintools package.
Source Offline/setup.sh prior to doing "setup mu2etools".

Alternatively, you can setup a correct version of mu2ebintools
before setting up mu2etools.
EOF
    return 1;
fi

if [[ -z "${FHICLCPP_VERSION}" ]]; then
    cat >&2 <<EOF
Error: FHICLCPP_VERSION environment variable is not set.
It is needed for setting up the mu2ebintools package.
Source Offline/setup.sh prior to doing "setup mu2etools".

Alternatively, you can setup a correct version of mu2ebintools
before setting up mu2etools.
EOF
    return 1;
fi


# the default is emtpy version, which will
# cause UPS to set up the "current" version of the package
VER=
case "${FHICLCPP_VERSION}" in
    v3_03_00) VER=v1_00_00;;
    v3_06_01) VER=v1_00_01;;
    v3_12_06) VER=v1_01_02;;
    v3_12_09) VER=v1_01_03;;

    *)
        # leave it empty - may be "current" is the correct answer
        # for the given set of qualifiers
        ;;
esac

setup -B mu2ebintools $VER -q ${MU2E_UPS_QUALIFIERS}
