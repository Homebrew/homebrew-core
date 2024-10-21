class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.65.0.tar.gz"
  sha256 "00f4c9104f89476bfa404777a844bad9beb9922e479e2c433e9569c865893cf8"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9508ac9d933db0489fa4d0031de6ee419790090897820961c297596f1cdfb0a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d51fefbbafe8d1d0ecde602122de74ee30d6f070152d310834b13ce1acd0dec1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be23e6a5ac21f3b23fcd74c8f9c3950f7dad526444895940f96f1d64e17f6863"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f414231fc068522ea9b1e3aeefeba5594a9a8e2631af06eaf1dee20a4935383"
    sha256 cellar: :any_skip_relocation, ventura:       "6f4ab779a321789889db4c90337b7b4605aad07dfbfa76f8cd92d01093453ddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c32618a1d67e93c75fc822d9cf6d0bf6faf310b773d07f00128ea482846d5d14"
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
    safe_system bin/"tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath/"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end
