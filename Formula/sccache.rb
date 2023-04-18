class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/v0.4.1.tar.gz"
  sha256 "b77fb9b9cf67591cb443bc6191c7917e335f8050a3ec477e27104b1e6c99be2b"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73a89110873e0fc9a9393a2f991c3cc61c036154d951f3638079e150a264a47a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a057ab8635a6d6000999239b21f056e25a7ea22e1414c79df563a1163d9c679"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a04e30d02b904f92e74723ce62d22a814542850ef7b8d5e1b2fd5b9e1008ddcf"
    sha256 cellar: :any_skip_relocation, ventura:        "e318a304f08b0b6913f8e88edc9df1421dbc4ff8be0ffcc5d140d4947d637c38"
    sha256 cellar: :any_skip_relocation, monterey:       "8dbf7d0a194ed4d3be8b6d4d87a2afbd93ef1bd9bb9dbf6d8b36c2d696a0dc5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b19215fe15f81af77a8cf141211a4407d996a64e0a43ab3d9e5badd6ed745346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e07e3d97ddb8a81c39f972a318fbf9787f9f8382d92f49389bb879e0e67c981"
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
