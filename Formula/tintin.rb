class Tintin < Formula
  desc "MUD client"
  homepage "http://tintin.sf.net"
  url "https://downloads.sourceforge.net/project/tintin/TinTin%2B%2B%20Source%20Code/2.01.0/tintin-2.01.0.tar.gz"
  sha256 "e0e35463a97ee5b33ef0b29b2c57fa8276c4e76328cb19c98a6ea92c603a9c76"

  bottle do
    cellar :any
    sha256 "36071ac3d832a1c61922d2723146a92f69640e66282e793787a9d90988b58a66" => :sierra
    sha256 "87db2f724f02d4904abd62cd1ca64761fc7c036581f002edc4165f304b39c0b1" => :el_capitan
    sha256 "d5854bd2486230a6438a6de890ab23f812248298cdc4d4ab44c3b6b9866b9b1f" => :yosemite
    sha256 "c8af90d6c19c9c8ccb3f09276fbe89f059e9762b36e35e981b2c856f952d12c7" => :mavericks
  end

  depends_on "pcre"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "CFLAGS=#{ENV.cflags}",
                     "INCS=#{ENV.cppflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
    end
  end
end
