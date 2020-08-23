class Robotfindskitten < Formula
  desc "Zen Simulation of robot finding kitten"
  homepage "http://robotfindskitten.org/"
  url "https://downloads.sourceforge.net/project/rfk/robotfindskitten-POSIX/ship_it_anyway/robotfindskitten-2.8284271.702.tar.gz"
  sha256 "020172e4f4630f7c4f62c03b6ffe2eeeba5637b60374d3e6952ae5816a9f99af"
  license "GPL-2.0"
  revision 1
  head "https://github.com/robotfindskitten/robotfindskitten.git", branch: "main"

  bottle do
    sha256 "fa1f963cf39fb320c4b8e0867a05c9e96944d59d6c18222a9d6b33acb4384622" => :catalina
    sha256 "8b25c148f43ad7c70d43810639b7c812cbd612b347386be3f7e913b4d0cc14b5" => :mojave
    sha256 "9c6b045c69a6ff5e74f4f184ec109d3bfd293c7dab223e87ba80e7bb150e8dae" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

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
