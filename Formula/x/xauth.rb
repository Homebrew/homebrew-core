class Xauth < Formula
  desc "X.Org Applications: xauth"
  homepage "https://www.x.org/"
  url "https://www.x.org/pub/individual/app/xauth-1.1.3.tar.xz"
  sha256 "e7075498bae332f917f01d660f9b940c0752b2556a8da61ccb62a44d0ffe9d33"
  license "MIT-open-group"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d18d0f0f1e63dde3fc2c20836df3fcab78f1b877ffceaac0093fd1cab3484221"
    sha256 cellar: :any,                 arm64_sonoma:   "9a7b83983740064b18141730a40ffd71feb3d08388a091370f6a82eebbbb78b2"
    sha256 cellar: :any,                 arm64_ventura:  "57ccb291fc8506937db119ac70270ba101733e50425a719a0857ed31abbf3f72"
    sha256 cellar: :any,                 arm64_monterey: "b6f3debf7f9b937e5096c7f8c6996daccfea756ef5186ff90c0c811d37a916f3"
    sha256 cellar: :any,                 sonoma:         "d8b232b84fd17bd7be5ffd8bec34dc8ece296c2b3d83a7ce57baaaa5717d5fb7"
    sha256 cellar: :any,                 ventura:        "d539b3fc84b80a1ffe86cca5f4c3d4244ffdf786a05928ffa8dbc74887f6aa6e"
    sha256 cellar: :any,                 monterey:       "f01f0204c18abd135ab9d1ace74fe55c56988945f68900444439e31d47f63a50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79c33da732dc8f9d89082193869d83fcd79d695ea8cc8f26f1f5e2c743da6633"
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
    assert_match "unable to open display", shell_output("#{bin}/xauth generate :0 2>&1", 1)
  end
end
