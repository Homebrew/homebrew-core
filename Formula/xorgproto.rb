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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59bc0ef6734f03b980c00fed98dd2d607dda9abdfb9a0c0fb3b00ba8b5db26ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59bc0ef6734f03b980c00fed98dd2d607dda9abdfb9a0c0fb3b00ba8b5db26ac"
    sha256 cellar: :any_skip_relocation, monterey:       "59bc0ef6734f03b980c00fed98dd2d607dda9abdfb9a0c0fb3b00ba8b5db26ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "59bc0ef6734f03b980c00fed98dd2d607dda9abdfb9a0c0fb3b00ba8b5db26ac"
    sha256 cellar: :any_skip_relocation, catalina:       "59bc0ef6734f03b980c00fed98dd2d607dda9abdfb9a0c0fb3b00ba8b5db26ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "519566a93bb878a20693502c7feefcad203bc33289c929a478ada9f651d7350f"
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
