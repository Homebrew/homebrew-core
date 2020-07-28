class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.8.0.tar.gz"
  sha256 "7054c3ebd169c97b64a92d7b994ab63c70dd53a06974f1f630ab782c28db0f4f"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "4d4eddfac07b6120a21d489617ef7c365c116c94e29c51479d6ac4795b678063" => :catalina
    sha256 "be9807ccd03b690c5dde0ed30fe5bfdc52dfebff05f9997b4a603a0c5173b3c9" => :mojave
    sha256 "2a373f13868345da95bfa35078e0dc52942bf01bdb6b9d0a1cf84bb8ae001f77" => :high_sierra
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
