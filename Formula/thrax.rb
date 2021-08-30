class Thrax < Formula
  include Language::Python::Shebang

  desc "Tools for compiling grammars into finite state transducers"
  homepage "http://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "http://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.3.6.tar.gz"
  sha256 "5f00a2047674753cba6783b010ab273366dd3dffc160bdb356f7236059a793ba"
  license "Apache-2.0"

  livecheck do
    url "http://www.openfst.org/twiki/bin/view/GRM/ThraxDownload"
    regex(/href=.*?thrax[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "df4c441ebe13c259e7ca96811eaa6df1d77aa6da679c1d168a6a783bc156f5d1"
    sha256 cellar: :any, big_sur:       "a072e3d04f88b542f3b52bc87c2e759c7bab28ae275a82f56f9cb289c5d35361"
    sha256 cellar: :any, catalina:      "d78aa60f3cd29ac49ef887d6534a93cfbb605e133514e75681041d0b5744e0ac"
    sha256 cellar: :any, mojave:        "6047f5e9d277a6987f580803d7e7220f6eceb76f84805f91aafb5c729bb39f0a"
  end

  depends_on "openfst"

  on_linux do
    depends_on "gcc"
    depends_on "python@3.9"
  end

  fails_with gcc: "5"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
    on_linux { rewrite_shebang detected_python_shebang, bin/"thraxmakedep" }
  end

  test do
    # see http://www.openfst.org/twiki/bin/view/GRM/ThraxQuickTour
    cp_r pkgshare/"grammars", testpath
    cd "grammars" do
      system "#{bin}/thraxmakedep", "example.grm"
      system "make"
      system "#{bin}/thraxrandom-generator", "--far=example.far", "--rule=TOKENIZER"
    end
  end
end
