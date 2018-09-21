class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://developers.yubico.com/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.19.0.tar.gz"
  sha256 "2bc8afa16d495a486582bad916d16de1f67c0cce9bb0a35c3123376c2d609480"
  revision 1

  bottle do
    cellar :any
    sha256 "1f4b630767994b8dd587c19a1a29bc09f95333a1a5b0c55a09b49d6cc6686e00" => :mojave
    sha256 "cafe1f694f16a7b8d6f4f9f264f57bfa98a6cd99b68bf1bd12f7be2468078b7e" => :high_sierra
    sha256 "b2c86248fbf8dee9eb4ddf1fe5394606d821d8b8950b709a7a1499a22a3b2f4a" => :sierra
    sha256 "4917acf9815efca0407441ac895478bfba0abc611bb143d65f8c5400b17787c0" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libyubikey"

  def install
    libyubikey_prefix = Formula["libyubikey"].opt_prefix
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{libyubikey_prefix}",
                          "--with-backend=osx"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykinfo -V 2>&1")
  end
end
