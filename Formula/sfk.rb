class Sfk < Formula
  desc "Command Line Tools Collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.8.0/sfk-1.8.0.tar.gz"
  sha256 "933e0ce2b870a0d5ea2104064f664ada95a709e5685ba3c79d4b2a16ac65da4a"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6297dac82e1ed14dd9b2d37a90384113bcd526b93053dd03db0f5154063245f" => :el_capitan
    sha256 "d5be7f90c20799b81c6de1ec6ab2ebdbf8cdad63a551603061a21afde43aab56" => :yosemite
    sha256 "3c8d89606a20039aa02a45614c877dc6d0d6d2365e13cb4e143f7bc99187ba16" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    # permission issue fixed in version 1.8.1 (HEAD)
    chmod 0755, "install-sh"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
