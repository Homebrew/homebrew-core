class Robotfindskitten < Formula
  desc "Zen Simulation of robot finding kitten"
  homepage "http://robotfindskitten.org/"
  url "https://downloads.sourceforge.net/project/rfk/robotfindskitten-POSIX/mayan_apocalypse_edition/robotfindskitten-2.7182818.701.tar.gz"
  sha256 "7749a370796fd23e3b306b00de5f7fb7997a35fef30e3910ff159448c932d719"

  bottle do
    sha256 "5eba0572a63480f072944448df0f8c309abd05e8b7c5d9cdb954c3758b165f48" => :el_capitan
    sha256 "bd32a237e6402d69f88da12ac0e4ccde9a3663c73f8b078649752cbcade0b479" => :yosemite
    sha256 "fc55bd723a4f3ea7a105ba2d8d74234adc077129e218f4295cae1d40ae42d125" => :mavericks
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
