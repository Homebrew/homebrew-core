class Robotfindskitten < Formula
  desc "Zen Simulation of robot finding kitten"
  homepage "http://robotfindskitten.org/"
  url "https://downloads.sourceforge.net/project/rfk/robotfindskitten-POSIX/mayan_apocalypse_edition/robotfindskitten-2.7182818.701.tar.gz"
  sha256 "7749a370796fd23e3b306b00de5f7fb7997a35fef30e3910ff159448c932d719"

  bottle do
    sha256 "b127f7e5d3e40a3873b6e3070ec1a0b318837ed2fc74d589d917c7c810d62f1b" => :mojave
    sha256 "0a8be5a0e0cbfd167bc18d9f2224610040102e65332dbd5cf3635487345a93d2" => :high_sierra
    sha256 "710b88a647ab9dfcbca6464deff11424fd854cd21e5fe8ae366389c909d8b2ea" => :sierra
    sha256 "ccbdb2706ad962c50eb417530835e651ec00469bef4467033bd1eab3b301adc3" => :el_capitan
    sha256 "c2e72aea983c21ca8a2559d61b9401047d16cead69ee52e75c36aa073b8f583f" => :yosemite
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
