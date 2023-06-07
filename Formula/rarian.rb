class Rarian < Formula
  desc "Documentation metadata library"
  homepage "https://rarian.freedesktop.org/"
  url "https://rarian.freedesktop.org/Releases/rarian-0.8.1.tar.bz2"
  sha256 "aafe886d46e467eb3414e91fa9e42955bd4b618c3e19c42c773026b205a84577"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://rarian.freedesktop.org/Releases/"
    regex(/href=.*?rarian[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "eef2c738cf2200b17e3daab309cf09bb4fdb7ef94f720c6ec96cec75905aa490"
    sha256 arm64_monterey: "4952c81da347aeda97635c8b3601c58492055457e6fc4e6b6558f8d3d2a84746"
    sha256 arm64_big_sur:  "d69d0f1b4d7ddae2d5d751a506a3515b1969c4caa56ea55a4a8220971eb72641"
    sha256 ventura:        "f3df37904c083d797acdbb67bf45068d0acd9b80ffee2460a67ba08266cfc2f7"
    sha256 monterey:       "16028f3277db47111df30fcaea37aad818e72608f75e5c63e3eddf8adc779d5c"
    sha256 big_sur:        "12560010f5d31af2a399dd3cc9427ffc37474a9d6d04d1f8eac715956983cc56"
    sha256 catalina:       "6cd01a0bbc9d5168548c6735ddf1057ae3ef403d3868be499ff1ce3ba1cd6ab8"
    sha256 mojave:         "e727630f28efcdcb1a577f67525992f00a00c25ee1582277e1e91e2fa060187d"
    sha256 high_sierra:    "815aafc0d05198cd4e3880715a6ad5de21b3bf47ccf25ef4b91aa918848a67ee"
    sha256 sierra:         "9266addbd38ed67b7394d05702d2be69d44ccafeb8132ef75470a816614a9f8e"
    sha256 el_capitan:     "7784dc13b95c0c2f5818bc3657da52f0365bbe9c6ddf8871d81b8638cb89390c"
    sha256 x86_64_linux:   "13a02a92eb31d5071c87d10e227c419a6a2506f1407f6bb6a08b7ca2581a9645"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  conflicts_with "scrollkeeper",
    because: "rarian and scrollkeeper install the same binaries"

  def install
    # Regenerate `configure` to fix `-flat_namespace` bug.
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    seriesid1 = shell_output(bin/"rarian-sk-gen-uuid").strip
    sleep 5
    seriesid2 = shell_output(bin/"rarian-sk-gen-uuid").strip
    assert_match(/^\h+(?:-\h+)+$/, seriesid1)
    assert_match(/^\h+(?:-\h+)+$/, seriesid2)
    refute_equal seriesid1, seriesid2
  end
end
