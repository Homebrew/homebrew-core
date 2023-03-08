class Unnks < Formula
  desc "NKS and NKX archive unpacker"
  homepage "https://github.com/JimiHFord/unnks"
  url "https://github.com/JimiHFord/unnks/archive/refs/tags/0.2.6.tar.gz"
  sha256 "4308efe887f2d65962d210356373346a7ebac41cb91ba61b1bb952943137b026"
  license "GPL-3.0-or-later"

  depends_on "autoconf"
  depends_on "automake"
  depends_on "glib"
  depends_on "libgcrypt"
  depends_on "libtool"
  depends_on "pkg-config"

  def install
    system "autoreconf", "--install"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"unnks", "--version"
  end
end
