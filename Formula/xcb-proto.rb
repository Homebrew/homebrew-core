class XcbProto < Formula
  desc "X.Org: XML-XCB protocol descriptions for libxcb code generation"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-1.15.2.tar.xz"
  sha256 "7072beb1f680a2fe3f9e535b797c146d22528990c72f63ddb49d2f350a3653ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b099b1fb7669fac199978257bcdfe7a9b744809668843e91cea2ca82958c4dba"
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
