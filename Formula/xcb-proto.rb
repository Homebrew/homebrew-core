class XcbProto < Formula
  desc "X.Org: XML-XCB protocol descriptions for libxcb code generation"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-1.15.2.tar.xz"
  sha256 "7072beb1f680a2fe3f9e535b797c146d22528990c72f63ddb49d2f350a3653ed"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7aff8671654c8a9bde8b257cff31f05a6f09a322f35c16c5d985eb525faae8f2"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]

  def python3
    "python3.11"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      PYTHON=#{python3}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "#{share}/xcb", shell_output("pkg-config --variable=xcbincludedir xcb-proto").chomp
    system python3, "-c", <<~EOS
      import collections
      output = collections.defaultdict(int)
      from xcbgen import xtypes
    EOS
  end
end
