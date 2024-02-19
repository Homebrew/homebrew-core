class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.45.0.tar.gz"
  sha256 "cb21f6605732f296ff6f66bcd4a9dbc18191ed9e4b16f886d0782144b04e7eaf"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "258fc7fa87a85034c70d12e48e12392f1076347b21a21a5846cc337b8414ff3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc1e443e5165d32b287bd515043b94a3b497c8a279f7b70b418cdb32d300c93b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff31c279a5808db8e9dd64533af8cb0ef357d16cdd72db8b004738d48762b30b"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd0be724db25ad69d0a1558d300caac0c2b37876c88e064015270953fc66fd0f"
    sha256 cellar: :any_skip_relocation, ventura:        "25039c78e1080a596c3219d2e94a7664bcb5a81e26fbe2b7eaf00a081d8ba7c2"
    sha256 cellar: :any_skip_relocation, monterey:       "08edc2d03a5c9db8122b7ce3f8e72d55d460ddbd772eb73466c4671cdb84810b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "064ffdf71203faf98c3192cb4fbf297125471b7cf95d28d8d4afac1ad6a6ecb8"
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
