class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/v0.5.4.tar.gz"
  sha256 "86538bb9e2af88e1e5d519f7a3b6afeac25278eab283ff5a52a715b4f07427ab"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d733c7c8546f3156715d0028dc52e0727d32b281d71fb963112fc703c11a27a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac2903ec9cda82a7d5b2a3d864d905ec9fd2337c8dbba9025e2cded87330403a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "723697c1328ec5f9ca2b6aee4b10e1d0264e9944e58b867f79b52df113473cb5"
    sha256 cellar: :any_skip_relocation, ventura:        "6a17ad3887d4c0368288beb3ec3e5d939660ff40ec6c696ae550ccb18a25cca2"
    sha256 cellar: :any_skip_relocation, monterey:       "5153bf149e9306c678387261b247756ca87501463f2e153a2cdb64fada4e1bba"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9cec04fe81e582e9143ed4ec8a98da324ec18f397d6734533f80ddab2363089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa2c374fa4c09fd929bc493c3a2a8f2dd07168d5204abe60281a4f6b8edecb64"
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
