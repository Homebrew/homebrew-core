class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/v0.3.0.tar.gz"
  sha256 "26585447d07f67d0336125816680a2a5f7381065a03de3fd423a3b5c41eb637c"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00cf38a8c23bf93560519b341c0e9844c832e8bbc493729765546f158c1cd7a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4dc37060bcafee2e89b450bd2afef843596e6f59041eb81f22f3aabc9471a78"
    sha256 cellar: :any_skip_relocation, monterey:       "9cccb3f0b35fa0da498e4e243465d4ca3da4c5a05908706298a15628b3456fd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "83af98faab6990a1694651e30183ed5504e171a3b6a3301bbe747db208c42a92"
    sha256 cellar: :any_skip_relocation, catalina:       "dfd1a5dbb28175aec34071f37f2d528bdba5dd8d0a68499b0b646eb0732f4b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64872332a7a554494916287f5716963b93ddf5000d1a662a36f02152929d9c80"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

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
