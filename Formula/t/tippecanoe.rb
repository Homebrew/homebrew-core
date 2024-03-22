class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.52.0.tar.gz"
  sha256 "f6ebea5c7ec134908265ff1a46a3b0dde8aac9598458ed0bd38c5e40bad16b07"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d63d279b34b470aed1f61edf547d2b355ef27ce207a34acb122ef7e903c744b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "820acaecc173ec1aae256de1102d8d4242694581475642043942f1133c6c90fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb89c58b2c20272912bdc629ae7998e5155b4205280572c98bd0310e061cb72f"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa452ada8d4f05b5c7f79dbd067c0840d89842eebbf2177b6ee5cea8b815b946"
    sha256 cellar: :any_skip_relocation, ventura:        "6e676781053f264498400d7415584775e6bec2a97359e6a898b14d61a103e36f"
    sha256 cellar: :any_skip_relocation, monterey:       "320a267d3ab5b6b12215f99551559a5c9520afa464a1f255830235d3ff30597f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45d6f3a86d2be4c66216be638bf6b4f857c92d92cd23be2153a38f7bd872af2b"
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
