class Shc < Formula
  desc "Shell Script Compiler"
  homepage "https://neurobin.github.io/shc"
  url "https://github.com/neurobin/shc/archive/4.0.3.tar.gz"
  sha256 "7d7fa6a9f5f53d607ab851d739ae3d3b99ca86e2cb1425a6cab9299f673aee16"
  head "https://github.com/neurobin/shc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "239f2094c8e79dfe1b51d67b4e07b8e8d47b47ac769eae623929d045c1ce6ec0" => :mojave
    sha256 "6ab21bfcf0b7b3b37c6ec3e886e61981b937aeddd67badc8338f35b5b6a3d457" => :high_sierra
    sha256 "bd8f1f3e707ec3dc1d0702059abf4633a9ec8fe97f494dc61181663525afef22" => :sierra
  end

  def install
    system "./configure"
    system "make", "install", "prefix=#{prefix}"
    pkgshare.install "test"
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/bin/sh
      echo hello
      exit 0
    EOS
    system bin/"shc", "-f", "test.sh", "-o", "test"
    assert_equal "hello", shell_output("./test").chomp
  end
end
