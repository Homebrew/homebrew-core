class Thrax < Formula
  include Language::Python::Shebang

  desc "Tools for compiling grammars into finite state transducers"
  homepage "https://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "https://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.3.9.tar.gz"
  sha256 "1e6ed84a747d337c28f2064348563121a439438f5cc0c4de4b587ddf779f1ae3"
  license "Apache-2.0"

  livecheck do
    url "https://www.openfst.org/twiki/bin/view/GRM/ThraxDownload"
    regex(/href=.*?thrax[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "37202fbbf90594ea9f2769f80b28cedbd692f4622d15227ab79901ab632500bb"
    sha256 cellar: :any,                 arm64_sonoma:   "9d668a3b488757d8586f0db1184f6f5df31f6bb9f2630b4115ab04fb17e07091"
    sha256 cellar: :any,                 arm64_ventura:  "cc655cae62d5c58638cc40e1c3f32e9e9ad3ea8741120e4f16418be4f7add2cc"
    sha256 cellar: :any,                 arm64_monterey: "20858036b8aae42f7a46f5829fbe4928d9f6c44058c466495b22ce922261d5db"
    sha256 cellar: :any,                 sonoma:         "62258cde4a11efbf7c314f4df6b4814deeabf3011af0c77d85419ab54e69d9d5"
    sha256 cellar: :any,                 ventura:        "bd252a98a59559a550c44a1119461e12b0aaa3a66047d74f68f137e3f9a67961"
    sha256 cellar: :any,                 monterey:       "0229ee95400fd0ddfefa917c93819a58a51319fd9fcffe1fc03f40949270777d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3938dd9af9f3bc0e161abb79a313b49dec14ac03b056ec046cb5b335489628c6"
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
    # see https://www.openfst.org/twiki/bin/view/GRM/ThraxQuickTour
    cp_r pkgshare/"grammars", testpath
    cd "grammars" do
      system bin/"thraxmakedep", "example.grm"
      system "make"
      system bin/"thraxrandom-generator", "--far=example.far", "--rule=TOKENIZER"
    end
  end
end
