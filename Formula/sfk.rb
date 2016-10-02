class Sfk < Formula
  desc "Command Line Tools Collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.7.6/sfk-1.7.6.tar.gz"
  sha256 "14a5a28903b73d466bfc4c160ca2624df4edb064ea624a94651203247d1f6794"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6297dac82e1ed14dd9b2d37a90384113bcd526b93053dd03db0f5154063245f" => :el_capitan
    sha256 "d5be7f90c20799b81c6de1ec6ab2ebdbf8cdad63a551603061a21afde43aab56" => :yosemite
    sha256 "3c8d89606a20039aa02a45614c877dc6d0d6d2365e13cb4e143f7bc99187ba16" => :mavericks
  end

  def install
    # Using the standard ./configure && make install method does not work with sfk as of this version
    # As per the build instructions for macOS, this is all you need to do to build sfk
    system ENV.cxx, "-DMAC_OS_X", "sfk.cpp", "sfkext.cpp", "-o", "sfk"

    # The sfk binary is all you need. There are no man pages or share files
    bin.install "sfk"
  end

  test do
    system "sfk", "ip"
  end
end
