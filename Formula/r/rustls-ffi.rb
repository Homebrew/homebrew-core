class RustlsFfi < Formula
  desc "FFI bindings for the rustls TLS library"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "462d9069d655d433249d3d554ad5b5146a6c96c13d0f002934bd274ce6634854"
  license any_of: ["Apache-2.0", "MIT", "ISC"]
  head "https://github.com/rustls/rustls-ffi.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "196c648a4e425e38a43107492b8100486657ebd12b6724da90945e4323151e1f"
    sha256 cellar: :any,                 arm64_ventura:  "f5c4688a8235f2ee56a30fae6542e2ccd2acdb6739c239fe1206cd32bed26a58"
    sha256 cellar: :any,                 arm64_monterey: "09400a2a2fbcdce3a70bbb398e85d0b0afae1ea57f27726fffe9b885478c2496"
    sha256 cellar: :any,                 sonoma:         "9ac228edf207fae77c88006b90a49c99568b15043ad05b022a4f4f47f2a0c8f5"
    sha256 cellar: :any,                 ventura:        "2c341712777e7168f73e2926465df07620853ef75c7685649ed56cd99520aadc"
    sha256 cellar: :any,                 monterey:       "58f9d44189a5e03b5e98a640013f969afdb5d791b70f5461caf39cf2a0f29382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e15859943bf47b0d18b9e760d2f0e9e63a858d0fd6b1413dc829cda1348863fe"
  end

  depends_on "cargo-c" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "cinstall", "--release", "--prefix", prefix, "--libdir", lib
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
