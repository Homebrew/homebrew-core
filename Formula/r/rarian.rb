class Rarian < Formula
  desc "Documentation metadata library"
  homepage "https://rarian.freedesktop.org/"
  url "https://gitlab.freedesktop.org/rarian/rarian/-/releases/0.8.6/downloads/assets/rarian-0.8.6.tar.bz2"
  sha256 "9d4f7873009d2e31b8b1ec762606b12bee5526e1fe75de48e9495382bfef2bea"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?rarian[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "9902862041d1a77fada33e8ebaabedf67f77b3bc8050ea988f78f8650c2c4ce3"
    sha256 arm64_sequoia: "0c5d1dc2a38bdba34aee85a1704dd7fe8c4a5d8165888fd96d6844bbd9b6dfc9"
    sha256 arm64_sonoma:  "8050a6ad473152290f964a8a51eb661d41595c75f0e0286d01a38764c77283e5"
    sha256 arm64_ventura: "385dbc09752299c2b0cfcb4da0bf18e6a799d891c3cc4939748bbd57e8cce98f"
    sha256 sonoma:        "ed569b70aaf6ecb11c8e6c77306b9514c27ca2013c3ec6583e735935ad593962"
    sha256 ventura:       "a6707c1941c3e76d099eb2d1a780bfd01ce45980f2446b81f16204d781e37bfa"
    sha256 arm64_linux:   "71527d1afc769fb36f87f00e635acdf53f7b74f74cbe3448c00108ca368ad18e"
    sha256 x86_64_linux:  "289b7f0d276337b070e632d435f8f85f96462c8982d2597cd90f552aac4d14cf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "tinyxml2"

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
