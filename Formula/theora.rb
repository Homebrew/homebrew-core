class Theora < Formula
  desc "Open video compression format"
  homepage "https://www.theora.org/"
  url "https://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2"
  sha256 "b6ae1ee2fa3d42ac489287d3ec34c5885730b1296f0801ae577a35193d3affbc"

  bottle do
    cellar :any
    rebuild 3
    sha256 "69f9b7922ddae2c007ad5329d53067838e2208051f3a54926f8cb46a7753b1a3" => :catalina
    sha256 "243d34cb232ae0f7b45d7e2973c247ae68a57d8a4c50a2ee9e2bc7aeeabe5c78" => :mojave
    sha256 "4b5021649d047cbd556387ca6a8bd535cd8f9129be0a48f2d21bde8fb957a3b1" => :high_sierra
  end

  head do
    url "https://gitlab.xiph.org/xiph/theora.git"

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
