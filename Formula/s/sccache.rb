class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "1568b19b3e9bcf911986670dbf92264100974319ddde0b1ccaeecfa82b953632"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "248c32d373641f7e31ca5b1045354f0c8d02c97669be01d22576a3cdb9d76986"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a4d8386abba67e21607b310fb7ca27f6d0adfd10b1908439537c4137171caccb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f8390e6e59cb5e237493f8feb76b323dc6f11ba841e344dce4d41c408b2b09c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e14de5a95969a95807d6b154e8dc63f7740d5d89dc113ae78568ddaf7e7dcbf9"
    sha256 cellar: :any,                 arm64_linux:       "aed28b9da76df973a5c4485c4c8db23a5e17fdc3c58c56657b6a17b503cc86de"
    sha256 cellar: :any,                 x86_64_linux:      "3aacba58c4a7f6f52cb9180eb7dd7fd27874ad439fc69d79d07857d2420444e1"
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
