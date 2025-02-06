class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.75.1.tar.gz"
  sha256 "892418c5c742cf371b7a66c5c8ce10fad9f922fc73f24fc07c6c05ac519445c1"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abce238923ea9726b6c84d5150506269427ed181bbf5d94d1201665ca2aeace2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d53eb3d07b66debaac2afab0d5b081cbced6705c303e5f2b569ec7303413ff6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ece488b85e1bacbfe9579429247c98cf08ac282620c09099502b6c294352044"
    sha256 cellar: :any_skip_relocation, sonoma:        "23d31d892c071f014cd90332f35209e383b2c60250740d4da64caea98207913b"
    sha256 cellar: :any_skip_relocation, ventura:       "f5a55493c51bd504c3b668422118793285e3efcbfab5f70c2c530ebc44eb2f01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c05e823842ce8e363f4c4a3faeeae9eb8b716ecf6fbadf5c97b6d8d3868281b"
  end

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<~JSON
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    JSON
    safe_system bin/"tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath/"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end
