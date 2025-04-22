class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/refs/tags/1.11.1.tar.gz"
  sha256 "b346bd18b614325bafa15130f5ea0f3fc0712f19f2090069fdc164e3f83325b8"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c5a4892338686036abbec370b25232b93e0c729d9e5ae7f9fb6e0d0fe8b623e"
    sha256 cellar: :any,                 arm64_sonoma:  "87c6daa3212314431070b578bc71d4c859f9730ed787987b9eedd4359e3afe62"
    sha256 cellar: :any,                 arm64_ventura: "dc07b8e0b0ccdc26fde897a2c0c3a13fe962f301fe078bffccffb263328bbfd0"
    sha256 cellar: :any,                 sonoma:        "28f4e15683930a740c5f030306ac769f7671a0d4c32536756f9d096470041933"
    sha256 cellar: :any,                 ventura:       "4de2e95dd8c24f9b16c4f371df152e2e7ac2376bb0e2de16b1ef2fae0abb5d31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49b7ceb0ae53595350deb6fa64b71b4ecb4ae517c2f33b9ffeade35de2f85d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "012c9ed074329023e7b518d7829db5e5020dc92f1ae81872ca41fa8550ed273f"
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
