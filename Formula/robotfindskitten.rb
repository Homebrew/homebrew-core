class Robotfindskitten < Formula
  desc "Zen Simulation of robot finding kitten"
  homepage "http://robotfindskitten.org/"
  url "https://downloads.sourceforge.net/project/rfk/robotfindskitten-POSIX/ship_it_anyway/robotfindskitten-2.8284271.702.tar.gz"
  sha256 "020172e4f4630f7c4f62c03b6ffe2eeeba5637b60374d3e6952ae5816a9f99af"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f18e0b6bddba41feb96ea70b94bc24b9d66e991471baed046f7c337b42f1af93" => :catalina
    sha256 "61ed19fc71545c4dda1757de56dfb02ac8f6099e723f3755f4014207202a80e7" => :mojave
    sha256 "458ca9d932ef2ca25d6a511fc3f9712a17968ea805f270080e7477cd3ac9fb0d" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install", "execgamesdir=#{bin}"
  end

  test do
    assert_equal "robotfindskitten: #{version}",
      shell_output("#{bin}/robotfindskitten -V").chomp
  end
end
