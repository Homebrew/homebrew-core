class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20190710.tgz"
  sha256 "048b4078003c588ad2ee3202468576df7dee16914df0f663fc6dd5bb49526303"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ff835e1beb71c0e221c87be184b6afdf1c8d6cb050c8d8f0d9d22b46c5df88f" => :mojave
    sha256 "6a3972df6f5ab23fb7480ffda28b8b1e8059854b837f1c947744e5dfb542c6bb" => :high_sierra
    sha256 "360d6eaa04e1a147eee360fed7d66ab779acc0a0ab3b51b1916cdf4d4a7f11f1" => :sierra
    sha256 "e758b4d59d1322b736f247c9ebbabe3c73ad06b324120997c6af784b8a3ab3f7" => :el_capitan
    sha256 "2584fb77678acad877286416b79db38673320ec028e6a6add37b987b150af648" => :yosemite
    sha256 "e2faf045a9a09d49e64f104bf65ca7a8fabf4552a50621bd22206e80ef579844" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output(bin/"vttest -V")
  end
end
