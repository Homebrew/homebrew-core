class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "49949ad1cf175c49da126dbb0c2e6a56bd9d1f626e8cc0be17b9668b914145c6"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7748b72b00ded7c5a67ec90f096e267efd3405f92d78c529366aaf08304d07a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19686ad7ae3ff94088c8c2cec75a1a4bbcf817b5748d667e47162feef330024b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82bf259c4494b02de912b29598bb9c33679c8b229d383922e9e9723aff891e35"
    sha256 cellar: :any_skip_relocation, sonoma:        "54578793f6d2da4ab0c4ad9609933ae8ecda45650cb688084a47f30eb291867c"
    sha256 cellar: :any,                 arm64_linux:   "53b23e0182080c692ea2cd495a555fde4e5edff0dc9a49a9bdba02414e447f65"
    sha256 cellar: :any,                 x86_64_linux:  "ed0e69f0d6427c6b5610e7a0e0c5dcb3f08b16cc379bfb5aa73a82a42bb0c12f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "all")
  end

  test do
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    C
    system bin/"sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end
