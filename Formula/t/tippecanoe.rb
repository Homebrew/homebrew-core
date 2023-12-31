class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/felt/tippecanoe"
  url "https://github.com/felt/tippecanoe/archive/refs/tags/2.39.0.tar.gz"
  sha256 "8d7fc1609a888072eab1f38e4aac6388e2d53edc8ba4e77d0bd257444147e62c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f452868a56cec6bbebc98fa92821b972b3725eb02c72b1b7ae689432e32f1da9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5321415b042c0f28261e11fb28824a5918d4264df614cb085d9addb0c516a09f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5c2c824ecd090e36d4f4d76bfd1d8a50c7ab238c5a192f210565e5e646a325c"
    sha256 cellar: :any_skip_relocation, sonoma:         "927d2d203849fec11453ed611d1a6c88a4c3a299d13b79daa79d63aa8c3c376a"
    sha256 cellar: :any_skip_relocation, ventura:        "96b65330a521f3035505d996b4e92ae3af70f467e34ff3d456c0d9a4b5364da9"
    sha256 cellar: :any_skip_relocation, monterey:       "0eac5a232889b45d531a7561c56c0aac93fb5b15b4769ac45a00af01f085093b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99a9e2a289e196fb99cc8b1fad0a432472fcf44b4e536cef43aa65a11e3b7919"
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
