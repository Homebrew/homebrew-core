class Xorgproto < Formula
  desc "X.Org: Protocol Headers"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2025.1.tar.gz"
  sha256 "d6f89f65bafb8c9b735e0515882b8a1511e8e864dde5e9513e191629369f2256"
  license "MIT"

  livecheck do
    url :stable
    regex(/href=.*?xorgproto[._-]v?(\d+\.\d+(?:\.([0-8]\d*?)?\d(?:\.\d+)*)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c65163b3daadd9160d9e2ba92f0541800577833c6b06b50c10aab69c1ce38f25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c65163b3daadd9160d9e2ba92f0541800577833c6b06b50c10aab69c1ce38f25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c65163b3daadd9160d9e2ba92f0541800577833c6b06b50c10aab69c1ce38f25"
    sha256 cellar: :any_skip_relocation, sonoma:        "c65163b3daadd9160d9e2ba92f0541800577833c6b06b50c10aab69c1ce38f25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22b221145e4420b8d0444ff4699d93726fc20c63ec1c789b41acf35075174a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22b221145e4420b8d0444ff4699d93726fc20c63ec1c789b41acf35075174a6d"
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
