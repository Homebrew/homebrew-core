class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "2c9f82c43ce6a1b1d9b34f029ce6862bedc2f01deff45cde5dffc079deeba801"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76044f2cbf1b86123d1ade30aea038d3d336e6c3163c0e9aa3c3b9dae6f2bf33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7899f07009ac8943df04166f75d6f66d7a527ae94dc22d85ed754f293850dbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1095ee95cd648fe084d020f7924ecff7939aef844fd27386130d6136cef69049"
    sha256 cellar: :any_skip_relocation, sonoma:        "21582a47c1d845b38d1b86062dde48a1dd422eec2d4021a37e5c943f0ef587e7"
    sha256 cellar: :any_skip_relocation, ventura:       "859ecb045382d2b2078ad25b63d975bfa949b10bf476cdd81586435a3d3e5d92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43569e48d75f62d92dc6d3500ac738390da87f0e03d9bacd8b2e44a6bc2d373f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b53ed3e9f8745cbfa1e5a6b018225f7e30326af3fecd6701887acc580f1254c6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", "--features", "all", *std_cargo_args
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
