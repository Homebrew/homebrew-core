class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "917fd4d7e584c23dd3cf9ca2f394c2ca03c57c73e2d6079770f07d9008176afe"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf3e36da9812c2e7ca325b3c27650e0bb2e743ddb870410f62b1e47a75820ee0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe257916116c5a8389dec92e7b5a90f727e5f6188d70b4d7af52b3f44b65e8a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c015f6b8748259ce4f0591ac5693db5e15864e39d43b34a25b9b644f2046867"
    sha256 cellar: :any_skip_relocation, sonoma:        "26fe1ccf82a4a93e8b5f373d465eb1f18f8aab3c1140860258530e38ace84a7c"
    sha256 cellar: :any,                 arm64_linux:   "8b87a202f3eef4f1b10cc312e3c9e3157f8fecde7a894cf888b623354cfe443a"
    sha256 cellar: :any,                 x86_64_linux:  "172e661fbcd78508bbc41e25bbebf3cc244274ce0f6267ed130a8b84eb1480eb"
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
