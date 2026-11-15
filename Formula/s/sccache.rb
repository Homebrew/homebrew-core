class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  # TODO: Migrate to `openssl@4` after https://github.com/mozilla/sccache/issues/2780 is resolved
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "2da079033cd19fd8e2a09f56f9a7d9d1a72d591ff3acdc47d95b920145cf2671"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b6bfdee03ac342b05651bd8dfd5ed432ec777c3546a4b30b9551b07d548998c1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7270ad53a598948172dc7603d84bddb80efdced568ea5707fb5b4942cf8aedc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "afe7d11a3ef2dc181b849c73815abeeb13d478768c566b9b1f935dd8711bcd8b"
    sha256 cellar: :any,                 arm64_linux:       "4e916202f37c48ee3c0c30b83d3a77ec0ee30ce42409597569a099cbf0575b3c"
    sha256 cellar: :any,                 x86_64_linux:      "18964bb16d5f0df652ddc0705fdd1687e7c884fa4314a1f1b905bd475879dafc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
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
