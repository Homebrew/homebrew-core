class Thrax < Formula
  include Language::Python::Shebang

  desc "Tools for compiling grammars into finite state transducers"
  homepage "https://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "https://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.3.8.tar.gz"
  sha256 "e21c449798854f7270bb5ac723f6a8d292e149fc6bbe24fd9f345c85aabc7cd4"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://www.openfst.org/twiki/bin/view/GRM/ThraxDownload"
    regex(/href=.*?thrax[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cc88937f398db52f848b3658c3415073a3cc3a349448f95168ba30b22d0f1689"
    sha256 cellar: :any,                 arm64_monterey: "da67cbb76545ecb423feca1b6a3a6e3dab7251177842ad37e22c5a3f3dbfafa2"
    sha256 cellar: :any,                 arm64_big_sur:  "c5290fa4de107eb9d7c7a283ca01d3e646dc3d14e5add34c4e6187d418af8222"
    sha256 cellar: :any,                 ventura:        "b3c508dac05720ff2b03cf39da71257fe16bd5b863791cb8580fff4788492ab0"
    sha256 cellar: :any,                 monterey:       "510a3aa7dfc3782dfe81735407191ab6ecbc851710dc8d6cd402629dfaef5f53"
    sha256 cellar: :any,                 big_sur:        "1b5fcd1dcc4ff93508ddfcef21e4b280225cb9238766bc40f0551261dd1ea158"
    sha256 cellar: :any,                 catalina:       "da9d875ee86c08a3263d6a7a7b1e2f9465c5811da56893293f387a879a2d5530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7710590e03ff85fbf3a348d90651ca6161f7add1a2b2d986111f7b06c6a96536"
  end

  # Regenerate `configure` to avoid `-flat_namespace` bug.
  # None of our usual patches apply.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "openfst"
  uses_from_macos "python", since: :catalina

  fails_with gcc: "5"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
    rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"thraxmakedep"
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
