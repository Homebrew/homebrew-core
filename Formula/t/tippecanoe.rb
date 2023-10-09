class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.34.1.tar.gz"
  sha256 "c71cbb282e7f3f7b617e5706243bc687bdc2b05d009238577a2837da3977a795"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad45c853381ae6a351ed12a668bbf9a41ec4d22058e5c1f426190630f33d22f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce615a3274feae669c5c3ed25966152c73e7e7b1b16d5aa1af555bbe70fc9d47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfdc3b9dcbaea936d4aacee95d6339b02bb341ea3bb5e7b8595b184f2869e678"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d0f4530fc9cf4a8c3d96861984f207d91d2471454391152ecd092ca77ac2d46"
    sha256 cellar: :any_skip_relocation, ventura:        "569a3debf9d76f81b0f763d82724d1cea129c7dbb7e5ac4e3455e10cc186b2f3"
    sha256 cellar: :any_skip_relocation, monterey:       "2be4e3ba4d359bfff57e383f2ea0ec42fc360d6f232951608c127c50d307a90c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "063aaa2764a0f34d7515c7b9e4f06b39cb45ce9d959b95c847584e3dc617a7dc"
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
