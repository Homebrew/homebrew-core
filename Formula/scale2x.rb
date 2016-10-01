class Scale2x < Formula
  desc "Real-time graphics effect"
  homepage "http://scale2x.sourceforge.net"
  url "https://downloads.sourceforge.net/project/scale2x/scale2x/2.4/scale2x-2.4.tar.gz"
  sha256 "83599b1627988c941ee9c7965b6f26a9fd2608cd1e0073f7262a858d0f4f7078"
  revision 1

  bottle do
    cellar :any
    sha256 "d6c9c08d16c16c6da5b5acc5e7b2de861c8325d67dd0e9dc0e1a5032ad6cc637" => :sierra
    sha256 "c4d3727b99efa7e329259d5b8bc5e600f034db13e7ddfcbb792f8e512e2b5419" => :el_capitan
    sha256 "ab48af00a09bbb84b1a99cb178d7e2943e51f8ec743b74321ef24a86cc646797" => :yosemite
    sha256 "0ad21fade0671c6139a0d959e5952614fc9b796dee535db443aaa9e455aa766f" => :mavericks
  end

  depends_on "libpng"

  def install
    # This function was renamed in current versions of libpng.
    inreplace "file.c", "png_set_gray_1_2_4_to_8", "png_set_expand_gray_1_2_4_to_8"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
