class Shc < Formula
  desc "Shell Script Compiler"
  homepage "https://neurobin.github.io/shc"
  url "https://github.com/neurobin/shc/archive/3.9.4.tar.gz"
  sha256 "6012301d8708c80702976930988b36c40a2d2194bf6a0398762dd080372f7fec"
  head "https://github.com/neurobin/shc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "323b40cb9bd07a1917f3934dbf6f6aff1aa8876be65a6578c50d5ef6e4402009" => :sierra
    sha256 "8ad113551622db27c28edf78840981b045fcdce0a8afadab7d07459ff6b4104f" => :el_capitan
    sha256 "79f881aafd299978f8c461234ee2b2717d26f674a63f541c82b89800cca84f47" => :yosemite
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
