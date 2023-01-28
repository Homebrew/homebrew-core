class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.22.0.tar.gz"
  sha256 "e1a337ed3454401305df95ab72bd4999b9838caeb954a147f5882ce2040425de"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "768991051633e54783e25fbea11398dc94fca1800f272729dc71bb99ee1a68a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73698f85cf51cf4febdc24beee7429e2c27154e123684513a8d594989f06444a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5c9bcb50d6b0dce2c0a5ff60dd1ddac4716a6a6968278de9e99e9b3483dbd45"
    sha256 cellar: :any_skip_relocation, ventura:        "8263234b91b83cae189ba85fe8f1caf68aaa906669ff5dad47a69688fe18b556"
    sha256 cellar: :any_skip_relocation, monterey:       "a78e316883b8fc464dade5f67d947ec7087b9a684259a92194ecb261caef037c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3abb7752fc44322d69e49c75be29a5809db4afcee694a63132def1ff5f751af1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f5ddf83e99415a454f9c531b0071fd69614cf6cd72978e0549d043ad6ba07ad"
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
