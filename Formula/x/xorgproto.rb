class Xorgproto < Formula
  desc "X.Org: Protocol Headers"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2023.2.tar.gz"
  sha256 "c791aad9b5847781175388ebe2de85cb5f024f8dabf526d5d699c4f942660cc3"
  license "MIT"

  livecheck do
    url :stable
    regex(/href=.*?xorgproto[._-]v?(\d+\.\d+(?:\.([0-8]\d*?)?\d(?:\.\d+)*)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32a25261f78c125375872609316c2142f7b961617b7b7799b2ea11e818ced721"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de818c35cca25c4b2286a5642d5d1748320f6031039ec46b375fd11e935ef7e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de818c35cca25c4b2286a5642d5d1748320f6031039ec46b375fd11e935ef7e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de818c35cca25c4b2286a5642d5d1748320f6031039ec46b375fd11e935ef7e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "32a25261f78c125375872609316c2142f7b961617b7b7799b2ea11e818ced721"
    sha256 cellar: :any_skip_relocation, ventura:        "de818c35cca25c4b2286a5642d5d1748320f6031039ec46b375fd11e935ef7e3"
    sha256 cellar: :any_skip_relocation, monterey:       "de818c35cca25c4b2286a5642d5d1748320f6031039ec46b375fd11e935ef7e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "de818c35cca25c4b2286a5642d5d1748320f6031039ec46b375fd11e935ef7e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a594f854e8323bc670d2467ff340e3a07d7277b53fce1df415656610c0c3b74"
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
