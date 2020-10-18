class Xorgproto < Formula
  desc "X.Org: Protocol Headers"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2020.1.tar.bz2"
  sha256 "54a153f139035a376c075845dd058049177212da94d7a9707cf9468367b699d2"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "12227628c023328dc1c2c4d4be43c3170e9b2eb31d2be792b091ea8d21ec0619" => :catalina
    sha256 "5a66e9fd1485b634bc2d5821258599e9fd30dcc6b372862c927501330eba8c8b" => :mojave
    sha256 "3d1c8d8aa28541dc4b6f1d2f05c5472494834ef4e0fadf6545f5728ea048fb9c" => :high_sierra
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
