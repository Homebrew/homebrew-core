class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.79.0.tar.gz"
  sha256 "b0fd9df49b6efc988288ea48774822c6de19eb48428017f27ee0b3b01d44f05d"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "789f0c1726dbfe2e753ee90977c212738d1435b6217c4d20df7e2e1a6fb09732"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08faa5cd2a23753e7cea762bc9d69c2c3403086a923423158bee845cdf1c4eb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5115543a48645f67a4e3cbf8c545a5c152286df2112def83b2baad49c6fde501"
    sha256 cellar: :any_skip_relocation, sonoma:        "198449b1baacb651f09b763511340e2279ffb817896a52701245d81345eb1abd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bad962c9d0003b05ed245187d525cec015d6e2dcae507f20af3be646394bbfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "facc57688a1d929bef5456e1b2c5298c7ae089ed4e12fe37d46051b818c2d228"
  end

  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<~JSON
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    JSON
    safe_system bin/"tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_path_exists testpath/"test.mbtiles", "tippecanoe generated no output!"
  end
end
