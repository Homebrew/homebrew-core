class Xauth < Formula
  desc "X.Org Applications: xauth"
  homepage "https://www.x.org/"
  url "https://www.x.org/pub/individual/app/xauth-1.1.tar.bz2"
  sha256 "6d1dd1b79dd185107c5b0fdd22d1d791ad749ad6e288d0cdf80964c4ffa7530c"
  license "MIT-open-group"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e8c352b75e7865ef42dcb145e79189427b94212ccbaf524563f956980ff15db1"
    sha256 cellar: :any,                 arm64_big_sur:  "61736627fc5a8de3a4d566d756b851db16848fb10b29dc2c55feb558711acff9"
    sha256 cellar: :any,                 monterey:       "39278f4546e1b1d67243a05c3cb492350d2f5370677d0df80c396d74b0bdeb9e"
    sha256 cellar: :any,                 big_sur:        "1ba364d7d302b895362673b14bebf77ea16c1c5525592499cbc73623508556f9"
    sha256 cellar: :any,                 catalina:       "cd48b1934547120de25f81ba710ccb134ad1d0c3ab14873a4ddb690bd8046471"
    sha256 cellar: :any,                 mojave:         "5f16dfc006000d6d7a747d9454aedee5774f11506bf4b1c6d15dc07e332b8f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7943dee98633ad605c760f993ce115e4a3c3970242aa45d83ae305e277897a8b"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxext"
  depends_on "libxmu"

  on_linux do
    depends_on "libxcb"
    depends_on "libxdmcp"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-unix-transport
      --enable-tcp-transport
      --enable-ipv6
      --enable-local-transport
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "unable to open display", shell_output("xauth generate :0 2>&1", 1)
  end
end
