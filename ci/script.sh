# This script takes care of testing your crate
# https://github.com/japaric/trust/blob/master/ci/script.sh

set -ex

# ----- Options -----

# TARGET enables cross-building
if [ -z $TARGET ]; then
    CARGO=cargo
elif [ "$TARGET" = "i686-unknown-linux-musl" ]; then
    CARGO=cargo
    TARGET="--target $TARGET"
else
    CARGO=cross
    TARGET="--target $TARGET"
fi


# ----- Script -----

main() {
    $CARGO build $TARGET
    $CARGO build $TARGET --release

    if [ ! -z $DISABLE_TESTS ]; then
        return
    fi

    $CARGO test $TARGET
    $CARGO test $TARGET --release
}

# we don't run the "test phase" when doing deploys
if [ -z $TRAVIS_TAG ]; then
    main
fi
