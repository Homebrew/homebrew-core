class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://developers.yubico.com/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.19.3.tar.gz"
  sha256 "d9513ec7576bea36be37e3fb87a51d4522a28b6b0611ce64ad9fdf2cb7b21b4a"

  bottle do
    cellar :any
    sha256 "5c6d6520ffac87605ba24db1b647849db88cbee18bb10803d0e4f2b7bfe97bb5" => :mojave
    sha256 "4bc3fd4c9b90826642c1f093862424325ecb6aafddf32862a649423a4f16ac5f" => :high_sierra
    sha256 "6782f8afcf355fbbb908e4e28bf3687ccdba5c46addece72640213cba09722bd" => :sierra
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
