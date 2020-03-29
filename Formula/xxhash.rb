class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.7.3.tar.gz"
  sha256 "952ebbf5b11fbf59ae5d760a562d1e9112278f244340ad7714e8556cbe54f7f7"

  bottle do
    cellar :any
    sha256 "a1107115ab0c9389d8cb3d4a351b6b370ef31516aecf4d6970422ea681e5e163" => :catalina
    sha256 "7e5c38f95c934c2f3fdd1cc80259289707e12ada5dead9cf834158f06e1408ec" => :mojave
    sha256 "3a9cc7dcd1ddcb9c1ecc3d953bcaf4617086e3e126b19171c8854cc38c904bad" => :high_sierra
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"leaflet.txt").write "No computer should be without one!"
    assert_match /^67bc7cc242ebc50a/, shell_output("#{bin}/xxhsum leaflet.txt")
  end
end
