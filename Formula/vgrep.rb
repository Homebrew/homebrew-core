class Vgrep < Formula
  desc "User-friendly pager for grep"
  homepage "https://github.com/vrothberg/vgrep"
  url "https://github.com/vrothberg/vgrep/archive/v2.3.3.tar.gz"
  sha256 "062145687d4c33f66b35be15633ff60cd24fd467bf2791f1a8c3ffb069935aa4"
  license "GPL-3.0"

  livecheck do
    url "https://github.com/vrothberg/vgrep/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5006d83eb22993f4cedcfce32b20b59e74526431bc44ea129b11f112f181c9a9" => :catalina
    sha256 "d9fe404e03ea5f5a7cd2709d0d064e4f41fae3f65d66263d242847af25040613" => :mojave
    sha256 "ab0e2c15aa3814e4e6f24c7d86a901fda915e6aa9ccbc7bbaf9d79df73ef91a4" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "release"
    mkdir bin
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.txt").write "Hello from Homebrew!\n"
    output = shell_output("#{bin}/vgrep -w Homebrew --no-less")
    assert_match "Hello from \e[01;31m\e[KHomebrew\e[m\e[K!\n", output
  end
end
