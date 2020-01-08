class Rasqal < Formula
  desc "RDF query library"
  homepage "http://librdf.org/rasqal/"
  url "http://download.librdf.org/source/rasqal-0.9.33.tar.gz"
  sha256 "6924c9ac6570bd241a9669f83b467c728a322470bf34f4b2da4f69492ccfd97c"

  bottle do
    cellar :any
    sha256 "c815139d0154570fcab0e42ce7244682d13c47c4d4102b61260ffd1d0694d218" => :catalina
    sha256 "61669830b056a2d79757a38bdaa53ea52c6bb84e58dfcff75804252fa12c752e" => :mojave
    sha256 "c9a39d850c71f2ffcc6d0368cb9f575df1a0bd727992dfb553baccc8ecec97ce" => :high_sierra
    sha256 "8d57d6803a7323f9e13c45d56b3cea41f71f7dc7cab493ddf9b34d0a2a6b68f5" => :sierra
    sha256 "fa7368eb30256eb80ead76f7b551bc5980ed15ae8aa655d332a200edb073c2a3" => :el_capitan
    sha256 "c84ec1a4c837b4a30fe597c9cc728f5075764b87978c5977757e2836db3eca0b" => :yosemite
    sha256 "8bef11d9b2763b72cb5576926bd251175c2b0c4c7dec6ffc666f98720341ba27" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "raptor"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-html-dir=#{share}/doc",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
