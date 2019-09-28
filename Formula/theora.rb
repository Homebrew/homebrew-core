class Theora < Formula
  desc "Open video compression format"
  homepage "https://www.theora.org/"
  url "https://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2"
  sha256 "b6ae1ee2fa3d42ac489287d3ec34c5885730b1296f0801ae577a35193d3affbc"

  bottle do
    cellar :any
    rebuild 2
    sha256 "463a4a0e66b05ba6e485dedb4a3ce7f9e1f3da92f68c3cdc717fb9ecc9d8808c" => :catalina
    sha256 "0423b3f4858072285691307877ef1899e62e67b67fad2f871e7937d7db572836" => :mojave
    sha256 "8398d6af4942b4201329dffe526d91223ed2f03d39b99c59f16b58907b26b2d2" => :high_sierra
    sha256 "899a793d64a16ea5a18bfe984c8a97966b6c027c258abb026b7d77443849eeca" => :sierra
    sha256 "03b63a91812185120355da8292b40a2afd8377dcd8e3825eb9cbc217a3f4bc79" => :el_capitan
    sha256 "ab9dd77803ec6885cb9701859de9b1b8ff6b85cb7cef24400dec6adb4b8c6378" => :yosemite
    sha256 "58be26743e23be63aee48186bfa9cd8a982de957efb040a6ab3030aa62753977" => :mavericks
  end

  head do
    url "https://git.xiph.org/theora.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-oggtest
      --disable-vorbistest
      --disable-examples
    ]

    args << "--disable-asm" if build.head?

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <theora/theora.h>

      int main()
      {
          theora_info inf;
          theora_info_init(&inf);
          theora_info_clear(&inf);
          return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-ltheora", "test.c", "-o", "test"
    system "./test"
  end
end
