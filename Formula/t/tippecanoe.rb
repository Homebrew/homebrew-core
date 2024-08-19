class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.59.0.tar.gz"
  sha256 "5e5acaae3331ae78789f4dba6b9c4c1c6980afb0edcc73bef80f625fb313fa88"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebbd413deaffa586073a9c47e4c96021a5e4fd47c1c89c20b4d033ce7b3e6f74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b455a065681d1d8b9428b5bbc06851a520a8ea7675947850211054fda3d71dee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c095c16b5642fb3a32912450768907f8c0f9d600b9930ea19ec0ea8458fd4f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b4a379456d3ff5cb7c54a9c79f35d70e01d068122bd6756fdc597007a6f90bc"
    sha256 cellar: :any_skip_relocation, ventura:        "f4656a73f6f01dc41a8fed8bbb6eb99441599f33ec258059ef90acedc0814c56"
    sha256 cellar: :any_skip_relocation, monterey:       "04dc5c9543deee2f6e03c4a9d07868bad9caa5d4effc43d3541cc9bc30d5e5c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f76c3c4a90909d368b25752cdb32e3f801436f383c5627254e76e0f587a21f30"
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
