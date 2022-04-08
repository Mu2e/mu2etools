#!/bin/bash
#
# This script is sourced by ups setup of mu2etools.
# Note that the mu2etools package provides a "current" version definition,
# which is used by interactive users and also scripts (like mu2eprodsys)
# so the "current" version must support workflows for both modern
# and various legacy versions of Mu2e Offline and related software.
#
# This script must make sure that a fhicl-get command is available.
# A usable version of fhicl-get is provided by the newer versions
# of the FHICLCPP, in which case nothing needs to be done.
# Older FHICLCPP versions did not have fhicl-get at all, or
# for some it did not work right.  For those cases we need
# to setup mu2ebintools package corresponding to that old version
# of FHICLCPP, and export a fhicl-get shell function that translates
# between the fhicl-get interface and one provided by the fhicl-getpar
# binary in mu2ebintools.
#
# The pre-MUSE setup logic utilized the MU2E_UPS_QUALIFIERS environment
# variable defined in Offline/setup.sh to determine the correct version
# of the binary package.
# In MUSE it got superseded by a combination of MUSE_COMPILER_E and MUSE_BUILD.
#
# Andrei Gaponenko, 2016

if [[ -z "${FHICLCPP_VERSION}" ]]; then
    cat >&2 <<EOF
Error: FHICLCPP package must be set up before mu2etools.
Setup a Mu2e Offline version you intend to use and try again.
EOF
    return 1;
fi

VER=
case "${FHICLCPP_VERSION}" in
    v0*) VER=v0_00_00;; # protection against very old unsupported stuff
    v1*) VER=v0_00_00;; # protection against very old unsupported stuff
    v2*) VER=v0_00_00;; # protection against very old unsupported stuff
    v3_00*) VER=v0_00_00;; # protection against very old unsupported stuff
    v3_01*) VER=v0_00_00;; # protection against very old unsupported stuff
    v3_02*) VER=v0_00_00;; # protection against very old unsupported stuff
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
    # anything newer will leave VER empty
esac

if [[ -n "$VER" ]]; then
    # We run an older Offline and should use the fhicl-getpar binary from mu2ebintools
    # instead of fhicl-get from fhiclcpp as the latter may not exist or be unusable.

    if [[ -z "${MU2EBINTOOLS_VERSION}" ]]; then
        # need to setup mu2ebintools

        if [[ -z "${MU2E_UPS_QUALIFIERS}" ]]; then

            if [[ -n "$MUSE_BUILD"  ]] && [[ -n "$MUSE_COMPILER_E" ]]; then
                MU2E_UPS_QUALIFIERS="+${MUSE_COMPILER_E}:+${MUSE_BUILD}"
            else

                cat >&2 <<EOF
Error: the version of FHICLCPP in the environment implies we
need to use the mu2ebintools package.  But there is not
enough information to determine the qualifiers for the binary
package.   Define either MU2E_UPS_QUALIFIERS or
two variables MUSE_BUILD and MUSE_COMPILER_E before trying again.
Alternatively, you can setup a correct version of mu2ebintools
before setting up mu2etools.
EOF
                return 1;
            fi
        fi

        setup -B mu2ebintools $VER -q ${MU2E_UPS_QUALIFIERS}

    fi

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
