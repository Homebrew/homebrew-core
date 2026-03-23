class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "f2f194874e6b435896201655432f623d749f5583256f773743c376a6d06cede5"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d78493b2b4aa6442d30d215533bf5fdc40335e2a441f5528b72bac5a02ce41a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c66dd3515c23a6de299c895d0d66f3d946f358186ee4e7f905c86447f95049c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cef877482d61072478b30067b193cb3d8992d70670f37769aa3deb91e90d4e29"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8423405b506fc8ac1b78060e9cce47ff74f8ef5228ba53682375ccffb69c8be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e04a9be07ddd5016f6597255e03cb892d9ca9e45d40715c55203c324420d5de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "045e12f0c8a7ac055585962e6f9978339d84862c200bca4bd9545d8a07a8fdbf"
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
