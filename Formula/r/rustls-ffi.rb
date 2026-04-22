class RustlsFfi < Formula
  desc "FFI bindings for the rustls TLS library"
  homepage "https://github.com/rustls/rustls-ffi"
  url "https://github.com/rustls/rustls-ffi/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "f7e24d0f8b5a7c960817b9395bdd2688b2056d60c2e364fa116bf46f0ab9ffdb"
  license any_of: ["Apache-2.0", "MIT", "ISC"]
  head "https://github.com/rustls/rustls-ffi.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1d7076de4ede55e258d96d0faa2de6fc44c7473f937e0f2927a394e75f30f770"
    sha256 cellar: :any,                 arm64_sequoia: "ef2d370ec13ef2c0276b1605d0f601066c6392dd8386457ddd82ba1e6ab8d89b"
    sha256 cellar: :any,                 arm64_sonoma:  "0d9591f0a81fa705238e6dde4385b6b8d455be1dbb7cdf3a323638a5012b53fe"
    sha256 cellar: :any,                 sonoma:        "e3d235309a643bdb2e037b072486b48452375341ad4c455cb71e02929d9e7655"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84f572eff7336acc974c7040e83ab9edf3057df7cbc30bb8a1acc26a6383f91d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "625aa165c3278ac214731b7c7be5bf8a817322ce0a458cc4dc1cc1c6b59fb10c"
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
