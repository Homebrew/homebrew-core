class Xinput < Formula
  desc "Utility to configure and test X input devices"
  homepage "https://gitlab.freedesktop.org/xorg/app/xinput"
  url "https://www.x.org/pub/individual/app/xinput-1.6.3.tar.bz2"
  sha256 "35a281dd3b9b22ea85e39869bb7670ba78955d5fec17c6ef7165d61e5aeb66ed"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cd6d4d1d3a69ffab976906f828f9cbbd78de75d212dda7b9225f18f54925f5fc"
    sha256 cellar: :any,                 arm64_big_sur:  "db714eb643b851dec6aa996c3673b932af70e191d404c8a187b408a9578f7fef"
    sha256 cellar: :any,                 monterey:       "42e694f3867eab495cb54de454879d7477e952c089b8ecf08bc327c77e5ab256"
    sha256 cellar: :any,                 big_sur:        "dab36aa6df662605e220ffce42106ed9eb6668088c425773335b04a59ba29575"
    sha256 cellar: :any,                 catalina:       "5bda55eccff0b10605378a85932776af6105fff7ae85593e2f10d13e9adca128"
    sha256 cellar: :any,                 mojave:         "afad4cf5c8b632f1e8873eee07a2bfd694efb1466dcafc0d4c8c233e370c4195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41d3a585aefaa9032b34865cced5bdff19339574ca7d4753ec9c64fb03b7b804"
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxi"
  depends_on "libxinerama"
  depends_on "libxrandr"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_predicate bin/"xinput", :exist?
    assert_equal %Q(.TH xinput 1 "xinput #{version}" "X Version 11"),
      shell_output("head -n 1 #{man1}/xinput.1").chomp
  end
end
