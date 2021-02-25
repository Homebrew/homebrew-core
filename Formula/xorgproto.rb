class Xorgproto < Formula
  desc "X.Org: Protocol Headers"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2021.3.tar.bz2"
  sha256 "4c732b14fc7c7db64306374d9e8386d6172edbb93f587614df1938b9d9b9d737"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "38c0c8cc1e6439f37d08ae643b338edb4b9fe20870e804060b78bb98515e5e1b"
    sha256 cellar: :any_skip_relocation, big_sur:       "ec193775c03e4473b3d84ef717d2b31904700c8f57db45b37a53c85d01af2392"
    sha256 cellar: :any_skip_relocation, catalina:      "c63919a404e17200e73d19c4f2ab130bb64843bb575d0c542a78a68a60ec88fa"
    sha256 cellar: :any_skip_relocation, mojave:        "7cc2ab60ba641d3e471d50ef6c3e1534179c9d0767cd180c26bccc2493e9cd6f"
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
