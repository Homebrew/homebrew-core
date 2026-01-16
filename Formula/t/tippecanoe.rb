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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41f5baacdcf8fb2a3eecf025c42119d054823382187bbc2aec283d48e4f352aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3c3e2348158de483fb2736c54062b15f60556cd8df3d2ce6dc51887ab10e9b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f03bd4804e1dfd92a168d64780a83fa141071211da196f8dec7ac2c2d5bb7bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6faf6f939872e4aced660fbadbc532a1fe89266160e35605fc3898423759c140"
    sha256 cellar: :any_skip_relocation, sonoma:        "45ceaa42ef046d217a7beb96d03b620204f5409e456419585e5a4f5a9bd2dbc7"
    sha256 cellar: :any_skip_relocation, ventura:       "0be791fe0605b84f8c2f33ac9d544227d7ef8bb8a36396f66c431f851ddee57b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "355ea18747634ebd9f8f60e49e4cee3ba58f1bf2ec636d282bc16371c1d1e525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8548c16fa99ffc64952302b930cc240e2b917fad2e91379b9e8a6eaae05c3461"
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
    assert_path_exists testpath/"test.mbtiles", "tippecanoe generated no output!"
  end
end
