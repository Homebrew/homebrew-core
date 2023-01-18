class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.18.0.tar.gz"
  sha256 "2417c29d649ccaef0a417f5136930c3f6443c66f06f821ea3a7c1af30447cff6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c86fec0705b4c64457a38439b36ec10853cf46960a25214d849812a498d0ae9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6d12ba4002b72e1d46004f798c41e5888d30107b6d8d3a0bbc69b3158664f38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "003848c1e869dbcfa25d30d3d913c24aae6e5922005081762d87817b65269b62"
    sha256 cellar: :any_skip_relocation, ventura:        "1d9d67113f909bd5b97ea5058d5e57e45fefb595d151f02e1557a670b4c26744"
    sha256 cellar: :any_skip_relocation, monterey:       "886551d6908dbaeb7608705aa67fd64d35f6e0f4457385f0f93765bc0009875a"
    sha256 cellar: :any_skip_relocation, big_sur:        "227ba3943c9535918e2e69b1d50659fa89ceb32d6d808765c68504b27feb3fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab939f21ef8c4d7ceb8ce2851355c031ad41cc29f0334493983fb9c961d56565"
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
