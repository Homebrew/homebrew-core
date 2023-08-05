class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/1.9.2.tar.gz"
  sha256 "df6765f027d6b602ced9f6847c97bcb53600661b9bb5eb5216db6b556d1d248a"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ac99705966590fe1f52dc32caed40728abf5240da1e84ea582bb5be66c3ecbd9"
    sha256 cellar: :any,                 arm64_monterey: "8933526b2a0850da34c56286424a19b0a7ce6d46bb6149dc08e20a96ea26f07e"
    sha256 cellar: :any,                 arm64_big_sur:  "59bdbf22800da5e7641477c9cc3c4905cd94c68526028e5ee41459d36e97ef98"
    sha256 cellar: :any,                 ventura:        "0b5d800b302cabb348253db60dc90af4a62c46e43eea3984afd64798ff0f3c85"
    sha256 cellar: :any,                 monterey:       "6f5d0ebcd3a1396d7fbe53e8fd2362fb84a8f236de4e63c0c60655781c27c437"
    sha256 cellar: :any,                 big_sur:        "776914078a4cb20c69e410ca087bfea9bf9146537ddbaef03aa853565aa2d456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ceeeefde3559573d301c2b1a52a767742a14ae78901ba74baf113973c6792b9f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--lib", "--manifest-path", "regex-capi/Cargo.toml", "--release"
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
