class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.17.0.tar.gz"
  sha256 "18b8b6ef5ec61fe9c778df1b8691aa9443e710c6f241f1b53d0e67cb1cddae8f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6628b00c2e64a87d12fffab88c1fc329f1e269788c3db3e798dc081bc7cb6e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08557603099a52308289e1e9ec8cd2154bc125eecfed2ba884f127d0b9a8a3a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1855c4f3eca44e351e1a5f5912b65a9bade7284c9b0d020334ad49550f45a6a4"
    sha256 cellar: :any_skip_relocation, ventura:        "b720e133328943f6449e3e9be0cb76cee29e8d613805349e52c4a5a2c918cf40"
    sha256 cellar: :any_skip_relocation, monterey:       "194576ab845114425ed834f3ca14892cbfbcf186022aececf3f9cd0655cc1cc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0dd25a30ecafb4b08cae8df84502a78068b1f8a52a432bacc5a83c7185b0a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dd13d96ef3ba95525d9bec43f96391907fea5af26067cb9566e44b1f91b5be9"
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
