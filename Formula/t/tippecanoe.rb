class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.74.0.tar.gz"
  sha256 "c8d0fb75ba50b11d7dae51947683a04a5a946bf1b043cf1aa979b8638ec23079"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "323c598576ca93f5ca0c75b968ff3824a23e00fea7e68943ba5253a5befbd00c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "875601bb2316fc0c6213859a28723840e4a3fd33575b0c1b4d3e7c8eb37bfe13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f3e28dd7833de10760e2ffc04d0f0e19467b3f0db84ecb18cc88feef74f852b"
    sha256 cellar: :any_skip_relocation, sonoma:        "35fc408efdbd0d7cb2b3d0bbc4b37394014da4f81b27827898356b3486531495"
    sha256 cellar: :any_skip_relocation, ventura:       "1eabc16a813383edd20e9c9c549a4ad0bfde8fe72f801272446cf604b8817bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a439acbda7c63784e1013fe9db7ca1f7e81b0e0115cfdc1c3812497f2fef3a7d"
  end

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<~JSON
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    JSON
    safe_system bin/"tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath/"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end
