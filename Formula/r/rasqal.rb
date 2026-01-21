class Rasqal < Formula
  desc "RDF query library"
  homepage "https://librdf.org/rasqal/"
  url "https://download.librdf.org/source/rasqal-0.9.33.tar.gz"
  sha256 "6924c9ac6570bd241a9669f83b467c728a322470bf34f4b2da4f69492ccfd97c"
  license any_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later", "Apache-2.0"]

  livecheck do
    url :homepage
    regex(/href=.*?rasqal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "2ab423879b5e055a6e0895821440d428dd3d9c03becafe542a15b76072593e88"
    sha256 cellar: :any,                 arm64_sequoia:  "de698e3a83cb5fb348934c69dc81af3013e0cb60a4a8a94a53963554eaf8b2b7"
    sha256 cellar: :any,                 arm64_sonoma:   "f1a8b465f57865a1b0fa9ea84f1388f14f778eedb6cd4b4a651a7d2d0bed18af"
    sha256 cellar: :any,                 arm64_ventura:  "92f1cc01dd0623dedfb4b823b7b483e53158436fd1f19f31c743429cf63e9028"
    sha256 cellar: :any,                 arm64_monterey: "df52f08c6ed78c573f5230851d5faf543be79ebdbf6d308f9911739c9c898f53"
    sha256 cellar: :any,                 arm64_big_sur:  "36d9d4a210921573c1cad68bc17bf0d0fced251de091855ce1b61cefc64a37c8"
    sha256 cellar: :any,                 sonoma:         "97c29aa6b456f813e036331227ea231fd361def3bb5c85feebbab6c0dc4dd3cd"
    sha256 cellar: :any,                 ventura:        "b3c70287723dc5ba946ee2ec128b443652a1ae3b30c82e1205547e3840a7b374"
    sha256 cellar: :any,                 monterey:       "8f0d23af21ab8a802e58d7f6b31234411ccb492884d9a87eba8205be79ce6899"
    sha256 cellar: :any,                 big_sur:        "14c26a4f0d108107281be78dbca4948b52a3ff157fb2dd33bdc123b2a467c492"
    sha256 cellar: :any,                 catalina:       "c815139d0154570fcab0e42ce7244682d13c47c4d4102b61260ffd1d0694d218"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d767881b0338446f5c5d2256e184167071d10cacc05bea13a78dc009ec891fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2267d3f39fc7d088095d64bb6cf86f5fcad6c2a72fdd72dde8237cc910b123d1"
  end

  depends_on "pkgconf" => :build
  depends_on "raptor"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--with-html-dir=#{share}/doc", *std_configure_args
    system "make", "install"
  end
end
