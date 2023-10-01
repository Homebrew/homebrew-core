class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.32.1.tar.gz"
  sha256 "3c1936108e372d218c5b7e4acd4b279d8fd6f5ab0a60be033ef8a06ea03af2fe"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36a9cb8c5eb0ed5d5d162122312821b13cd3024705b80b0a325df82c4814835b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57880661273c177a06b6ead754573aa831b3d134f13ca4f14110f8e30c84ad41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "491c9bc7ee38f11e322f0387e3b360fc5966c49a3f9f6e05913d4ee7676c0cde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a64e95d4ad4d4548bbab4bdf2db68270cb6d4339d38b97c470fab1ae96dde54"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0ece3422ed82c2ecaca18fde48e47dbedcd941b4425262a874cb3f328419505"
    sha256 cellar: :any_skip_relocation, ventura:        "dd365939d07c141f5bf0029fc08cde9eb4bc95aae07c32f84217a85b9237b48a"
    sha256 cellar: :any_skip_relocation, monterey:       "e3743d290a5544524d6a4cdd04f021b2fbdcf29097d3215a8c691ba7cc7fd0b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "98c9f674a2c93c7eed450921b1db9538429e89f795b929678f79b6e7fa82dc7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38b01e4e0890b74c7d511b69d56315542debaca3e821a4fcf1dddb86128e1297"
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
