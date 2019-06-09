class Sratom < Formula
  desc "Library for serializing LV2 atoms to/from RDF"
  homepage "https://drobilla.net/software/sratom/"
  url "https://download.drobilla.net/sratom-0.6.2.tar.bz2"
  sha256 "0a514a55d6b6cb7b5d6f32d1dcb78a1e6e54537fa22fce533e4ef6adf240e853"

  bottle do
    cellar :any
    sha256 "ec520015be09bdd89bd9081aac42426dbe66fd935a5cc8a71fd9bf64cc971a71" => :mojave
    sha256 "1db4ed5d8d3dd5f85406e8394da49ecab4d8ecca7fafd8e02fb87c76b0e24d3f" => :high_sierra
    sha256 "cb62fd202ce3c33cda2529bc957681ffa70037e99d54df8a81999e890b9fcb65" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
