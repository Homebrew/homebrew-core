class Thrax < Formula
  desc "Tools for compiling grammars into finite state transducers"
  homepage "http://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "http://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.3.5.tar.gz"
  sha256 "823182c9bca7f866437c0d8db9fc4c90688766f4492239bfbd73be20687c622e"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "a072e3d04f88b542f3b52bc87c2e759c7bab28ae275a82f56f9cb289c5d35361" => :big_sur
    sha256 "df4c441ebe13c259e7ca96811eaa6df1d77aa6da679c1d168a6a783bc156f5d1" => :arm64_big_sur
    sha256 "d78aa60f3cd29ac49ef887d6534a93cfbb605e133514e75681041d0b5744e0ac" => :catalina
    sha256 "6047f5e9d277a6987f580803d7e7220f6eceb76f84805f91aafb5c729bb39f0a" => :mojave
  end

  depends_on "openfst"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    # see http://www.openfst.org/twiki/bin/view/GRM/ThraxQuickTour
    cp_r pkgshare/"grammars", testpath
    cd "grammars" do
      system "#{bin}/thraxmakedep", "example.grm"
      system "make"
      system "#{bin}/thraxrandom-generator", "--far=example.far",
                                      "--rule=TOKENIZER"
    end
  end
end
