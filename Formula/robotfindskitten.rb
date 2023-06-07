class Robotfindskitten < Formula
  desc "Zen Simulation of robot finding kitten"
  homepage "http://robotfindskitten.org/"
  url "https://downloads.sourceforge.net/project/rfk/robotfindskitten-POSIX/ship_it_anyway/robotfindskitten-2.8284271.702.tar.gz"
  sha256 "020172e4f4630f7c4f62c03b6ffe2eeeba5637b60374d3e6952ae5816a9f99af"
  license "GPL-2.0"
  revision 1
  head "https://github.com/robotfindskitten/robotfindskitten.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "594de510a65fdc1d5e49721661badf9d65c66ffcd6948de794e3aa1ad7de0f90"
    sha256 arm64_monterey: "4b05b5753ba51c24aa690eb643d8abd4b471a4a417e061f3197e9f5ac9fe9b9a"
    sha256 arm64_big_sur:  "be80f51d5ff011ef17235dbd64bca5f1a857e30aca478421555b21a613b73b3b"
    sha256 ventura:        "dcba79e1df56fb0c9dddcdb6d8e361508367f9199fbc37b1ff7a823648beafda"
    sha256 monterey:       "eccc3189c1083ea09ac7a52b2cac91fc2f5a7251523c4a07ddf4bcf9653572e3"
    sha256 big_sur:        "6e95713a4c9a5ace4ece0bcf430b08caaa09876a002964f9ef01ee6fc982d302"
    sha256 catalina:       "fa1f963cf39fb320c4b8e0867a05c9e96944d59d6c18222a9d6b33acb4384622"
    sha256 mojave:         "8b25c148f43ad7c70d43810639b7c812cbd612b347386be3f7e913b4d0cc14b5"
    sha256 high_sierra:    "9c6b045c69a6ff5e74f4f184ec109d3bfd293c7dab223e87ba80e7bb150e8dae"
    sha256 x86_64_linux:   "7d44526e0b657e25b0bec3f36112f6bc9196f8a9a0b74ae2dec9e7b86801abe4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install", "execgamesdir=#{bin}"
  end

  test do
    assert_equal "robotfindskitten: #{version}",
      shell_output("#{bin}/robotfindskitten -V").chomp
  end
end
