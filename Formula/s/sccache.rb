class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "14e37fc2cb4f21c188789d518e170181b7cd1ba523152880cdf8009269d79732"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7514e04791a2ecb52bde6e36dc0887114b832823c74a2467b7be76f7f5fa57e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ec8671683abb532a52c1d785a6c8bdcb96d8686bbb3de4406c5bd20450830a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d243d7a06840bceddbb132ccd112543602247b7983004043db760a4ad43a4f8f"
    sha256 cellar: :any,                 arm64_linux:       "720b3cccdc0f75aa4bbc210c59c43bc2b112cf0d98f69ba84fecbd7dfc62f38c"
    sha256 cellar: :any,                 x86_64_linux:      "f5ff4ed8fb405a2cd01f6aca6c98f6042c94c9b1e9eb418cd74e896dd948799a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  # `test do` block starts a local sccache server
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
