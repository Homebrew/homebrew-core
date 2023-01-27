class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.19.0.tar.gz"
  sha256 "aeaae1c7957c31bde5c69b7df70dc50484aa2117498a36ce48227af99490c59f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "518620e79bf9205392b8a49a566354482a454cb7d5debf8ae1679f766de63ac6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a4b84d192540571eac7de682507f184b7f7c46c9288686db0d88f40db2c0c5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "603df4b9a64cab751cfda80f09ba23bd3023c99012f6ee0523c0f857da951423"
    sha256 cellar: :any_skip_relocation, ventura:        "624043d90321320b8dc728b98e4615f392e0f6fd3457aebaf6cedfbe8661b55b"
    sha256 cellar: :any_skip_relocation, monterey:       "180af08586550b89b5535ff4c31224891fee2b53705d0a6d942dbd1ece82a212"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9cbc1ad71d98266cb9de7225cea614c28ede8eecabde8d932f5f40d7cc5e329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef673ed307f550865067a755b42c3835c342d72d0f679927a53e58de3376e5d5"
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
