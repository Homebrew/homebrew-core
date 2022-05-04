class XcbProto < Formula
  desc "X.Org: XML-XCB protocol descriptions for libxcb code generation"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-1.15.tar.xz"
  sha256 "d34c3b264e8365d16fa9db49179cfa3e9952baaf9275badda0f413966b65955f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "172e8c721816f274068bd9ec31a02ca14f036bb7f55ead5879c67dc42fabec16"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.10" => :build

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
    assert_match "#{share}/xcb", shell_output("pkg-config --variable=xcbincludedir xcb-proto").chomp
  end
end
