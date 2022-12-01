class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.14.0.tar.gz"
  sha256 "9f7f9a2e4a7cdd2c5535622d63ae347f83c9eb212f74b2a0fb0622e4bc952690"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85158cf0490bf3f623c2dbdb48f816df927add8f358156f4e17cf9003d7950fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "856ef3867257027ca66acdbfb0001264f8b535c3fef2456c15536c66bdcbd6fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ad8374defc28bfc70f0463e5107fc3f11601e574201f0e563bcc96ea5c97d5c"
    sha256 cellar: :any_skip_relocation, ventura:        "5d17ed3dec32f4c38c8ac46328e32980e6c6e2e296e1c362e0b4a96cd336ac2b"
    sha256 cellar: :any_skip_relocation, monterey:       "bc526900de024d24a4d3afb45ad442b1e0cf65cebd4a947e6ccae251185852db"
    sha256 cellar: :any_skip_relocation, big_sur:        "31b001c7673f605c8035b17cee0d83717549278e838e865c6dc748e050d9a13f"
    sha256 cellar: :any_skip_relocation, catalina:       "805b74422744b9a2593cf2dd5ac30fa2d0ec727c6f7edfb53998581a1cee379d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "808d5501c0019b8c9c616b9596e6fc681f4d6fa9a2cf4d8fa3b211ee81f1e42e"
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
