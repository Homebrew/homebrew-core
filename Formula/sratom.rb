class Sratom < Formula
  desc "Library for serializing LV2 atoms to/from RDF"
  homepage "https://drobilla.net/software/sratom/"
  url "https://download.drobilla.net/sratom-0.6.0.tar.bz2"
  sha256 "440ac2b1f4f0b7878f8b95698faa1e8f8c50929a498f68ec5d066863626a3d43"

  bottle do
    cellar :any
    sha256 "68d2e3350e8fc8f53e6f90892c1fd08c0c0929f352970d55f01367ca86ab43e9" => :mojave
    sha256 "7e094cd5a67863974ef62270e7ad71a9b20648bb480b755c4df0e7d35bd04b9b" => :high_sierra
    sha256 "9426748f5689b34336762037f1c594b0284ca071abb64f3abc2a4fd5b01866d2" => :sierra
    sha256 "eec5d4022ef66509c8a5f6b37b772b5a288dfe2986eb58c00da1c69c959306eb" => :el_capitan
    sha256 "e05f2f4d4f22571f883c1a41498aee63bd1afe8227f6817b80c6cc57f9d22bb8" => :yosemite
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
