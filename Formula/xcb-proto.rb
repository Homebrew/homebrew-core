class XcbProto < Formula
  desc "X.Org: XML-XCB protocol descriptions for libxcb code generation"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/xcb-proto-1.14.tar.gz"
  sha256 "1c3fa23d091fb5e4f1e9bf145a902161cec00d260fabf880a7a248b02ab27031"
  license "MIT"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ab62d4a00b0901a5676a904d9d58e263a2c6220d6bb08ea8bcee72ccede7b7e"
    sha256 cellar: :any_skip_relocation, big_sur:       "4059bed377fd405eb7d2da7a550d2cc1fe33facfa2d2b0c1f3b4b8ebb40c70e2"
    sha256 cellar: :any_skip_relocation, catalina:      "2cb7d82e47a13c5e90f1fb8e90eccd596efa140f13d3c34bdf594f2eb07adff4"
    sha256 cellar: :any_skip_relocation, mojave:        "f1bb7552c78b5f0d5adb7085e509c7ecaa6da5afd3bfa865546778e0dcd9a5a8"
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
