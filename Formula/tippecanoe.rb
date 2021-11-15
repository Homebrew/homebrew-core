class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.36.0.tar.gz"
  sha256 "0e385d1244a0d836019f64039ea6a34463c3c2f49af35d02c3bf241aec41e71b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59a82edc1d6b278feb2d5596c97770cbe765f30138c19f5b28660b9f30ff4e62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1e7b5c92a8f50c342c9b288c97e5408e248f402c90143d683d95af53112d601"
    sha256 cellar: :any_skip_relocation, monterey:       "38222ec574d47bf1b88ee3c3118ac0f96722fd86708ca0f7fe12fe0b87da1e28"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdbd5524f4d5fdd7b6495406c8636081c7ffb2eb3a61aa7e5bc6da8bb7edb5eb"
    sha256 cellar: :any_skip_relocation, catalina:       "466aeb229f38b9b549931dab6954786651aa62cd874bbd47b9c28cdb0856cb3d"
    sha256 cellar: :any_skip_relocation, mojave:         "6d5c1d7567f9a1754a93f844fb18168367437dcccbf7fb06efbce5e5ad9a6a56"
    sha256 cellar: :any_skip_relocation, high_sierra:    "2e696df5160edb776144d15805d4baff01db61eb8a5b729bdfd2322095808077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a6bc1030442afe53969482619c9a31f9d9690e227cef2916a0af4d698cf2184"
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
