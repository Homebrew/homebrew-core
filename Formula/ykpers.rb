class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://developers.yubico.com/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.18.0.tar.gz"
  sha256 "cf333e133b551adf5963e0f5fe0566f4e397f9784d4c1b8fc56b9d2ebcf982ad"

  bottle do
    cellar :any
    sha256 "d7a19fbf9d4d0b380af56ed2f4fb3c7b279297e2ff176a634605b1b6cfd46c7a" => :sierra
    sha256 "d39fed920432cc5316fa02d986fc6cc1f028e1dad509d0e0c1bab1444126259d" => :el_capitan
    sha256 "02867771a2d90229629d86afd76ac596ad6a52e5f5a696047442ba00a23b7589" => :yosemite
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
