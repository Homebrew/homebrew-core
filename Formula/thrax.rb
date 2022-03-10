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
    sha256 cellar: :any,                 arm64_monterey: "4a2ff8207ecf653a483c97f6968e7cd63e4f37515fc7ff40f3aebbae06179b95"
    sha256 cellar: :any,                 arm64_big_sur:  "f0e606af59de88f830aaf01bba3939b34c67fbe5afa745ce8c0f276ebb8fce7d"
    sha256 cellar: :any,                 monterey:       "078fb8f91d67fc1444f1ce6c75297c381a62fa8caee4696ed216c4db2c088e0a"
    sha256 cellar: :any,                 big_sur:        "b6fb5ed301f1cc233b82efcc07f16c075cb08daafda6c0d7185be7c8db9ff885"
    sha256 cellar: :any,                 catalina:       "5fd16a93c02fee43cb9b1b2e0130e0d56fbbe531dff7dd375c73660cfd372e06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d0e00d373787505de5368a5004a5dd99e71c033628acb12d8872a9ba97a0eae"
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
