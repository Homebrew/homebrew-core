class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.13.0.tar.gz"
  sha256 "c2401520b43c99dd6f6db361acf3e5c8c309caebf5e1a14d98dc416c3ef61ec9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3595f557af8b85692fd172f12722ebe02ad388d1cd744c39773c5edcbddec36e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad96dbc4f57185439384f946478bc4f4af9f4d33268b92bbe90dd5b04e391286"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d2ee94332f0142b2896696981da60db54c7a3c63681bbeb0325880149124794"
    sha256 cellar: :any_skip_relocation, monterey:       "8d1f391ced1624198acff584ccb5bb856e879c336e23fa46c36313494f6d63ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "1096517502910b571862510ca7052f787d732aba9e1574b1cfb6b1694c2f8c8d"
    sha256 cellar: :any_skip_relocation, catalina:       "e3c03e0f30628ebf97bca5c55c2fc7184d63d878dd8dcedd24d02b94d375b222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3955f7d2cabc2dd735d608b68408588877f668c3625ddde6e605b85efe1a4394"
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
