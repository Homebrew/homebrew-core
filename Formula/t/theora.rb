class Theora < Formula
  desc "Open video compression format"
  homepage "https://www.theora.org/"
  license "BSD-3-Clause"

  stable do
    url "https://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2", using: :homebrew_curl
    mirror "https://ftp.osuosl.org/pub/xiph/releases/theora/libtheora-1.1.1.tar.bz2"
    sha256 "b6ae1ee2fa3d42ac489287d3ec34c5885730b1296f0801ae577a35193d3affbc"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end
  end

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/theora/?C=M&O=D"
    regex(/href=.*?libtheora[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_ventura:  "b4b1fe0a53ce538d88ca098fce885c20cca62175c2d2141ad96454e7163674a6"
    sha256 cellar: :any,                 arm64_monterey: "56008e9450fcf3f712f34ec79407b8e738953d5fc50feaf72a6434dd28fc1101"
    sha256 cellar: :any,                 arm64_big_sur:  "1e5271cb88e3dad8eb5f06460e7f3f2cec0129679c7f7fb4f84db1d09664b827"
    sha256 cellar: :any,                 ventura:        "cab83d4adc91a223bdc43ca9e26f3a15d37ffcda352be74de313ffe2c1160189"
    sha256 cellar: :any,                 monterey:       "0bdb8acd2fafffff1e172c94aa6f67ce20ea67760d5296ac108ca1ec7e9e4c22"
    sha256 cellar: :any,                 big_sur:        "7ba57255df2c2f4563767031c6b9ead9a93883217644e9e64b5523e26d7b1088"
    sha256 cellar: :any,                 catalina:       "1fcbd50039f580bd85554af2d831c28f83613b5d26969f577f7fe87b3c55db67"
    sha256 cellar: :any,                 mojave:         "6fdb09d75fc6e64b266a185e711c2964e803d8f10c0d40ccb8d572c536c24d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ac10b8e87b29874cd0e6d61de22b1123cbc7757f0eae7e5c195dd8c1ab70ef8"
  end

  head do
    url "https://gitlab.xiph.org/xiph/theora.git", branch: "master"

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
    system ENV.cc, "test.c", "-L#{lib}", "-ltheora", "-o", "test"
    system "./test"
  end
end
