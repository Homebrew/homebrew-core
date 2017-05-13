class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://snapraid.sourceforge.io/"
  url "https://github.com/amadvance/snapraid/releases/download/v11.1/snapraid-11.1.tar.gz"
  sha256 "b9acafeb6cece61fd426f08362b596ba89eea0564231955b82156fd09c0e6884"

  bottle do
    sha256 "62363f69835ce51d827e193abe28ce52296d93f371e9c2882df9e90d54a1863d" => :sierra
    sha256 "7d38569bba0d323e45cc1c078744d605ddb8ed7c01ed4231be22f5046fd6006a" => :el_capitan
    sha256 "256e6e76301b389330ffe051f89c5bc4901917e8dc9987c954c06e7db5429b0f" => :yosemite
  end

  head do
    url "https://github.com/amadvance/snapraid.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
