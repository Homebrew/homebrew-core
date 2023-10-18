class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/1.10.2.tar.gz"
  sha256 "ddd5a9267870129e037a03aa6073bac03308798492c2022c9fa426d264f587a8"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "19ab9501ffcc8b5250787137c9f38c37e2691bf492b57612d518bf4449c4ae1e"
    sha256 cellar: :any,                 arm64_ventura:  "4152216f84ab5dc8e49871893cfd89eab87ee1279846f759fbbadeafe9964030"
    sha256 cellar: :any,                 arm64_monterey: "aed537ac65faeb046151dbe45f04443d1ee20786cc3bf19f3475775a111c5c1a"
    sha256 cellar: :any,                 sonoma:         "e924efc3c31af732f26a676def6b14375fd92b84bea3c4bb799d49fff41bba04"
    sha256 cellar: :any,                 ventura:        "1f8fc5976ab54b6cbaad6868c249540294a98fe3f0534604dfdf7b2352ac3323"
    sha256 cellar: :any,                 monterey:       "1b70f6097b44650661ba5bf4f2bbbe79590aa3c6c48b54d6c49ad52770bc5693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8e7caf36d6d5d0c429792ff6ca4dba890c49fb4056e9077808bbab5b146851d"
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
