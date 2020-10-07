class XcbProto < Formula
  desc "X.Org: XML-XCB protocol descriptions for libxcb code generation"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/xcb-proto-1.13.tar.bz2"
  sha256 "7b98721e669be80284e9bbfeab02d2d0d54cd11172b72271e47a2fe875e2bde1"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "7c153aa9eb525b3d41da64b4ae88809f7d2c1ac8c336a39f82fc06e050e75eed" => :catalina
    sha256 "fff5d96c2df05bcf8bd6f6eabda65555b6eba91f82b5030cd20a2e4817a428ba" => :mojave
    sha256 "eb6e23cf13348b115e842768fa183fd7cc741e4b5fb61c935e87af2a6d2bf2c2" => :high_sierra
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.9" => :build

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
