#![no_main]
use libfuzzer_sys::fuzz_target;
use anise::almanac::Almanac;
use bytes::Bytes;
use std::sync::Once;
use env_logger;

static INIT: Once = Once::new();

fuzz_target!(|data: &[u8]| {
    INIT.call_once(|| {
        let _ = env_logger::builder()
            .is_test(true) // make sure it doesnt panic in fuzzing env
            .try_init();
    });
    // create default almanac to serve as test env
    let almanac = Almanac::default();
    // convert fuzzed data into Bytes object, matching _load_from_bytes function
    let _ = almanac.load_from_bytes(Bytes::copy_from_slice(data));
}); 
