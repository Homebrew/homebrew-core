class Yek < Formula
  desc "Fast Rust based tool to serialize text-based files for LLM consumption"
  homepage "https://github.com/mohsen1/yek"
  url "https://github.com/mohsen1/yek/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "9e8dc80daafcadff586cff6d1e3f586e25cd43cd60bc7bbec1ac8b1a96a359da"
  license "MIT"
  head "https://github.com/mohsen1/yek.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f18a291f2f817cd2b491816e5d78d439c4863d087e32d65b2f6c7e0961dc260"
    sha256 cellar: :any,                 arm64_sequoia: "114a34eac48dca76d7bbd602a5a3eb6b97cffe842a49f1488f2254c52b0c0dbf"
    sha256 cellar: :any,                 arm64_sonoma:  "04fab96a3c6afe1f0d5f78b1f9a70648a6c26baa8188d283ada3d81d23389d39"
    sha256 cellar: :any,                 sonoma:        "614d241de14ddcd459f7ea2187703e32130fb16a3c750eb43c7184923f2928f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cdf1724f2e48856a18ccc3a9b283b86b88c207ccf58ecb2be247239e0624004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f89105852e52e309523b70250268f70207536eaeec1db62445cbe113f16b5e64"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yek --version")

    (testpath/"main.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>

      int main(void) {
        printf("%s\n", "Hello, world!");
        return EXIT_SUCCESS;
      }
    C
    expected_file = shell_output("#{bin}/yek --output-dir #{testpath}")
    assert_match ">>>> main.c", expected_file
  end
end
