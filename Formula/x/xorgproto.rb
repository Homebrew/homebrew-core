class Xorgproto < Formula
  desc "X.Org: Protocol Headers"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2026.1.tar.gz"
  sha256 "7fa90e48cbaca6bc4c99d176e88c5c147ab0ed42358e14a0869ee9c8a610ae7e"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/href=.*?xorgproto[._-]v?(\d+\.\d+(?:\.([0-8]\d*?)?\d(?:\.\d+)*)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8327b24ee8a0d4b3cd9dfb6d49eb20a80484c0f25535be6e726d1b908f444514"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8327b24ee8a0d4b3cd9dfb6d49eb20a80484c0f25535be6e726d1b908f444514"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8327b24ee8a0d4b3cd9dfb6d49eb20a80484c0f25535be6e726d1b908f444514"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "14bbb72aa9d9a989ea94f21ca6b31f3f40b1fe337438bf1e9b5b318eb3131899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "14bbb72aa9d9a989ea94f21ca6b31f3f40b1fe337438bf1e9b5b318eb3131899"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "util-macros" => :build

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "-I#{include}", shell_output("pkg-config --cflags xproto").chomp
    assert_equal "-I#{include}/X11/dri", shell_output("pkg-config --cflags xf86driproto").chomp
  end
end
