class Ski < Formula
  desc "Evade the deadly Yeti on your jet-powered skis"
  homepage "http://catb.org/~esr/ski/"
  url "http://www.catb.org/~esr/ski/ski-6.12.tar.gz"
  sha256 "2f34f64868deb0cc773528c68d9829119fac359c44a704695214d87773df5a33"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a5815dd128f1818e43954d76054fb5708afa95cf102b2c3a4fe82aaba6d1e49" => :mojave
    sha256 "b9ae8b2b8ce8c4454bd0690dffc6d90873c4afbc0cf2945af0791a79b5d871ef" => :high_sierra
    sha256 "b7da8676863a5d83104b2fc223b61b49be43d3f18457126053ee98be9ab900fe" => :sierra
    sha256 "b7da8676863a5d83104b2fc223b61b49be43d3f18457126053ee98be9ab900fe" => :el_capitan
    sha256 "b7da8676863a5d83104b2fc223b61b49be43d3f18457126053ee98be9ab900fe" => :yosemite
  end

  head do
    url "git://thyrsus.com/repositories/ski.git"
    depends_on "xmlto" => :build
  end

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
      system "make"
    end
    bin.install "ski"
    man6.install "ski.6"
  end

  test do
    assert_match "Bye!", pipe_output("#{bin}/ski", "")
  end
end
