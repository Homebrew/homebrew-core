class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.9.tar.gz"
  sha256 "315bd69f4e8a0fdd57a4d5e24a7235d651adb64cc25c0077f1bda265ee6cab27"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2bb1f2eb84200a1f0169bccbf702dc2ec89d8e34b144d6a21c00e2c066381a28"
    sha256 arm64_sequoia: "552581d5651e896f75ce988873559418b848bd322e718f7bec56f4cc03292ced"
    sha256 arm64_sonoma:  "ad138cef511b4b5bfae11205561abb387c2f028fb2b58b7cff10c21bc774db22"
    sha256 sonoma:        "78905f514a15d96e22fb589baa7fb2f07d7cfa0c4aa2d5a0cb1bda8f205219b5"
    sha256 arm64_linux:   "787ad2d4c3da063d0ae40cfbe979442657144322877a11645ae522c853fa7994"
    sha256 x86_64_linux:  "68497189bba9c077b4501c7980d9c9eab7518d6ae24af4ee2f7654501fb89267"
  end

  depends_on "pkgconf" => :build

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
