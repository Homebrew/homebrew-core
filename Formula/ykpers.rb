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
    sha256 cellar: :any,                 arm64_ventura:  "ad5b67da47a110797570919026e4c78ec2220f858f804cca466ced27382170ca"
    sha256 cellar: :any,                 arm64_monterey: "a244acc561a3c5e5d5b67ccc25b9b24ea16b037e10acd8e01510a4a34f96ec15"
    sha256 cellar: :any,                 arm64_big_sur:  "512484b795857fd09d61e2fb5c186ff771295c90b809bdcc82fdcf76835b71a0"
    sha256 cellar: :any,                 ventura:        "0f4e3087830e58adda6999b618bc2ab80e90906f6d29dbbb5349adbbabcb9785"
    sha256 cellar: :any,                 monterey:       "e45fba4f54b6e285c38879635f3b13588783cced19ded02b3899c8da282fb353"
    sha256 cellar: :any,                 big_sur:        "31b2bafcc829e3cc6e85f5e1021075088a909ba4db51ec8f20b23db93f59d802"
    sha256 cellar: :any,                 catalina:       "8c5ed1924d1059265589a221b8e2bb26a2bcd59f91ede210e3a1267412867f47"
    sha256 cellar: :any,                 mojave:         "c2e6089348f9cc4f9c887eeb5975378749c42ea386ef12d7f84a3285b718dc45"
    sha256 cellar: :any,                 high_sierra:    "79c240a018183c2f62eae6e7c22f631598b167d321a715f0983ff4653c1c2eee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eee945e8cc748d69622f20b470e327fee279b356b78be2df9a75dc10ab945f1d"
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
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-libyubikey-prefix=#{Formula["libyubikey"].opt_prefix}
    ]
    args << if OS.mac?
      "--with-backend=osx"
    else
      "--with-backend=libusb-1.0"
    end
    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykinfo -V 2>&1")
  end
end
