class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.29.0.tar.gz"
  sha256 "99b2debc200f8751d6a9e6154e3d3994f07ba5bd8e21f90ee68e27d2467c6301"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c0113c9168b7c2b2aeb811241753ca9644e24790ec6c658343a706f349261c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c3f31fe7ff2776bbe7187f0e251206fa9d78266e57dc1a0d51308f3b19fd267"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08f29b025561bf1616c7c41051acad867039d9f34073b63a641dc93cbea9dc71"
    sha256 cellar: :any_skip_relocation, ventura:        "b22c5974585970f9c1b4d54bb07cd67f316680738c9117d250bc5e371af32a5a"
    sha256 cellar: :any_skip_relocation, monterey:       "1b94d823d9eae54547a06efaf97703f7dc4c65a2802d6321a3446448d34d3233"
    sha256 cellar: :any_skip_relocation, big_sur:        "714d456d09196efb51467052b4cff8bb1c3bbe5572eecbc22f903b6e1d12f903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94d7a458401097a438a196566661f5fc393b8bb21a7ab295d325ecaefb962b64"
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
