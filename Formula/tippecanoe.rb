class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.24.0.tar.gz"
  sha256 "bc5be791ad74eed596b89f9c423d4c5ed864fabc9aed3e13536251e7862ce49c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f39180ae4293058359a58c9558c89a29488593eefc08984f2d57bb40dfc3ef6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac73127528ecfbf2526c723ece63693a546ffc5de3c617bb6dee4d06166c3e25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f54c77088c737017a1f7ad8b927e2e0702c655c9cf287b5a4c810cc2bad8e90"
    sha256 cellar: :any_skip_relocation, ventura:        "c6191aa2fa5f3fc4da97f5b083ba743bfe52545b99ea3eef01e9195c323bc382"
    sha256 cellar: :any_skip_relocation, monterey:       "c3bffa6fbfbe4d313e6ad67dab716bca4bd37b03fc23df74b76e7eca7da682ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "6eaa742323f101123d319d8662248f8fb5cbee835053495bca1d1248c2e1218d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4682625f3117172615f1647f0146cedb8252f6203000e4d8db42c1e516e8636"
  end

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<~EOS
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}/tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath/"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end
