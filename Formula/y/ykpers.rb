class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://developers.yubico.com/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.20.0.tar.gz"
  sha256 "0ec84d0ea862f45a7d85a1a3afe5e60b8da42df211bb7d27a50f486e31a79b93"
  license "BSD-2-Clause"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "926db3e02f205b9e785c45dd758876a906c0892c0bb3c3d3dae64067adb3972e"
    sha256 cellar: :any,                 arm64_sequoia: "55b5c0412c66507bcc30d4fad0b66787aa34ae962ad6ce088a4500d7c330f94c"
    sha256 cellar: :any,                 arm64_sonoma:  "0c8854edfb7647c2a3f8cc27d38b8e6ef7ba6c61cc964341e738c3690f6092e4"
    sha256 cellar: :any,                 sonoma:        "88d61b40ef7bcd1f6a7989af01b4ebbd8de1a15750b24a2203a1bd007e319c72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c25183feab444d3d2850280b40eafdb86da032c75b1313c9302ab1e6bfb8e374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaf5715c54695f9f87a4a0a8b9e185a4985434ae5ab08abef60c95a91b292347"
  end

  # https://www.yubico.com/support/terms-conditions/yubico-end-of-life-policy/eol-products/
  deprecate! date: "2025-11-22", because: :unmaintained, replacement_formula: "ykman"
  disable! date: "2026-11-22", because: :unmaintained, replacement_formula: "ykman"

  depends_on "pkgconf" => :build
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
    # Work around failure from GCC 10+ using default of `-fno-common`
    ENV.append_to_cflags "-fcommon" if ENV.compiler.to_s.start_with?("gcc")

    args = %W[
      --disable-silent-rules
      --with-libyubikey-prefix=#{Formula["libyubikey"].opt_prefix}
    ]
    args << if OS.mac?
      "--with-backend=osx"
    else
      "--with-backend=libusb-1.0"
    end
    system "./configure", *args, *std_configure_args
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykinfo -V 2>&1")
  end
end
