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

VER=
case "${FHICLCPP_VERSION}" in
    v3_03_00) VER=v1_00_00;;
    v3_06_01) VER=v1_00_01;;
    v3_12_06) VER=v1_01_02;;
    v3_12_09) VER=v1_01_03;;
    v4_01_00) VER=v1_01_04;;
    v4_03_02) VER=v1_01_05;;
    v4_05_01) VER=v1_01_07;;
    v4_06_03) VER=v1_01_09;;
    v4_06_05) VER=v1_01_10;;
    v4_06_06) VER=v1_01_12;;
    v4_06_07) VER=v1_01_13;;
    v4_06_08) VER=v1_01_14;;
    v4_06_09) VER=v1_01_15;;
    v4_10_00) VER=v1_01_16;;
    v4_11_00) VER=v1_01_17;;
    v4_11_01) VER=v1_01_18;;
    v4_11_02) VER=v1_01_18b;; # Update of the older version for the su2020 branch
    v4_12_01) VER=v1_01_19;;
    v4_12_02) VER=v1_01_21;;
esac

if [[ -n "$VER" ]]; then
    # We run an older Offline and should use the fhicl-getpar binary from mu2ebintools
    # instead of fhicl-get from fhiclcpp as the latter may not exist or be unusable.
    setup -B mu2ebintools $VER -q ${MU2E_UPS_QUALIFIERS}

    # mu2eprodys relies on fhicl-get, provide a shell function that will shadow the
    # potentially broken fhicl-get binary
    fhicl-get() {
        arg1="$1"; shift
        newarg=
        case "$arg1" in
            --names-in) newarg="--keys";;
            --atom-as)
                arg2="$1"; shift
                case "$arg2" in
                    int) newarg="--int";;
                    string) newarg="--string";;
                esac
                ;;
            --sequence-of)
                arg2="$1"; shift
                case "$arg2" in
                    string) newarg="--strlist";;
                esac
                ;;
        esac
        # echo running fhicl-getpar $newarg "${@}"
        fhicl-getpar $newarg "${@}"
    }
    export -f fhicl-get
fi
