class Robotfindskitten < Formula
  desc "Zen Simulation of robot finding kitten"
  homepage "http://robotfindskitten.org/"
  url "https://downloads.sourceforge.net/project/rfk/robotfindskitten-POSIX/mayan_apocalypse_edition/robotfindskitten-2.7182818.701.tar.gz"
  sha256 "7749a370796fd23e3b306b00de5f7fb7997a35fef30e3910ff159448c932d719"

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
