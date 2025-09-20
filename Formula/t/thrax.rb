class Thrax < Formula
  include Language::Python::Shebang

  desc "Tools for compiling grammars into finite state transducers"
  homepage "https://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "https://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.3.10.tar.gz"
  mirror "http://104.21.44.231/twiki/pub/GRM/ThraxDownload/thrax-1.3.10.tar.gz"
  sha256 "78dedada58a0a8543b4ea90c77a36783ac82495cf5456bec5d83baafac74b764"
  license "Apache-2.0"

  livecheck do
    url "https://www.openfst.org/twiki/bin/view/GRM/ThraxDownload"
    regex(/href=.*?thrax[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ad8474853f18f938c66f2e08a7e97587999b298f56638cbd55cc19f652e1e14a"
    sha256 cellar: :any,                 arm64_sequoia: "1eb8c3d01b8131ea4cc7040397c4eb266c02d517d9076722f322075c93521674"
    sha256 cellar: :any,                 arm64_sonoma:  "b3bfcb2f229d5709774df18f6bd4d4915a03218b430bc4cae498cfc98b387569"
    sha256 cellar: :any,                 arm64_ventura: "87aea2fcc77a37ff7eb3118757a6e224c8e4704a26cae719a8a123bac9b8a3bb"
    sha256 cellar: :any,                 sonoma:        "63a97b5dfbe107ab19a9780f7fd346e421af9ecadc30a0faca9110707cafacec"
    sha256 cellar: :any,                 ventura:       "ea2651cc17ba7837e2e6f362124c9f6c9d06034521dfd86468d4e13220fc9893"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd4e4db424d763840cb2bb05a46a5be7d817ce37e173b99dd3c9e9fe0b234826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da7eb89d693322a62b6409eaf8d21a502d307401726f5f8563695944350ab92d"
  end

  # Regenerate `configure` to avoid `-flat_namespace` bug.
  # None of our usual patches apply.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "openfst"
  uses_from_macos "python", since: :catalina

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
