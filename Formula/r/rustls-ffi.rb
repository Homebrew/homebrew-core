class RustlsFfi < Formula
  desc "FFI bindings for the rustls TLS library"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "db3939a58677e52f03603b332e00347b29aa57aa4012b5f8a7e779ba2934b18b"
  license any_of: ["Apache-2.0", "MIT", "ISC"]
  head "https://github.com/rustls/rustls-ffi.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "219d4960fb3124a191b5b35029d8d16bd776ff53da6de34f4a2ed99593b111f4"
    sha256 cellar: :any,                 arm64_sequoia: "9dc82894121ecb234a72a281ad45a1f6c5f1640c38371f282f039ce9354cc08b"
    sha256 cellar: :any,                 arm64_sonoma:  "6fc16fefdf0d16506468c26dcd82b6483ce80f1248786d0c3737c511fd862cf7"
    sha256 cellar: :any,                 arm64_ventura: "5ae6641e5f808a9bc0bab0b64d0334bb62982986854337295c8842e6a20b7079"
    sha256 cellar: :any,                 sonoma:        "40b6f9e829ba02d8d9b6873c95fc06d82f5a3baf05a11f950f32ef9c5a168a55"
    sha256 cellar: :any,                 ventura:       "349b1818df27680dd698c0fd2477bb42082b478e5100b244a70251a5b9a31b8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "beaa4376c2ffd27d3f86539496d84ba116335808e28a33c7a9b0ca677a13f155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c686a5049eb5fc651ee74589a6ba72f05341a0389c539d6d80cc20000c152b1f"
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
