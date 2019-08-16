class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.7.1.tar.gz"
  sha256 "afa29766cfc0448ff4a1fd9f2c47e02c48d50be5b79749925d15d545008c3f81"

  bottle do
    cellar :any
    sha256 "ba896fa36c62ca5100bfe8a0e224a8c8af7d780da0f9859f6f3eabcff11f66a6" => :mojave
    sha256 "3e2f2e6993a2655c6bbbc5f8ab269729285dfc176afce79152119c2442e7fbb4" => :high_sierra
    sha256 "462c264c52de48e5d708749bf25859bf22080e3230a8cad3a3e05082ba70ab9e" => :sierra
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
