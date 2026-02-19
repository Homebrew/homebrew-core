class Robotfindskitten < Formula
  desc "Zen Simulation of robot finding kitten"
  homepage "http://robotfindskitten.org/"
  url "https://downloads.sourceforge.net/project/rfk/robotfindskitten-POSIX/ship_it_anyway/robotfindskitten-2.8284271.702.tar.gz"
  sha256 "020172e4f4630f7c4f62c03b6ffe2eeeba5637b60374d3e6952ae5816a9f99af"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/robotfindskitten/robotfindskitten.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "f70167f4ada3ff8ec73fe948560bc08e582be51e57806612ed9d269ce0a1ed7e"
    sha256 arm64_sequoia:  "ea748b3acc46a3b17408ae1f7989c8d37389eb92e9d0d325e66b134136b51904"
    sha256 arm64_sonoma:   "94751d896df7daed821dfd5ba1a5c89c05b9e014f9e44c3d9f5e0f09a9f512be"
    sha256 arm64_ventura:  "594de510a65fdc1d5e49721661badf9d65c66ffcd6948de794e3aa1ad7de0f90"
    sha256 arm64_monterey: "4b05b5753ba51c24aa690eb643d8abd4b471a4a417e061f3197e9f5ac9fe9b9a"
    sha256 arm64_big_sur:  "be80f51d5ff011ef17235dbd64bca5f1a857e30aca478421555b21a613b73b3b"
    sha256 sonoma:         "9b2f45fa85903a46134701d4131609ea2db758843d3f36f93f476cd8713ea003"
    sha256 ventura:        "dcba79e1df56fb0c9dddcdb6d8e361508367f9199fbc37b1ff7a823648beafda"
    sha256 monterey:       "eccc3189c1083ea09ac7a52b2cac91fc2f5a7251523c4a07ddf4bcf9653572e3"
    sha256 big_sur:        "6e95713a4c9a5ace4ece0bcf430b08caaa09876a002964f9ef01ee6fc982d302"
    sha256 catalina:       "fa1f963cf39fb320c4b8e0867a05c9e96944d59d6c18222a9d6b33acb4384622"
    sha256 arm64_linux:    "0d65f446d480696e567673ca1261f700413841a6196dac6bef7535f95727b167"
    sha256 x86_64_linux:   "7d44526e0b657e25b0bec3f36112f6bc9196f8a9a0b74ae2dec9e7b86801abe4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install", "execgamesdir=#{bin}"
  end

  test do
    assert_equal "robotfindskitten: #{version}",
      shell_output("#{bin}/robotfindskitten -V").chomp
  end
end
