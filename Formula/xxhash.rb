class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.6.5.tar.gz"
  sha256 "19030315f4fc1b4b2cdb9d7a317069a109f90e39d1fe4c9159b7aaa39030eb95"

  bottle do
    cellar :any
    sha256 "11e7141e54a5855994b5576b4d95c95a047fde0da5ec158e41c68a6d25695413" => :high_sierra
    sha256 "f48ea5fa26cd2554d1dd28e722302a4d9dffc0f03a6b83bc68de27aa69673729" => :sierra
    sha256 "f6ae33c816af6f5b1e9235410937d977777872ce0656f841d9a2130248c56a26" => :el_capitan
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
