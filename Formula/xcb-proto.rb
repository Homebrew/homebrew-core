class XcbProto < Formula
  desc "X.Org: XML-XCB protocol descriptions for libxcb code generation"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/xcb-proto-1.14.tar.gz"
  sha256 "1c3fa23d091fb5e4f1e9bf145a902161cec00d260fabf880a7a248b02ab27031"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "3a06ab668310fdc796d8cb65b7f1629525c429c4ab557152dc4cd2f6986f6e71" => :big_sur
    sha256 "b517e748dd151eae431d41c7f245a06df71a36f9be201e3b53560df5746bada6" => :arm64_big_sur
    sha256 "ffa4de426e5779c26533a004ea07f4806af7b2c6c258cbb1099ef328f7a44658" => :catalina
    sha256 "ea079de49278e1432c77933a08cbdccab4c0d5d5cccd681c09ea9384b9459a3a" => :mojave
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.9" => :build

  # Fix for Python 3.9. Use math.gcd() for Python >= 3.5.
  # fractions.gcd() has been deprecated since Python 3.5.
  patch do
    url "https://gitlab.freedesktop.org/xorg/proto/xcbproto/-/commit/426ae35bee1fa0fdb8b5120b1dcd20cee6e34512.patch"
    sha256 "58c56b9713cf4a597d7e8c634f276c2b7c139a3b1d3f5f87afd5946f8397d329"
  end

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
