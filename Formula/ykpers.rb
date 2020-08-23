class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://developers.yubico.com/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.20.0.tar.gz"
  sha256 "0ec84d0ea862f45a7d85a1a3afe5e60b8da42df211bb7d27a50f486e31a79b93"
  license "BSD-2-Clause"
  revision 1

  bottle do
    cellar :any
    sha256 "f5615ed1ad958e10d5908c16feb53bc706fd42f7721d0e8cfd3ea8dd4658a221" => :catalina
    sha256 "1cd502d61459515ab043d2cd8d2d8df3d97f605578766934312fa53343a619ec" => :mojave
    sha256 "215538176c67853276fe86e6894d6a19be95323d236175c5e4a84b4ce73b39d6" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libyubikey"

  on_linux do
    depends_on "libusb"
  end

  # Compatibility with json-c 0.14. Remove with the next release.
  patch do
    url "https://github.com/Yubico/yubikey-personalization/commit/0aa2e2cae2e1777863993a10c809bb50f4cde7f8.patch?full_index=1"
    sha256 "349064c582689087ad1f092e95520421562c70ff4a45e411e86878b63cf8f8bd"
  end

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
