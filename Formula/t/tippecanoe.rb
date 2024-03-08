class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.50.0.tar.gz"
  sha256 "4f89f6512459a79bea222c24c21bcd2e0952ad787f0f579a0f60aefe8282df79"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dfb796336039a758381825ce31ffba22ac1aec1b099384e5ea04ac89037be9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e2541f215ed0ea55622122e710b082c651446cbd2675a847b6dee2746c872c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25526d3f2a8d542bc4eba285bf09ab53d4c73c51753051bd01403b34d51b3f38"
    sha256 cellar: :any_skip_relocation, sonoma:         "506196f2641b4ca81636259c3defe64cca2d86fd2d2ef522882efe354dd91c1c"
    sha256 cellar: :any_skip_relocation, ventura:        "0ec876ece0871897b40e984c48d5dee605ff902c82021e88e4284cfc6c05d79f"
    sha256 cellar: :any_skip_relocation, monterey:       "e9ff859c37c224994de10fd575f7d1e8645e98e43eb87e854212c1af178eef01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35c1862253a7bff9d34c2618a0fdbc90a0d37c52e0cbec83b940b8c39f62feaa"
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
