class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/refs/tags/1.11.0.tar.gz"
  sha256 "1642eeb71536d58128ac798af242efafee1d4689c71d211028227e17ac20aeba"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "27991ffcdefcaed4e27f7e655f9231925eaa08944fcbbb9fcc6c8a5baf2ba626"
    sha256 cellar: :any,                 arm64_sonoma:  "1a60a850c8382c558d81cfbbce2fb07934675f1eb75bb316f8793bcea783a0d1"
    sha256 cellar: :any,                 arm64_ventura: "b64bc9a03e10f2f6e085c6def90c0532323e4dbd28e5f1c646bba1a3b0ec6710"
    sha256 cellar: :any,                 sonoma:        "ff0a4f91add4db84e53515a9c13b4f0baca568e45b747b7fea831904dd5aeaa7"
    sha256 cellar: :any,                 ventura:       "72502d7205d13a27a3bda51b74600f166f463d8071b9e36d051d4485ac8e9007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9593aabb99329a532f68ea5b2590b6982b36c77263137ccaaf6a92ca1bf72a42"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--manifest-path", "regex-capi/Cargo.toml", "--release"
    include.install "regex-capi/include/rure.h"
    lib.install "target/release/#{shared_library("librure")}"
    lib.install "target/release/librure.a"
    prefix.install "regex-capi/README.md" => "README-capi.md"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <rure.h>
      int main(int argc, char **argv) {
        rure *re = rure_compile_must("a");
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrure", "-o", "test"
    system "./test"
  end
end
