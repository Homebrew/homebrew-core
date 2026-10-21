class RustlsFfi < Formula
  desc "FFI bindings for the rustls TLS library"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/refs/tags/v0.15.6.tar.gz"
  sha256 "f56aecad524653138c1e46b90b3dcb65403716ce48db7b7954bdf0a14a051a86"
  license any_of: ["Apache-2.0", "MIT", "ISC"]
  head "https://github.com/rustls/rustls-ffi.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "56de745159348daf69cc0e52b93bb6a0b80ec624f7e94f62d924f09511db1327"
    sha256 cellar: :any, arm64_tahoe:       "eb9d7193e22bace053ec70b1ea986a5d3267f303ed5366a7591cdd04127fe00f"
    sha256 cellar: :any, arm64_sequoia:     "47d5b6219a702d56f7056679ea3c88582c0bdc332d59307e4593112641f3727c"
    sha256 cellar: :any, arm64_linux:       "ac573d33803317f8168016e3e4de13f907b6a85f716925bd6601a1eaad0726ff"
    sha256 cellar: :any, x86_64_linux:      "9a1fc55357f229ffa9979cdbef788cb1a39a7cca657f6861a021ec4440ed664a"
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
