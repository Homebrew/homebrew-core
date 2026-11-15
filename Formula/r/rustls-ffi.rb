class RustlsFfi < Formula
  desc "FFI bindings for the rustls TLS library"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/refs/tags/v0.15.7.tar.gz"
  sha256 "7dc4335663bc904a5eae4d2a1099dff476873152b1859da16570e766a701a3bb"
  license any_of: ["Apache-2.0", "MIT", "ISC"]
  head "https://github.com/rustls/rustls-ffi.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "962d4869e7a62c838fa28932b70dde8c5439f18612647c63c8801b146e4eaf2a"
    sha256 cellar: :any, arm64_tahoe:       "383c8baedbbedbb1b790bdeb05c236a31ee61790619c48d3fb193633db31d65a"
    sha256 cellar: :any, arm64_sequoia:     "39b67c1c8eea59f81bf81394c799206c1a0d4a8b9ba1f6cf3bb3794858790d24"
    sha256 cellar: :any, arm64_linux:       "f6822afe6a7b20c6e4c6b6c79b79a66cc938a70e2332fa1efc7e84813432a3bd"
    sha256 cellar: :any, x86_64_linux:      "7685134d0a89ba1705f464b12ec244da4b3e6169df95a6834e3da0a707cf7d37"
  end

  depends_on "cargo-c" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--prefix", prefix, "--libdir", lib
  end

  test do
    (testpath/"test-rustls.c").write <<~C
      #include "rustls.h"
      #include <stdio.h>
      int main(void) {
        struct rustls_str version = rustls_version();
        printf("%.*s", (int)version.len, version.data);
        return 0;
      }
    C

    ENV.append_to_cflags "-I#{include}"
    ENV.append "LDFLAGS", "-L#{lib}"
    ENV.append "LDLIBS", "-lrustls"

    system "make", "test-rustls"
    assert_match version.to_s, shell_output("./test-rustls")
  end
end
