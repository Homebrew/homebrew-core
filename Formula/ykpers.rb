class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://developers.yubico.com/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.18.1.tar.gz"
  sha256 "9ffdb938121a867aa0b350b49daff5807884c2268dfe6d245d133474cd9c5256"

  bottle do
    cellar :any
    sha256 "011f869e3fdb84bf0f5aecece6b78f6351d56b17b0cced168c00b2ea7d1178f0" => :high_sierra
    sha256 "402163cec22f6456311c4c40141bb09ca6f5e6aa2a25b828ca6be7eaea78bf65" => :sierra
    sha256 "f36ef2cf81878daa403b270eda166280e11af6c0f74c8999f63a0be890f6f086" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libyubikey"
  depends_on "json-c" => :recommended

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
