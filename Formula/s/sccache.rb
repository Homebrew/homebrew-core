class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "1957c3ec03866cb0196a4dd038faf11f8f6f14d131d9b4c93c9787762360d23a"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "072b28ffce51c48aa728d0b8b10512373de56efe17ea2e49ebfef7d1356176f7"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9714c4d1da1a8ae53ef4fa7903c05674d0bf64f2d16fd4dbe21f60f0c5038f2c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2a2b31dc690d43f5b38b061d4a832f9a802cc06e51c730b81e4d7df44084b6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e40faa671e34c122ebc60bd274a31aeebcda3a216de3cb68d04693e6cf7e35e5"
    sha256 cellar: :any,                 arm64_linux:       "28468758c7876eef4748182ef9b00e0c6f265536f3dc859dd516f9087f9959d9"
    sha256 cellar: :any,                 x86_64_linux:      "bf08a8bfdd0f8e879d1e840d6b95124e9f6523504a49496fb10bbad06debe84e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4" # Uses Secure Transport on macOS
  end

  # `test do` block starts a local sccache server
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
