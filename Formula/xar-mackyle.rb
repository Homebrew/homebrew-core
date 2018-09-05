class XarMackyle < Formula
  desc "eXtensible ARchiver"
  homepage "https://mackyle.github.io/xar/"
  url "https://github.com/downloads/mackyle/xar/xar-1.6.1.tar.gz"
  sha256 "ee46089968457cf710b8cf1bdeb98b7ef232eb8a4cdeb34502e1f16ef4d2153e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "75fda2bbc38449b34578325d64c2427786a5f39e8dac598e002bdee648f57735" => :mojave
    sha256 "fcca4c13a2fcaade1a8be7ea395849fc2578f466527b7dfc75c7dea97f7bc796" => :high_sierra
    sha256 "192cc85dd14c2f3fcf7900135f3f29363f895f568b07f569a15e1894530d113f" => :sierra
    sha256 "5b81069ab3ea6d376c675affcee92a4809af67c4e7644ea83d8cf7f56134578c" => :el_capitan
    sha256 "498ace8868904d6fdc7f1a74eef8a22e487a2e7178d79b401edb5b00e20cca44" => :yosemite
  end

  depends_on "openssl"
  depends_on "xz"

  def install
    system "./configure", "--prefix=#{libexec}"
    system "make"
    ENV.deparallelize { system "make", "install" }

    bin.install_symlink libexec/"bin/xar" => "xar-mackyle"
    man1.install_symlink libexec/"share/man/man1/xar.1" => "xar-mackyle.1"
  end

  test do
    touch "testfile.txt"
    system libexec/"bin/xar", "-cv", "testfile.txt", "-f", "test.xar"
    assert_predicate testpath/"test.xar", :exist?
    assert_match /testfile.txt/, shell_output("#{libexec}/bin/xar -tv -f test.xar")
  end
end
