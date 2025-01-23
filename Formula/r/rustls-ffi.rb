class RustlsFfi < Formula
  desc "FFI bindings for the rustls TLS library"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "bd369104ae660660017ce2775af510e004f55a0146de3e8a8caf06d7de1025ee"
  license any_of: ["Apache-2.0", "MIT", "ISC"]
  head "https://github.com/rustls/rustls-ffi.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "47b397e147645e17b03e2d5d46ec4203195c80335b5fcb38ef3cb6c473b0531b"
    sha256 cellar: :any,                 arm64_sonoma:  "b14ae74961926585391ec44c5c8fda9de20f7f8c8cfd92646259316e937bd84b"
    sha256 cellar: :any,                 arm64_ventura: "707bfa4e9bd625917be6e35dd5ce92bb067d008eb9e8ff3ae97035563977b802"
    sha256 cellar: :any,                 sonoma:        "b7260d7c806ab52955d4e5b2ed79e4b5c924fbf4bf2c9be81d6ad8ad5c73259f"
    sha256 cellar: :any,                 ventura:       "8aa5a2fb20ee177bd085c509135dcf2662586ec168978a126db438258bff4e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0221208b4eaece7cb8862f89382177bb7875ab05aaefba4d99259723b5e378a6"
  end

  depends_on "cargo-c" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--prefix", prefix, "--libdir", lib
  end

  test do
    (testpath/"test-rustls.c").write <<~C
      #include "rustls.h"
      #include <stdio.h>
      int main(void) {
        struct rustls_str version = rustls_version();
        printf("%s", version.data);
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
