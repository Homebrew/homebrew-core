class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://static.crates.io/crates/rure/rure-0.2.5.crate"
  sha256 "8af70744723e3d5b88fec7869518bbd17883b7d9944f67c9b4a69ae4ed90dc9a"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62ec3ebb9421cfbb27839d929284df57577b0acf86f2cef8d65cf46654d64f1d"
    sha256 cellar: :any,                 arm64_sequoia: "bfd9bfc2d13004898934ba27a34f09647df7c02a6dfe576866c53dcbc5505ac4"
    sha256 cellar: :any,                 arm64_sonoma:  "085e8a19d1c6b171f3fb1f670f1781ec0e036be54f3286b1110e940d0858045d"
    sha256 cellar: :any,                 sonoma:        "4b3bff1372782d2dd6ef2aedcabeca77b5a565d1ae1f672b3158ad49c6cf8119"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80429ca549d0b6c36f0ef26c8f78dfa0606d6e401722cdbcff7343e1eb8d7141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1a9dfc85ba7c459e98c38b723dbc3d144d510e0f5fa57b4393553b6c2f85d99"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--release"
    include.install "include/rure.h"
    lib.install "target/release/#{shared_library("librure")}"
    lib.install "target/release/librure.a"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <rure.h>
      int main(int argc, char **argv) {
        rure *re = rure_compile_must("a");
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lrure", "-o", "test"
    system "./test"
  end
end
