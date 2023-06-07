class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.26.1.tar.gz"
  sha256 "2b4ff69b76f5d4ec207ffcfedf1da163d3b403275a05b1d741bdd4746b728df7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "817e83e856cbb8f1c6ed73188e42775e4da5222c0c3f066b5a48f7ba1df8bea3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dc85b05173bdcc4e5d5f22059603f801d1309dd24ecee0bd32ffca5c030f8a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ee7c316ccc65d8a597ea0b2e12d909d310cff616bf799071ccbc31dbe9630f3"
    sha256 cellar: :any_skip_relocation, ventura:        "99744006221e9b6d5a8ea882c301cdc21adf4c6d232e67f5b637794ebd8f8ace"
    sha256 cellar: :any_skip_relocation, monterey:       "fd22fcf520f44337c23651130c5eae8089ffba3d5e6ae25596dbe22659b0397a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4a95269c48ac6c8b389710bb8228fcf9882d83893e1a806be76d7bbc157c2fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16d573ecaa3bcb928ccda334abe76b11f075fde30afe6f27a64c50a861b959f3"
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
