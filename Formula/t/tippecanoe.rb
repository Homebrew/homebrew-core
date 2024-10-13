class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.64.0.tar.gz"
  sha256 "5f352793cee4f2e29d0bc53a144f04b1bf35f65f900bad952a1d14b5ed79bad6"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeccc217fb67ef9a3ba5a393c1a3a048ba2579437adcc98f3e428a6b1a378ec9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b715be7e4f0376fb911384b1f65507b0974bcc7a9fc23b7c7c795e91fdf1ca8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "217804e4c1ea1f3427dca9adb5105b90b7484bda935d72ce7990602efc371bd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fea7763e62a63501cb40e3ba10e10561dea8479a2741189f1a6f448d5461c675"
    sha256 cellar: :any_skip_relocation, ventura:       "89021d22a4923fc6f4ee38d2a1588d81156791cc626a8239296f158819f1ec7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab69759ba8f5a960a8945378b1024e428169da8f2ab538cf59a1b082da5a21c7"
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
