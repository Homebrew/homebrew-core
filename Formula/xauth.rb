class Xauth < Formula
  desc "X.Org Applications: xauth"
  homepage "https://www.x.org/"
  url "https://www.x.org/pub/individual/app/xauth-1.1.2.tar.xz"
  sha256 "78ba6afd19536ced1dddb3276cba6e9555a211b468a06f95f6a97c62ff8ee200"
  license "MIT-open-group"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "887aa5b806204265a7b1492a6a14c550bfb6e182f60e08e22fd333f3f984938d"
    sha256 cellar: :any,                 arm64_big_sur:  "ab2e13c48d988abfea7724b4e41b4fbb14db314ae802f1d720ee58068af10772"
    sha256 cellar: :any,                 monterey:       "ef65c645298705f261fd277ade0693902141a979c95fcdd80c9ef1e2e52f403f"
    sha256 cellar: :any,                 big_sur:        "7e8d65d24dfb49d88d01433c7d62e20e0cf392cdf76acdeb905eda0e72369439"
    sha256 cellar: :any,                 catalina:       "82fda3853f90ede7a88e637b544cd9e36b59f29ba8a53d6fa52f293483657c80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba603e95a0e62e22545fb3d3f985d5f698289c6dfb66e19f039c33988dac0b97"
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
