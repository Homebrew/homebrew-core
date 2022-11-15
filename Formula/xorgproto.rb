class Xorgproto < Formula
  desc "X.Org: Protocol Headers"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2022.2.tar.gz"
  sha256 "da351a403d07a7006d7bdc8dcfc14ddc1b588b38fb81adab9989a8eef605757b"
  license "MIT"

  livecheck do
    url :stable
    regex(/href=.*?xorgproto[._-]v?(\d+\.\d+(?:\.([0-8]\d*?)?\d(?:\.\d+)*)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6deb2e4712bdd55eadfdcd7156814a6c42c9d94eb5cda72b89c9e4221a8a99d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6deb2e4712bdd55eadfdcd7156814a6c42c9d94eb5cda72b89c9e4221a8a99d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6deb2e4712bdd55eadfdcd7156814a6c42c9d94eb5cda72b89c9e4221a8a99d"
    sha256 cellar: :any_skip_relocation, ventura:        "d6deb2e4712bdd55eadfdcd7156814a6c42c9d94eb5cda72b89c9e4221a8a99d"
    sha256 cellar: :any_skip_relocation, monterey:       "d6deb2e4712bdd55eadfdcd7156814a6c42c9d94eb5cda72b89c9e4221a8a99d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6deb2e4712bdd55eadfdcd7156814a6c42c9d94eb5cda72b89c9e4221a8a99d"
    sha256 cellar: :any_skip_relocation, catalina:       "d6deb2e4712bdd55eadfdcd7156814a6c42c9d94eb5cda72b89c9e4221a8a99d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7517927867f2f59362eb06cb2b5dda1241a8f2765603197aae24d85b086dc645"
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
