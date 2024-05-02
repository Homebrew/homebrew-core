class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.53.0.tar.gz"
  sha256 "5f9b1c0c66f6b8df81fd400decabea1232f38828bddfc1a031294d03524f41f3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0d04e55e768c3d1ab126ebebac321d7f655d2aea18e5771b5c1386ea2574018"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0df0a2bf5878a278f39e3d1346ecdcc0a7c1a974f72d22c5a223239ebe58fe62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e037d28751ee4d74d5ebeaa1c5e4a8d40dc3522ea754b26eaa4201548b7d8337"
    sha256 cellar: :any_skip_relocation, sonoma:         "2be06448c66674c760f7a2d135238be58edd744b12313824866e8153e50e175a"
    sha256 cellar: :any_skip_relocation, ventura:        "0eca00b3998b8e60b5951d33e2fc5f44b66403c8afa12769d2c0615a08503824"
    sha256 cellar: :any_skip_relocation, monterey:       "100988a41f920329da8f023e1d0c9d207bf12d281449ef6169ee88ecfa1e1d35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de8dcbcffb25d6fec1185f6c75ea88dfa6ddf8bb7b3e25e5b9de2ec25ef4d9fd"
  end

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
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
