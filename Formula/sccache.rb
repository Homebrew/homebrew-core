class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/v0.3.0.tar.gz"
  sha256 "26585447d07f67d0336125816680a2a5f7381065a03de3fd423a3b5c41eb637c"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03a2718de73604db1bb56de5d585fb61b5d6d2c8a7eb16c066124cd3d476bd23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c13133e66ad27fb4bfc33cdfec0b567c30bf198582e6efb0b7531f598eef6d80"
    sha256 cellar: :any_skip_relocation, monterey:       "ae8579e33a6b89749bf11d7853911ad09e061e442a580f6f842afed2b31bd99e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f029209a8e6c5621a9470e77f5d262aa90550b5a8eae847268dbc8fcf4da84d0"
    sha256 cellar: :any_skip_relocation, catalina:       "1d01fc0f2cf10b9d70836ecf04b63f88e118ee7e5aae12db60a22b1a7e923299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f216377a2f2f7264425125ba4e355595742c1335c3844930493dd4737a4f4c0d"
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
