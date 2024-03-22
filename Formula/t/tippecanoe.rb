class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.52.0.tar.gz"
  sha256 "f6ebea5c7ec134908265ff1a46a3b0dde8aac9598458ed0bd38c5e40bad16b07"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57b04ee2a2c94e9fb09c0fa1be3f5c163593060976d605cef764a54d05989a29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e64f27d57b5509546cdc4c32e93742569632ee5a9a874a21491a93e28901be36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb3319c7690cf782ea9d4ce7bc12ec7caab268cb00ef7b10001f1a3c138876df"
    sha256 cellar: :any_skip_relocation, sonoma:         "93916f0a1ff3f1524e282cf2dd78d859c6e802d99faf59bcfbcef9d8aef98203"
    sha256 cellar: :any_skip_relocation, ventura:        "e082ad13eaa230bf12e40e27f7b0d49c548b2e0f637c69a174b960d4d63a0992"
    sha256 cellar: :any_skip_relocation, monterey:       "ce761925845f0e541e188c337ea9df3f113f0f597d898343b4cbf0d83c5f7390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2bcb4b52a3ce67dad4047c7890be0c1f87a46b3115d8a6edbb0d031fc59f243"
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
