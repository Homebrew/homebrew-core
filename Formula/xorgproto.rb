class Xorgproto < Formula
  desc "X.Org: Protocol Headers"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2023.1.tar.gz"
  sha256 "c9225c6887b1cb16a762f2e14e7fb56328f53bc5d804e760dcddefc97cc52f35"
  license "MIT"

  livecheck do
    url :stable
    regex(/href=.*?xorgproto[._-]v?(\d+\.\d+(?:\.([0-8]\d*?)?\d(?:\.\d+)*)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96fcce87b3abb944a925410414f45485c1eff6b4275443b1da661910eebd221e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96fcce87b3abb944a925410414f45485c1eff6b4275443b1da661910eebd221e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96fcce87b3abb944a925410414f45485c1eff6b4275443b1da661910eebd221e"
    sha256 cellar: :any_skip_relocation, ventura:        "96fcce87b3abb944a925410414f45485c1eff6b4275443b1da661910eebd221e"
    sha256 cellar: :any_skip_relocation, monterey:       "96fcce87b3abb944a925410414f45485c1eff6b4275443b1da661910eebd221e"
    sha256 cellar: :any_skip_relocation, big_sur:        "96fcce87b3abb944a925410414f45485c1eff6b4275443b1da661910eebd221e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06d438bdcb0972f50e317535e87990749cbefdafa61f9f9749744553ff38a048"
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
