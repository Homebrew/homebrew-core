class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.55.0.tar.gz"
  sha256 "2e1ca50d456b22ff33e3496678f6fd753bf1caadcdf937b9130e3c7051cb928e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f0260ec13ad40433f430be45dcd17edd10a2b531427980a0ae3fcb5cef5e4e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b9620cc51a4d78e260ea896c2c3de06ab13edfe22535dc1ed1f50eb09715c70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "380e70d28c67aff1007a1fc4d8df4e07a6e64bd9f35414cc47a57d7a4d64a1c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "82d9113b99371cc4e97c1a4c025e9dd89fc7e70f39165a65710fa24f30cae2cf"
    sha256 cellar: :any_skip_relocation, ventura:        "ffad807da292bb1a63d80295fbc9903ddb6790aaf12f5f03b3053af6f4e73f6c"
    sha256 cellar: :any_skip_relocation, monterey:       "d88e65da96ee0e218616c879703a5ceb15b6a473e690f31f84b404ae13149ef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c799cd3aa2d81d33324ba180f8f98e03422dfc3c5313eb4115c4eee91266d48e"
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
