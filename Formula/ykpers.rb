class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://developers.yubico.com/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.20.0.tar.gz"
  sha256 "0ec84d0ea862f45a7d85a1a3afe5e60b8da42df211bb7d27a50f486e31a79b93"
  license "BSD-2-Clause"
  revision 2

  livecheck do
    url "https://developers.yubico.com/yubikey-personalization/Releases/"
    regex(/href=.*?ykpers[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "31b2bafcc829e3cc6e85f5e1021075088a909ba4db51ec8f20b23db93f59d802" => :big_sur
    sha256 "512484b795857fd09d61e2fb5c186ff771295c90b809bdcc82fdcf76835b71a0" => :arm64_big_sur
    sha256 "8c5ed1924d1059265589a221b8e2bb26a2bcd59f91ede210e3a1267412867f47" => :catalina
    sha256 "c2e6089348f9cc4f9c887eeb5975378749c42ea386ef12d7f84a3285b718dc45" => :mojave
    sha256 "79c240a018183c2f62eae6e7c22f631598b167d321a715f0983ff4653c1c2eee" => :high_sierra
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
  # Fix device access issues on macOS Catalina and later. Remove with the next release.
  patch do
    url "https://github.com/Yubico/yubikey-personalization/commit/7ee7b1131dd7c64848cbb6e459185f29e7ae1502.patch?full_index=1"
    sha256 "bf3efe66c3ef10a576400534c54fc7bf68e90d79332f7f4d99ef7c1286267d22"
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
