class Robotfindskitten < Formula
  desc "Zen Simulation of robot finding kitten"
  homepage "http://robotfindskitten.org/"
  url "https://downloads.sourceforge.net/project/rfk/robotfindskitten-POSIX/ship_it_anyway/robotfindskitten-2.8284271.702.tar.gz"
  sha256 "020172e4f4630f7c4f62c03b6ffe2eeeba5637b60374d3e6952ae5816a9f99af"
  revision 1
  head "https://github.com/robotfindskitten/robotfindskitten.git", :branch => "main"

  bottle do
    sha256 "439c4c752b9606e645719ca46388b0143a0f3feb6ff248b4fd0d370f3192d506" => :catalina
    sha256 "4bb958df30f8b4d8a46b24f8126404bfb545040c0cafaed7fb14c8965d46c2fc" => :mojave
    sha256 "667bd9a9abd587202ccd8519ace649638e3eeeb859021c2b9f2014ec55f69ea9" => :high_sierra
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
