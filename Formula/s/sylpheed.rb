class Sylpheed < Formula
  desc "Simple, lightweight email-client"
  homepage "https://sylpheed.sraoss.jp/en/"
  url "https://sylpheed.sraoss.jp/sylpheed/v3.7/sylpheed-3.7.0.tar.bz2"
  sha256 "eb23e6bda2c02095dfb0130668cf7c75d1f256904e3a7337815b4da5cb72eb04"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "MIT", :public_domain]
  revision 8

  livecheck do
    url "https://sylpheed.sraoss.jp/en/download.html"
    regex(%r{stable.*?href=.*?/sylpheed[._-]v?(\d+(?:\.\d+)+)\.t}im)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "b5fd93618ea6f60cfa7bba85d5fc32f71504b749e5cd8092913ceb4979c8b178"
    sha256 arm64_tahoe:       "9d162c69a7cab7f0671739a3a53cb0eff7017e9b59a5f651df03b692de28b0c6"
    sha256 arm64_sequoia:     "c788d42fa072abc19392c0d1aa76d9553fba825653c0143443b85a2a56192b87"
    sha256 arm64_linux:       "c93f141dab1b0b1a5354d8384f441f9c74886f500bd2e6447f603db821682b32"
    sha256 x86_64_linux:      "ddb55b5f3393569eb22d28dcfd7b59ab773cba24e896bd1c2ce8e57dca088648"
  end

  # Last release on 2018-01-31 with outstanding CVE-2021-37746. Last commit on 2022-09-13.
  # Still needs EOL `gtk+`. Multiple repositories made a similar decision:
  # * Alpine 3.24 - https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/95746
  # * Debian 14 / Ubuntu 26.04 - https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1129594
  # * Gentoo - https://gitweb.gentoo.org/repo/gentoo.git/commit/?id=b0fca6e9ac605eecb019c47cdc23f38cbcae8474
  # * nixpkgs - https://github.com/NixOS/nixpkgs/pull/512634
  deprecate! date: "2026-05-22", because: :unmaintained
  disable! date: "2027-05-22", because: :unmaintained

  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gpgme"
  depends_on "gtk+"
  depends_on "openssl@4"
  depends_on "pango"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "libassuan"
    depends_on "libgpg-error"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    type :unofficial
  end

  # Apply open PR to support OpenSSL 4. Low impact with only const correctness changes.
  patch do
    url "https://github.com/sylpheed-mail/sylpheed/commit/fe0fd167153a7e877d44baa7c395c2ee671387fc.patch?full_index=1"
    sha256 "446733233fc8e7d4e64a18de1874b44bf8f49ca77b20ffbbc5c7701f73e26b7b"
    type :unofficial
    resolves "https://github.com/sylpheed-mail/sylpheed/pull/68"
  end

  def install
    system "./configure", "--disable-updatecheck", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"sylpheed", "--version"
  end
end
