class Rarian < Formula
  desc "Documentation metadata library"
  homepage "https://rarian.freedesktop.org/"
  url "https://gitlab.freedesktop.org/rarian/rarian/-/releases/0.8.5/downloads/assets/rarian-0.8.5.tar.bz2"
  sha256 "8ead8a0e70cbf080176effa6f288de55747f649c9bae9809aa967a81c7e987ed"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?rarian[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "98833e600512fbb1258715c6748be4909216695db2a18b33e13b79e1ecdad382"
    sha256 arm64_ventura:  "0bd6d6c0dbf8af88be3de2cc58374c22a0f6754de720b408468b8687faed9991"
    sha256 arm64_monterey: "234efb4a3e23a05557f67f7166639e86e4638b722865efd6b11674a411e096c3"
    sha256 sonoma:         "f9bb606136efc8de3c89928b213a2e223403293b0f55929de7d381bfec3900cc"
    sha256 ventura:        "3915d74bdc15d87280f1231212649db051797013e08cd8099c736c0edadfaf73"
    sha256 monterey:       "cec37c05da4ab47e4bbd746335b7e8282f69901e1d083473ac35a4005e08904f"
    sha256 x86_64_linux:   "b0554edb782e27b9a2cf0009781b33eddefb81f0adf2fff144579e3dc6b6a91e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "tinyxml"

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
    seriesid1 = shell_output("#{bin}/rarian-sk-gen-uuid").strip
    sleep 5
    seriesid2 = shell_output("#{bin}/rarian-sk-gen-uuid").strip
    assert_match(/^\h+(?:-\h+)+$/, seriesid1)
    assert_match(/^\h+(?:-\h+)+$/, seriesid2)
    refute_equal seriesid1, seriesid2
  end
end
