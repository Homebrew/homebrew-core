class Thrax < Formula
  include Language::Python::Shebang

  desc "Tools for compiling grammars into finite state transducers"
  homepage "https://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "https://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.3.8.tar.gz"
  sha256 "e21c449798854f7270bb5ac723f6a8d292e149fc6bbe24fd9f345c85aabc7cd4"
  license "Apache-2.0"

  livecheck do
    url "https://www.openfst.org/twiki/bin/view/GRM/ThraxDownload"
    regex(/href=.*?thrax[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c13867026b97d86192e436f4da236b7dce271a44b21c1b0388cd4aec700adc99"
    sha256 cellar: :any,                 arm64_big_sur:  "fb098c0a6832a09efacef7252d8f472dddfc280c540b8190de18b1ae45b30fe6"
    sha256 cellar: :any,                 monterey:       "653c405ae61061f57f17457657da161ded1ddc39056712dbb7d7dd9643509824"
    sha256 cellar: :any,                 big_sur:        "4a09f5dcaccb60db82d0e034a8ab66b32e01756aa99f72c08531e0d5d3a98154"
    sha256 cellar: :any,                 catalina:       "722203944df85f4144814246f34a3eeaabdfe110b4fa80584ca28b76e4334596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17300c144318201c1ebeafe8cf01bf50ce47ded3a71b98096ae5a94ab98e585e"
  end

  # Regenerate `configure` to avoid `-flat_namespace` bug.
  # None of our usual patches apply.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "openfst"

  on_linux do
    depends_on "gcc"
    depends_on "python@3.10"
  end

  fails_with gcc: "5"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
    rewrite_shebang detected_python_shebang, bin/"thraxmakedep" if OS.linux?
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
