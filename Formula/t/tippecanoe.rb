class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.77.0.tar.gz"
  sha256 "4cb152a705250ab37f09d02610df376599c4423efbda96b65ad26f41a966d29e"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c34771632da98e7b086022f8b75a88d55abe5f57927964d362c81cc97b9aaf6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ac89dcc288c13cc205116c990ed137115a4f55285ccc8de4144b8c55bf1a594"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49e2f77aef2ec18f7c59b95196aba7b1c2a496c2804c378bfee7d6c3c10ad228"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d9a866db7aeefd1c2e7e62e6c99ed3ef7c187e114b5410a391e6d183a57ffba"
    sha256 cellar: :any_skip_relocation, ventura:       "5357fb2244b2da01db78e39c51c4128026a0f4b13bef4996b4aba4f7b062bdaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b48940708a98344a7ee8abab6c0b07ed509e1c5a8ef494f6f461cfb4e4b4a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef79dd3a4bb85a9ecf913c69c6aabf7a80a757b0cc30b2824379f61c811b5db6"
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
