class Xorgproto < Formula
  desc "X.Org: Protocol Headers"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2021.4.99.2.tar.bz2"
  sha256 "c38878053179c6f8bc2daeeeeb4710b5fbf0e46db5b3134aee4a1977ffb06e7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e7e892aa9dfd101f067d5c3e298ccc65bb37c2a7889a0f50ef4e4610b030e00c"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "util-macros" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_equal "-I#{include}", shell_output("pkg-config --cflags xproto").chomp
    assert_equal "-I#{include}/X11/dri", shell_output("pkg-config --cflags xf86driproto").chomp
  end
end
