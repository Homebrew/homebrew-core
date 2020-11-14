class XcbUtil < Formula
  desc "Additional extensions to the XCB library"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-0.4.0.tar.bz2"
  sha256 "46e49469cb3b594af1d33176cd7565def2be3fa8be4371d62271fabb5eae50e9"
  license "MIT"

  depends_on "pkg-config" => [:build, :test]
  depends_on "libxcb"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags xcb-util").chomp
  end
end
