class XcbUtil < Formula
  desc "Additional extensions to the XCB library"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-0.4.0.tar.bz2"
  sha256 "46e49469cb3b594af1d33176cd7565def2be3fa8be4371d62271fabb5eae50e9"
  license "MIT"

  bottle do
    cellar :any
    sha256 "ca7b806f016b95c52654a351d966ee86e46dcc36339a44921fccc311c1d607a8" => :big_sur
    sha256 "8d86304598d174005688503ce824bd1630482c357aa7de536eafd57d22041054" => :arm64_big_sur
    sha256 "c161b6f0372d40ace1238507365c18a52581b798262c856099cd86eabc38c625" => :catalina
    sha256 "0979f730b01775f3dcb33c093132ec25a49912b99e679e774bae0e995fc3f73c" => :mojave
    sha256 "16578b76b505e33f0ccb428a947e475520d78f4dd7a56504ff9e0af9870793cc" => :high_sierra
  end

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
