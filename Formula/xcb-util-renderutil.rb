class XcbUtilRenderutil < Formula
  desc "Convenience functions for the X Render extension"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.9.tar.bz2"
  sha256 "c6e97e48fb1286d6394dddb1c1732f00227c70bd1bedb7d1acabefdd340bea5b"
  license all_of: ["X11", "HPND-sell-variant"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d52c308bf4f9bba6c7975638ef05f64967c8af37f05a02d0b684e40ed80324b8"
    sha256 cellar: :any,                 arm64_big_sur:  "7091c73aa3571aa8c4cc2568175f91b3dffe7714dbb1ab334c86da174395d2e1"
    sha256 cellar: :any,                 monterey:       "4a2090d06a94251f761eb18610a4757df663a7ff98f0c7c52a0d492be2cf31f4"
    sha256 cellar: :any,                 big_sur:        "0941200260ef409b5daa61664cad100fe69b08e99b8cb440297079387e2dadff"
    sha256 cellar: :any,                 catalina:       "5fb7ef030a443af89504e74d04fccf3000ac04bf152798e7d4242247e2378ae2"
    sha256 cellar: :any,                 mojave:         "b0a2c992673650129ee49fcb4fbe6873ef4b8d29a5677ae873a27e05fc7a0d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a38fd262818572bab58fd490775a5628a982b510850b0fddc48da6e37077823d"
  end

  head do
    url "https://gitlab.freedesktop.org/xorg/lib/libxcb-render-util.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "libxcb"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags xcb-renderutil")
  end
end
