class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.9.1.tar.gz"
  sha256 "fe3da9575a4e9c7022da7771fc0ff0f6531d4cd7b851dcfc3b3e99233269fbc1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18d2fbd69f9729471fb7e92b21ed0e9dd4bf5f8d494eacb37bfeb8c379383994"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89fae27a94ce412f3b1bcf0cd09238f8d8b15ac2362db1ad4b64f57a65f52841"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cac80b63bde2061e2aaf344ae62fe8916eac49e11588b97072da07049984d3c"
    sha256 cellar: :any_skip_relocation, monterey:       "2a87b3c3712a41c1329c1438d83f83a28e7aaa0663e46572ce4e57c0de90671c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b211d66abbf7f98229819550b0754ce1ed40f66d6449ed933e359eacc69ec193"
    sha256 cellar: :any_skip_relocation, catalina:       "d78951622e9091b45a9a8e4880f5fd1e19bc5c40b5b7cfc4af2339f250708a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cca1fea6fc840451ca09fd77e8ef76f07092a1a21d58141f2d1d04562f37bc72"
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
