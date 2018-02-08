class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.6.4.tar.gz"
  sha256 "4570ccd111df6b6386502791397906bf69b7371eb209af7d41debc2f074cdb22"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "03220d2a22183b1c52901cf7dd561cbcf5363fae04a8b15786aa2e532a7c20ae" => :high_sierra
    sha256 "9e9722eb7898417811b3930c013ef585a6d1e53f2f693cee4800757bf4f56db7" => :sierra
    sha256 "8d7d413a0165a18c9df428d40fe7ca88c7f841e318f594c29d3daf878fc9c484" => :el_capitan
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
