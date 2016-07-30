class Shc < Formula
  desc "Shell Script Compiler"
  homepage "https://neurobin.github.io/shc"
  url "https://github.com/neurobin/shc/archive/3.9.3.tar.gz"
  sha256 "b7120f66177a35af7dc42763a55e7ade3a80043c0188739e57bcc648a5ac4bb3"
  head "https://github.com/neurobin/shc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cacc738baf6282ee5f8e65c306f47787fd9a817a2e75f38f91c93640ff6d48f6" => :el_capitan
    sha256 "bbd21d92cd05f24b27b0f5f122565e1ebdc6e61856ea18b293b5438bf3a24aed" => :yosemite
    sha256 "8e78fd63f9e46f1bcdbef8c94f1cebaffec264065e38cca1bfd7003d2d3fd057" => :mavericks
  end

  def install
    system "./configure"
    system "make", "install", "prefix=#{prefix}"
    pkgshare.install "test"
  end

  test do
    (testpath/"test.sh").write <<-EOS.undent
      #!/bin/sh
      echo hello
      exit 0
    EOS
    system bin/"shc", "-f", "test.sh", "-o", "test"
    assert_equal "hello", shell_output("./test").chomp
  end
end
