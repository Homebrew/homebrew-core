class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/v0.4.2.tar.gz"
  sha256 "9e15676ca02e05cb8c5edc222101d2e0049ed3d12b38642830d35844672dbe81"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f84a4f618f36014c84621aaedfeafe248bb7612ba9f78d371811dd1007ba1ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28d0a6127e0f7871af2147b7a569054b34353ea1b3d8e3e7c33993b9b9eaec04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da9ae4128ad1ccb2485baf0e57ae5439345c5cad0cebbe2a4d6f86789ff1f257"
    sha256 cellar: :any_skip_relocation, ventura:        "a80b518abc6400e2c927276eda8c70d86b37c20e102c1e91ccb3da27a825b92a"
    sha256 cellar: :any_skip_relocation, monterey:       "87fdef44199409df113952eb6ff590e8498153aa23e4e21e7a0499a4554c9f91"
    sha256 cellar: :any_skip_relocation, big_sur:        "098c00e9a5c11235d835aaf2280f61e649eacf24de6054d732440bd581e22a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d8c367164f7bb0de23283b0261fbbccca7b57e510a828bd95386ff5d500b6a2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix if OS.linux?

    system "cargo", "install", "--features", "all", *std_cargo_args
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end
