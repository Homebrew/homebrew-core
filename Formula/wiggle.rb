class Wiggle < Formula
  desc "Program for applying patches with conflicting changes"
  homepage "https://neil.brown.name/blog/20100324064620"
  url "https://neil.brown.name/wiggle/wiggle-1.2.tar.gz"
  sha256 "31375badb76a4a586f2113e49d13486dbc64844962ae80976a81c6542e901622"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebf56026e29b37067218ad4ee2340de46df5b454b46848a0fe2ac117442cfce1" => :catalina
    sha256 "6971993e24c3267d64110bf8ef472bb80db7268a0b85617d3846b66c5f5dbde1" => :mojave
    sha256 "5fe1b56648deb49456c668a2e99d3f7bbb2edf3045d8d55f78382ea008f640d1" => :high_sierra
  end

  def install
    system "make", "OptDbg=#{ENV.cflags}", "wiggle", "wiggle.man", "test"
    bin.install "wiggle"
    man1.install "wiggle.1"
  end

  test do
    system "#{bin}/wiggle", "--version"
  end
end
