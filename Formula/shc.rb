class Shc < Formula
  desc "Shell Script Compiler"
  homepage "https://neurobin.github.io/shc"
  url "https://github.com/neurobin/shc/archive/3.9.8.tar.gz"
  sha256 "8b31e1f2ceef3404217b9578fa250a8a424f3eaf03359dd7951cd635c889ad79"
  head "https://github.com/neurobin/shc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "38e25464d53ab0273dbe4f801247e2fe3b92c04a8884fe801f6f9551d8a26c5e" => :mojave
    sha256 "64cf435c2c1e79ea37864167731828b712756e6f8069df009031be2337c9e435" => :high_sierra
    sha256 "886bd89bb6c319c5caf2373e581dd6fa5ca11f6fb917b9e3c01ef486682f567a" => :sierra
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
