class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "a5f5dacbc8232d566239fa023ce5fbc803ad56af2910fa1558b6e08e68e067e0"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e26f13535c0ff4044041315e4e89c9e4828c1366527d8c035aa78c73639ae1a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf5802c47fa646cf04b6e5835b2c8a2379ed8debcda7eb9dfca3afaf71b59b34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93c3f1e9799e4ec1576eb6851edabfff98374feb4494a8232a4b980264ac224b"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e7ababf956a09307afdbb068ac2e5d769566262126b219b488a3549d609dd0c"
    sha256 cellar: :any_skip_relocation, ventura:        "6b365d27698b863fac3fcf3602e379cb9c2b9bcf94d950ebf39edb60560402e0"
    sha256 cellar: :any_skip_relocation, monterey:       "95281542a91854819a1521e69190c1ef28596ebc7d6cdb67f18c5e70e9d74873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a2390836364399aa36a0897881f1ccf9bd099ab784600765a8e54a2c343191f"
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
