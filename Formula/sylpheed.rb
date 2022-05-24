class Sylpheed < Formula
  desc "Simple, lightweight email-client"
  homepage "https://sylpheed.sraoss.jp/en/"
  url "https://sylpheed.sraoss.jp/sylpheed/v3.7/sylpheed-3.7.0.tar.bz2"
  sha256 "eb23e6bda2c02095dfb0130668cf7c75d1f256904e3a7337815b4da5cb72eb04"
  revision 4

  livecheck do
    url "https://sylpheed.sraoss.jp/en/download.html"
    regex(%r{stable.*?href=.*?/sylpheed[._-]v?(\d+(?:\.\d+)+)\.t}im)
  end

  bottle do
    sha256 arm64_monterey: "77a7980e9c83d77c1416057cf5b59a623061ecc2e61d527485a1f58d7c28ad4e"
    sha256 arm64_big_sur:  "ae2f9828834200f3a587a7d596560bf8809f173a1044e997a58a0ea8d8a45acc"
    sha256 monterey:       "0d52dc0953029819c21263981a3b596d7084667a924bbe84c6e444e8f8fcdbe8"
    sha256 big_sur:        "b8d825cf9222f047cf9eec78a8a8b81c8133cd75ded1c66e3423d38318226c41"
    sha256 catalina:       "294ac17fa03002cb92f7f1bcb5f1a9b4f56157e54b564bd8e4e673f5902fc8a0"
    sha256 mojave:         "80a9483de9580d154fe32831a5172cc5e72b31a3722f8335e39aa5fd763935ff"
    sha256 x86_64_linux:   "979ac3748ddb193271a816f3fd5782601ca31259091e7a47ffe6cb99741e6d76"
  end

  depends_on "pkg-config" => :build
  depends_on "gpgme"
  depends_on "gtk+"
  depends_on "openssl@1.1"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-updatecheck"
    system "make", "install"
  end

  test do
    system "#{bin}/sylpheed", "--version"
  end
end
