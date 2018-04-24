class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://developers.yubico.com/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.19.0.tar.gz"
  sha256 "2bc8afa16d495a486582bad916d16de1f67c0cce9bb0a35c3123376c2d609480"

  bottle do
    cellar :any
    sha256 "033fde5866eef8f18f9359a6a2fa93ee10692ded0215921f83bc02fc48f7ca01" => :high_sierra
    sha256 "5097fdfc181c4b7cf384c149dd566f4aab24099212835ec13dc93cdb903a19c2" => :sierra
    sha256 "a621bd54eb6823e19baabef290a18834ac0d5b8f886eff267f8180d3fb11f71d" => :el_capitan
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
