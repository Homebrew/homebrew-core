class RustlsFfi < Formula
  desc "FFI bindings for the rustls TLS library"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "1a1066b4d5729469a93a0fd48c005667e836f8f56cf20361613b5a8a00684369"
  license any_of: ["Apache-2.0", "MIT", "ISC"]
  head "https://github.com/rustls/rustls-ffi.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0b976c8716d9d2c0d1edeb08a3dde4ad3d8464e922083f15a231409f0791f741"
    sha256 cellar: :any,                 arm64_sequoia: "d906f79e9ba90ab173affbf5ee1356c1b0bea30858eecaa4af94cc4700c9b91a"
    sha256 cellar: :any,                 arm64_sonoma:  "63b13f19072d5b0d393321e9e1cd19efb3370e7728381611b353c5f7adc5e528"
    sha256 cellar: :any,                 sonoma:        "80319d9cfec30a246a0a8a28cc2226a1b53085c0a5a2e80508b74107d51f43d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b21212629d2f17df8a24c64818f485530636c53a5a2401e7844da935a440773f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cc3adab832add8cc85b1bddb3044466c0deb4687042ba306b29d05a4ceb6a69"
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
