class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.6.0.tar.gz"
  sha256 "263bd171853b2f668dec20170550c8101215267f72457e68781c2a816e3ccfb1"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "dcfbcd3d7a1ccb8ff72f9d1284b6c2f112d3e59c0301c7fc48475de3c0e7acf0"
    sha256 arm64_big_sur:  "a5e75817810595a60ca9189aae1aabf50999f5bc11011e95f7aedd1e9d511b42"
    sha256 monterey:       "8fb4bff94c43adcdabf24af0452b229181b4501837a84552384971dd2207eed1"
    sha256 big_sur:        "cc703928d1944b1e4bfd28e024f794f83d50de5505c924d53a7fc3de41a5c2dc"
    sha256 catalina:       "8b2d5f96903d1462beb8e99c952685fb2f55b0340f7cec0957a7c71f705794b4"
    sha256 x86_64_linux:   "6c5944f64b148f276047ef0e313bce10d97763e971cfe29e5b0ce2edf139ec5e"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
