class Shc < Formula
  desc "Shell Script Compiler"
  homepage "https://neurobin.github.io/shc"
  url "https://github.com/neurobin/shc/archive/3.9.5.tar.gz"
  sha256 "b4b36abb2ec8829b6adaf08a8d36d3b0a50103b5809ca788cf0cd5b5011831d3"
  head "https://github.com/neurobin/shc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af67fd885a25116979b7633c359895c87b3e9fa651ecf776303a17659bce1d9d" => :sierra
    sha256 "1223921ffcf26c06d89d36be43f3ebf1404fa7e3b23a2bb561845667a61c64ef" => :el_capitan
    sha256 "fd57edf8ab1d2929a1007dcf9672c0263cddde3d2a9b2245364ed344d8aee650" => :yosemite
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
