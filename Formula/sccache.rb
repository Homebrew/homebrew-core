class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/v0.3.3.tar.gz"
  sha256 "65275a355e53cd1056768e1cbaad2f48bbaae0917be90b8d4e08128b682a29b3"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "829403fa78216098a3d9933e10ea3cd95c8cca2f7541d88b9f7d0c46e8e36566"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d4c90accbcbbd718a0ec9d2e4ed603a8404d1d4c26ca4c00bd801c173287373"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9af465b092a289742ac34fc5007c9fd0bbdb6822cd98b5b950a85917e4f5ca9e"
    sha256 cellar: :any_skip_relocation, ventura:        "c8bfe081aa9b69e951fef2ab159b681064174ab9ac4c2c8dc83f7633a7441cc8"
    sha256 cellar: :any_skip_relocation, monterey:       "618b9c6652c79eeecac0f1e5f50d727d139cf7b8625524e2309e95661fbfc743"
    sha256 cellar: :any_skip_relocation, big_sur:        "307ba6c064f1d4da85f449497d69283d64cbd4c9dc005b9206e63c9080208dc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d71341458d61b16fa4a5fad083e9f4fefb4dcfea5386312f7ae6b1c56f06bbdf"
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
