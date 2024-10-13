class RustlsFfi < Formula
  desc "FFI bindings for the rustls TLS library"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "cfdee5c1fe65de6293ecb3bd69bedce227fe502adfa4ce152617e25f1543c565"
  license any_of: ["Apache-2.0", "MIT", "ISC"]
  head "https://github.com/rustls/rustls-ffi.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "531c2456bfe61e46f1bf2647eff851866c69b34b8f1fcd8db2eb439ca6c09737"
    sha256 cellar: :any,                 arm64_sonoma:  "d0a77beae50b1fca1e44056307cbab2b4757eedf644e74a9512afb05b1dc37ec"
    sha256 cellar: :any,                 arm64_ventura: "f0818a23467caa26a92d2fe0a0fc853751603775b8b423eccde81079244cdd53"
    sha256 cellar: :any,                 sonoma:        "627cb32f6c2de479e56318479c963158d5ad7ac7c5d2d42082af75d0a0f1440c"
    sha256 cellar: :any,                 ventura:       "178341670cc268d0f2b2e3b5ec3c0fee6ab46638f56ab4d4be0c9cd1b79eaaf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "690cd883130d8dc53a7bac47af9baf6514025d10cacc0a9e218e61728ca35bda"
  end

  depends_on "cargo-c" => :build
  depends_on "pkg-config" => :build
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
