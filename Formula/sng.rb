class Sng < Formula
  desc "Enable lossless editing of PNGs via a textual representation"
  homepage "https://sng.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sng/sng-1.1.0.tar.gz"
  sha256 "119c55870c1d1bdc65f7de9dbc62929ccb0c301c2fb79f77df63f5d477f34619"

  bottle do
    cellar :any
    sha256 "f6968419ecf0848134eac6705e33c8fe0ea31696d0aa21a1a530af7767ff2865" => :mojave
    sha256 "b708d5c925acb4986d3cb6af71a2fc25d9ca53b35c3cc7700332513858057786" => :high_sierra
    sha256 "30d9ad9aac3d8aaa67ae524d41bcdfbd92232f053bb0d5ccb3961b811c5b39a3" => :sierra
  end

  depends_on "libpng"
  depends_on :x11

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    cp test_fixtures("test.png"), "test.png"
    system bin/"sng", "test.png"
    assert_include File.read("test.sng"), "width: 8; height: 8; bitdepth: 8;"
  end
end
