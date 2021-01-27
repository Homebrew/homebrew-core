class Python3Requirement < Requirement
  fatal true
  satisfy(build_env: false) { which "python3" }
  def message
    <<~EOS
      An existing Python 3 installation is required in order to avoid cyclic
      dependencies (as Homebrew's Python depends on libxcb).
    EOS
  end
end

class XcbProto < Formula
  desc "X.Org: XML-XCB protocol descriptions for libxcb code generation"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/xcb-proto-1.14.tar.gz"
  sha256 "1c3fa23d091fb5e4f1e9bf145a902161cec00d260fabf880a7a248b02ab27031"
  license "MIT"
  revision 2

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "15460cb7e0d83e7c05e331a98ed4a82e2badb9c337009e8d5fa830d26be113ea" => :big_sur
    sha256 "5c0d6040951956079df0f6c8e58b0ec759dab7b0aebdeacaa05189c1fe0775ee" => :arm64_big_sur
    sha256 "9a4114ec613fb5d8ba41cc43dffb95059bbe7815e812d194ef7c6507281883f4" => :catalina
    sha256 "432ed8c5ad796f9311c34f4bfd3290e42fc132bf0e106ed6e39462ff8d028ab1" => :mojave
  end

  depends_on "pkg-config" => [:build, :test]

  on_macos do
    depends_on "python@3.9" => :build
  end
  on_linux do
    # Use an existing Python 3, to avoid a cyclic dependency on Linux:
    # python3 -> tcl-tk -> libx11 -> libxcb -> xcb-proto -> python3
    depends_on Python3Requirement => :build
  end

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
