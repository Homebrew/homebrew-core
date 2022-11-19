class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/v0.3.1.tar.gz"
  sha256 "7c26ef7047a66393f611172e6323756fc154799f119ee7e407f4a319735da153"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "118a7e2b868bfbc32770e08d334907aaf4263af0393b31f170334733e3a645f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c2bb1cfc38a11498232c978801918c7eb57dcafc0e57e28a18570fcfe755cdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b312d160cddb1199804abe42fea4904c761e34b1cf72d8f201dd5a805b2770a0"
    sha256 cellar: :any_skip_relocation, ventura:        "6c6668a98159ed8dcff40d5b5d74aeb39496c5fe7ee82ee193bed58fa352d4f5"
    sha256 cellar: :any_skip_relocation, monterey:       "4c733f99c6a3188d6498013a1c6a57f6eb44fe5cc8fea1ca453b5f11b0b357f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "65384a2ac93a97f0b80d541d238276f37c268a763d0d3b9b3eea01bdd9c37fe8"
    sha256 cellar: :any_skip_relocation, catalina:       "ad2670b6db38a44618a9665407e01bf158c0b3d609d6deec74f542ef781a565b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb8a0ea26e0a238e7c716c5d1873a0c78b186168384455df4368e8832e99ba17"
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
