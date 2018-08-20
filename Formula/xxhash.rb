class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.6.5.tar.gz"
  sha256 "19030315f4fc1b4b2cdb9d7a317069a109f90e39d1fe4c9159b7aaa39030eb95"

  bottle do
    cellar :any
    sha256 "00e30f371e2ca836cecfe3efabe4a488fbf3ddfa61f9aef6b2725f95f39dcd32" => :mojave
    sha256 "283532f22d512db5c2266a64f84a425a0fa3f6048aeb751fcb159df191b70763" => :high_sierra
    sha256 "fedfdf613f1d60af81bb1bc5bbc125249a5ae0d8c6fe0863d677e641b5cad52f" => :sierra
    sha256 "7cbdee7d1220206000efe718a6c599d70142f2ce006e9d6743e1f447cd2d3dbd" => :el_capitan
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
