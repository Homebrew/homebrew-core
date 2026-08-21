class RustlsFfi < Formula
  desc "FFI bindings for the rustls TLS library"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "f1612b770be384ff23d5647c815ac3f47734e2ec3c4a03cabc453723461234bc"
  license any_of: ["Apache-2.0", "MIT", "ISC"]
  head "https://github.com/rustls/rustls-ffi.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d52b081a594c924d54f8321691b8d8a312f41c3da1a4c0f60ef067f23a0fdeb1"
    sha256 cellar: :any,                 arm64_sequoia: "7ef0c4fec7e7a045114f167fbbb2fd4d066e1515131c50c97369dcb166834520"
    sha256 cellar: :any,                 arm64_sonoma:  "867c80295b29566fe7f6dcfdadbb6a3d653b5b164f9c383a96a769e338cd0b92"
    sha256 cellar: :any,                 sonoma:        "a713519dba820e8c803ccf35eaf7171bbfa9590da8b0937645a74f557cc2a39c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac7af3add00daff1bccce74385ca82408ec61f735f0c0664e93a204f9508994f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69ef5bc7c81d3423a8d1fa30b1baccfed4a30da8b83a0fbfb5a828a6c4f3182a"
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
