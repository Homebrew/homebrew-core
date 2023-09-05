class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.31.0.tar.gz"
  sha256 "895c0fd7ecfad4b8a3a3a52c880542421e716621d8c303e5b9d15f586bbd885e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7815e2bf80596479782ff651c2a79ff26cc8643f2122dd9da117c6d44c4efbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20c30da5ea1255b40aa603084d765818d8052db47bc89681b8dca0516ac6df66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23a9b9953485060c61fefeafe6a4d4b29af8782b9dd44e8f2edbd43d17e71d84"
    sha256 cellar: :any_skip_relocation, ventura:        "a8c572a2a01b84ddc34abf99987cd7666814a65d4f74a608fd49928709f666c4"
    sha256 cellar: :any_skip_relocation, monterey:       "900ed8293bac5c0d35fde95f790e8ef7f7735561b5d396f076daebc811a81f82"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bb0c5b8730e38c855c1a8f4aa86504d98472850734e31f72f891edfa48b0645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b50fa01efd42b97c7099adfd1476eb5b28cece84a193080d1b09875b74cfa8b"
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
