class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/v0.5.3.tar.gz"
  sha256 "3b1dc8827aa1391161341031e8b9b28e8ab2ce9c508202efe29ff1722d67662b"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2de850c181935b249f3ae4b397a34387434eba53d93c26cd583cb7273060096f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e9a5bd6f001213692839c2eae3aaac01da78398488523f123200cd1d7d478ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2dd7393b503d9380e95b44348586cd13949c69a32d5c0b77bc3a8a76db7bbd8"
    sha256 cellar: :any_skip_relocation, ventura:        "75288467aa3fee8cea9497ee87428871a7237276b892adbc025b2f7c30c4fe62"
    sha256 cellar: :any_skip_relocation, monterey:       "9b5c2d11fc5e77d1178583bd6b39ef8e1c07e2ccef1ee7a69fdeaae2dcdd4d63"
    sha256 cellar: :any_skip_relocation, big_sur:        "007c2161b77266a702e2b7ba8ff60b8f6551f9bb947dcebe6eaf3170c9e25d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a0fdb5d3ff7278d2c60c49186e8e2213ef84b1c9dbc8955fb628eb04d5a352e"
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
