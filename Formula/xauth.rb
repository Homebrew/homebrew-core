class Xauth < Formula
  desc "X.Org Applications: xauth"
  homepage "https://www.x.org/"
  url "https://www.x.org/pub/individual/app/xauth-1.1.2.tar.xz"
  sha256 "78ba6afd19536ced1dddb3276cba6e9555a211b468a06f95f6a97c62ff8ee200"
  license "MIT-open-group"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f03feb786d9b9d59d83f3019ae0422946bf2bb2c9a1c87aedb5cafb8d1f6c8b9"
    sha256 cellar: :any,                 arm64_big_sur:  "6eec2379cd9b33ef0a6f43fb987ae5c33f6023c252cdae90ae0c653ad26028f4"
    sha256 cellar: :any,                 monterey:       "53010640b1e9a7aca696d305b3524dd5a1b01a3c60e2963ec40cce547633890e"
    sha256 cellar: :any,                 big_sur:        "dbd7921c13d14ed10d9d011eea5cdf16b44f4019799c072ff492b7aa11063b31"
    sha256 cellar: :any,                 catalina:       "68b0119f7e2d4e4269d7f2ded4657700f2d66d83f3da3bb0a38c9aff94943bd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7fef9c7735f8d5b3405f4ff95bbf749e173a992f4cdbc028372f3356bc2f873"
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
