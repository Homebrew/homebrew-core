class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.51.0.tar.gz"
  sha256 "bd7fa0b06aac2f487011193cc9b1954ef91fe622ad2926cdd574b6548b818fc0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb6cf50d31bba223a3f84c76983d7fd594f3ee7ba0359dc66b45d3eb29b17736"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b92d9b4e6c6276281d6b7a715db25f915db2b69b88485a68a4216c3ada0e8d6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "732d3ef20fa7b669ae8f24ffba623f34966763b5b06347043f67ccbd0dba5fdf"
    sha256 cellar: :any_skip_relocation, sonoma:         "22d6c990ca9aacea2862d3569b6cbc8d4dd677235c9ede616e305c9d56f32a7d"
    sha256 cellar: :any_skip_relocation, ventura:        "ff5f0773f86424be45b37a6d5304ab3766fedc845ad000c28f3f49b86c91e47b"
    sha256 cellar: :any_skip_relocation, monterey:       "dca340c0179664f7327a18af0d1e175588020cbeda8d3a85bbd4a81bddad42d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ea487dcf711bb320d8e4f83317af9fea74150780a2537b820429d7f1ca83a41"
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
