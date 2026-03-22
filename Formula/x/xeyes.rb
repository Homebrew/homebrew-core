class Xeyes < Formula
  desc "Follow the mouse X demo using the X SHAPE extension"
  homepage "https://gitlab.freedesktop.org/xorg/app/xeyes"
  url "https://www.x.org/archive/individual/app/xeyes-1.3.1.tar.xz"
  sha256 "5608d76b7b1aac5ed7f22f1b6b5ad74ef98c8693220f32b4b87dccee4a956eaa"
  license "X11"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a2b13dcf572f13c49a10369bdf760d82aa9474adfcc1cc64ec8db6c82f14da84"
    sha256 cellar: :any,                 arm64_sequoia: "84fc3b8bdb3491d1c49ac6259c3c2987cbe9892ddff9fad7e591afdc93ebc8b2"
    sha256 cellar: :any,                 arm64_sonoma:  "b7319f0874bbe05866305455f5cbd6178d63b9456a2554a256fafcdbd547f58a"
    sha256 cellar: :any,                 arm64_ventura: "d2cad64fd04a12b745586168365af90c5b8ad72199f03b62606b1840bd0ab3af"
    sha256 cellar: :any,                 sonoma:        "fbaad1c75696ee92be647f7b596c22ec71b343ffea58b66d781e4b00792bc4b5"
    sha256 cellar: :any,                 ventura:       "6ed962d16505a510957f3c90d023a3c867fe647cdd07578fad20e9162e9c0551"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e35e123562991f7b060ee22e52df8d8b0908a608876c749438a30142be86776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d470f3855fad43d746e4cd968d432e06bc2926f1847199c8ed5aee2c9f86f81e"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "libxi"
  depends_on "libxmu"
  depends_on "libxrender"
  depends_on "libxt"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/xeyes -display :100 2>&1", 1)
    assert_match "Error: Can't open display:", output
  end
end
