class Rarian < Formula
  desc "Documentation metadata library"
  homepage "https://rarian.freedesktop.org/"
  url "https://gitlab.freedesktop.org/rarian/rarian/-/releases/0.8.6/downloads/assets/rarian-0.8.6.tar.bz2"
  sha256 "9d4f7873009d2e31b8b1ec762606b12bee5526e1fe75de48e9495382bfef2bea"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?rarian[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "d28b342406dadc412d136c1c08c9b97613b668131f813d542d07ffe379b17db0"
    sha256 arm64_sonoma:  "2d901dd0b530c413b30ab3eb0327c02596590c685928ef896bdfc13b9fac1df2"
    sha256 arm64_ventura: "ec32e06c27f85d273f6ca90b78031f4b0ce6e190b9f160fed55f0cf1797f35a4"
    sha256 sonoma:        "82ff77a27b3ed671542d4c066f945a45c5fce1777df9d77bdc8cfabc38bc219d"
    sha256 ventura:       "1c10f34f9b76eba56f95ef5b1af592e6f51aaadd88e42cecb93864bbab8f41f6"
    sha256 x86_64_linux:  "1db54c3f633551261b40b7dc69e6b7a6e18649c681f7eb4f01703f35e565abec"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "tinyxml2"

  conflicts_with "scrollkeeper",
    because: "rarian and scrollkeeper install the same binaries"

  def install
    # Regenerate `configure` to fix `-flat_namespace` bug.
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
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
