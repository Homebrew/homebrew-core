class Xorgproto < Formula
  desc "X.Org: Protocol Headers"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2021.4.tar.bz2"
  sha256 "0f5157030162844b398e7ce69b8bb967c2edb8064b0a9c9bb5517eb621459fbf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c561ab188ce76353f6d02629dbb2ca6c0913c22fc8017e26742ceeae5b5ab133"
    sha256 cellar: :any_skip_relocation, big_sur:       "33a7f790f2fa4831f225abf614f98b30d032a0d05a60725135f0c4006f898393"
    sha256 cellar: :any_skip_relocation, catalina:      "386eeca1a9111911f47672b5902a1cc4d7327de7564086b356b5061d0599060b"
    sha256 cellar: :any_skip_relocation, mojave:        "89d2e0e9fdf33b7dc2dbe6a305f02157b1444f1dba53c56eec248d355c8148fa"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "util-macros" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_equal "-I#{include}", shell_output("pkg-config --cflags xproto").chomp
    assert_equal "-I#{include}/X11/dri", shell_output("pkg-config --cflags xf86driproto").chomp
  end
end
