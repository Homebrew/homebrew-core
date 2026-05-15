class Thrax < Formula
  include Language::Python::Shebang

  desc "Tools for compiling grammars into finite state transducers"
  homepage "https://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "https://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.3.10.tar.gz"
  mirror "http://206.196.111.47/twiki/pub/GRM/ThraxDownload/thrax-1.3.10.tar.gz"
  sha256 "78dedada58a0a8543b4ea90c77a36783ac82495cf5456bec5d83baafac74b764"
  license "Apache-2.0"

  livecheck do
    url "https://www.openfst.org/twiki/bin/view/GRM/ThraxDownload"
    regex(/href=.*?thrax[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d21f145cc76bc57df426ef5693cc37018225c6756254a40f78a1e65a3de1f3f8"
    sha256 cellar: :any, arm64_sequoia: "1d006e65d56ae1d4828fec2513300a9c6593a39930fd787a922c67e6f361ac0a"
    sha256 cellar: :any, arm64_sonoma:  "da461f0ee541bae3f2801f9db92cb334227fb8f8ff3d1db35f572e0d43493733"
    sha256 cellar: :any, sonoma:        "856ef28235ec1772a3b695f448fae21b7b9f65077b947555cd5e6c0ab006c174"
  end

  # Regenerate `configure` to avoid `-flat_namespace` bug.
  # None of our usual patches apply.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on :macos
  depends_on "openfst"
  uses_from_macos "python"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
    rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"thraxmakedep"
  end

  test do
    # see https://www.openfst.org/twiki/bin/view/GRM/ThraxQuickTour
    cp_r pkgshare/"grammars", testpath
    cd "grammars" do
      system bin/"thraxmakedep", "example.grm"
      system "make"
      system bin/"thraxrandom-generator", "--far=example.far", "--rule=TOKENIZER"
    end
  end
end
