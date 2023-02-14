class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.23.0.tar.gz"
  sha256 "7e04d04ccce013c32b3f9c1a89a1830ee41ab7be6ad5cecc69462a9c7f882815"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9691d19cf4ebaeb8b0b652f865091ac6ffecb73a418044436cc3e3ca3b404eda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88d7e072f8e2f07a4e530324cfdb80d11a3120b372e48304f230db51b8eeb0ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4bf57862cf0ed40214759ef6c4e1bbcbc5913c6b55e1fb51fe0775774fe93bd"
    sha256 cellar: :any_skip_relocation, ventura:        "0da273f80909e575efc0f295694719de55672fabe8db72c360bb7d87715119a8"
    sha256 cellar: :any_skip_relocation, monterey:       "ce9cb97358f548d45e1353f7e5cf7435eaea2a0c60809a87515c89ed3c1e9b5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a61012ce1a512716d5cc12363b8dfb9f1ab35b648cdadeb7efecc2eaad7958a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b594789dc5bc33508dc27476faeb4c108ec1214488c038e12576d05309883438"
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
