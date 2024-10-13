class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "2b3e0ef8902fe7bcdcfccf393e29f4ccaafc0194cbb93681eaac238cdc9b94f8"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03c9225e0e31879bf3ccbd68790a3d9827097be7f350116e15383a0928cd3120"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a92467361c756770c553b1199e3f45ace1a809afff888c674582af984a95b3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da6f81c594991203232eeddc36554e63d5b70ac7c6a869be4ae499e6c451e2e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8770becca139afcdd082429a14919758a9f24f48552b6cad05f1712a3f2bd3be"
    sha256 cellar: :any_skip_relocation, ventura:       "56142a6a5f62aad1bd1aee1db0b4c1ab2bf3170b3b1b7cabe372214c88a08d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19eb01412ded79a71a508a3c727541921720b8d543ef7f021749c8f5b37fbcc9"
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
    system bin/"sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end
