class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.78.0.tar.gz"
  sha256 "da628c5fa1aec3aba318f6096d2f60d8b4cc78043e1c25e18a4d0975c8262f00"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bad7cb29c955e82161443cbb4ceaea5c2f363b916ac39caee6dc1858838c769b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4c6159f9be5c5f8f51086368285c092477e56a9e806c0df5f277c57c4ecc0b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11b91e170f02af2ac3a06abe136ed801a63f992deb9a8a07a643af93175d20e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbc643cdac3193b9aa7772a0673ab05d6cad35c06381d8e83d02c5e3dba17a36"
    sha256 cellar: :any_skip_relocation, ventura:       "fa88fbbf875ed9ea6320eef04a79c900fbf2a75a545582058d475acb2632e9dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea7de77825580f3434355a2a15638bfdecbcfba0ea3deb7289d8ba44d291e517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92a3f5a0750911ebc42d9289149fb924db26add21d1e9080f0423f36e7c741f6"
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
    assert_path_exists testpath/"test.mbtiles", "tippecanoe generated no output!"
  end
end
