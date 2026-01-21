class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.8.tar.gz"
  sha256 "879e402b91912e9074275753f24408ed2ac06b3b7c30b2a2d5a70718c869a542"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c8326002478598c438eba6b7e37ae7ed537a0d12cfc9ee10fbf36317ff7f5da7"
    sha256 arm64_sequoia: "140dbff9b966af509fc339127a9b635e7efc6b59f71dd3c62ef7466a07587e88"
    sha256 arm64_sonoma:  "4d725a25f3125ce873ddc2f1fcd05f300b1324b3cd2631ea03d5e099d82bcb9d"
    sha256 sonoma:        "e39e9f5ce8d00f6c75c3ac59fcfadefe7b3954f4445d3a65c3532d3740a27bed"
    sha256 arm64_linux:   "389bfe2f986b21676bf4b44335ad8623577d62df89b730bee514e368b5d832da"
    sha256 x86_64_linux:  "4184eb6e9b8a971a34f021d82cb9e1927143459152780f5ec85184716c568c7b"
  end

  depends_on "icu4c@78"
  depends_on "yaz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-mod-text",
                          "--enable-mod-grs-regx",
                          "--enable-mod-grs-marc",
                          "--enable-mod-grs-xml",
                          "--enable-mod-dom",
                          "--enable-mod-alvis",
                          "--enable-mod-safari",
                          *std_configure_args
    system "make", "install"
  end

  test do
    cd share/"idzebra-2.0-examples/oai-pmh/" do
      system bin/"zebraidx-2.0", "-c", "conf/zebra.cfg", "init"
      system bin/"zebraidx-2.0", "-c", "conf/zebra.cfg", "commit"
    end
  end
end
