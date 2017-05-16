class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://developers.yubico.com/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.18.0.tar.gz"
  sha256 "cf333e133b551adf5963e0f5fe0566f4e397f9784d4c1b8fc56b9d2ebcf982ad"

  bottle do
    cellar :any
    sha256 "caa9b3e94726845cb1d1d972a822e105bf7092d9ddf5bcda90e33f14039eaf4b" => :sierra
    sha256 "61d466fe3b295a6b4a6a1642dc8f1a393e28a6e9705260cf4107e8ad62a8bcab" => :el_capitan
    sha256 "b3b65497b0b754c40a4b72ba607f9cc8149400dc2b4a89debc9a752f8add51a9" => :yosemite
    sha256 "708fcea4a38578c8dabe046c07d8705bb8d1874c8b389c46e2edd6bc4f8b1d5c" => :mavericks
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
    assert_match "1.18.0", shell_output("#{bin}/ykinfo -V 2>&1")
  end
end
