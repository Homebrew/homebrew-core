class XcbProto < Formula
  desc "X.Org: XML-XCB protocol descriptions for libxcb code generation"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/xcb-proto-1.13.tar.bz2"
  sha256 "7b98721e669be80284e9bbfeab02d2d0d54cd11172b72271e47a2fe875e2bde1"
  license "MIT"

  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.8" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      PYTHON=python3
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "#{share}/xcb", shell_output("pkg-config --variable=xcbincludedir xcb-proto").chomp
  end
end
