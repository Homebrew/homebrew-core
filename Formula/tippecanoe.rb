class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.15.0.tar.gz"
  sha256 "b8ee262cbae337960cc9757e90b42f14107a8cb78e82fa24463982439ad9cd75"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "349815a159b6ddbc71b26afefbb5bca643313e24fbef430464a0d53ea6a9ce72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "540cfb03a05debd70c6a17bb33f2f616825a88028bf0572089021b8c0bd4276b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46f310c9dbf1472d00f7a2432015abb95ba97104b12717eb3196e1e36eb59975"
    sha256 cellar: :any_skip_relocation, ventura:        "11625dfca95d1a551413ffe0cc7ec8fa8f87433b8d830646555ae3a931f33975"
    sha256 cellar: :any_skip_relocation, monterey:       "4ea0db99f8399155b26edc7bc67aeb7ca1cc7c0e30687b3a631b3c76fe4115a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c6160e2e957afc642dee95a6a1c5475be019a87b585b1d8cb855c56591c8fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "249185978aeddd41aed9e49eefc4bc57902c034b7f903a5986d52e036bfcbad8"
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
