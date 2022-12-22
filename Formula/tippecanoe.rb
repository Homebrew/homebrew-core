class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.16.0.tar.gz"
  sha256 "3e8e5d289621e40294dd9e2a38ff0b7bbaf4db3e8eeb01015bb9a3dc67d03d7b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dacadd8e6223c5a15584f35069ed404dff67aa1f4a9565f4771c0b411478f3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38ed8899a4c1521a75158aa2470f01f630ae585bbd8cd0dd6d978808f0856796"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "003ddb349382042bf4892d656af70ec4b2d37d08e48c42b0c57ebe3bd298befb"
    sha256 cellar: :any_skip_relocation, ventura:        "7cabc7f8b8bac70cca6dfa652fbd99a1c2ad205518a7fc22c41cc4a5daffa1fb"
    sha256 cellar: :any_skip_relocation, monterey:       "f0a310eaa4511db2ee2afe98880b83b56e0e523b4cf05a3b358b3993d47cb4b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcf1d17e4d37965bdecb41ea55b36e6cd96de604c8dc4bc1ec26aacb610a25ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e55c9082f31434d4221d9f6ecaaba3d621630f1f97ea753dd8863da07f8c4190"
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
