class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "6e69b88f2f88982dc6389f68a6624b35502b5a2760a6a8a07bdb10a250ed98df"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e4d00962cd674546f2d35d3ab2898f7f5ce73789ba42af8dc20a1c661f01c2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "417f7f28ab9eeb71b96c89f3bc6ceef6c33e1b307f721ee4f5661b1d13e2b790"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b5810a01e8915c95a4051a5d3dd38571c1b2b943d61318d99b17a315a4fba86"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c4a260bff569c03049be751700a28b67882b6d1b0b69db9808cd87195160046"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d0b06edd202fc9c264a6ec9e6252976f2e23355db340cb721aff9087352a3d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dcfa6b6c43646b15a2e89c5ddcc1e7c71032b473a00c1a240bc22ba698b33b0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
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
