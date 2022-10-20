class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.9.0.tar.gz"
  sha256 "642f2c96af50666c46cadb01c714f802a3ba757e5ce8c4730b9ab4f6be76b4d9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e17e579e69afa79e64b7fac6627f0daf99e50deba491ced836443fb34d6c1bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59cd98c9960d279a490b84232be6d4f610785f945158831c57122f3d09f3f166"
    sha256 cellar: :any_skip_relocation, monterey:       "2e4b4907e085d2949c38d820551a319fe25ab35133280f396f888339d3cb6314"
    sha256 cellar: :any_skip_relocation, big_sur:        "10135cf1e5d570a6657fa43f808d5ef9914ff0cdd4418b80159646e9177ee529"
    sha256 cellar: :any_skip_relocation, catalina:       "758741d1d928a61fe2823e668c2b0ab28b266a8d3c99de4bab28c08bed8de90c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90ab430c34bd5c97031ef9e6f8f42df5bca99014578d7f9dbaace1b3366bdc5c"
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
