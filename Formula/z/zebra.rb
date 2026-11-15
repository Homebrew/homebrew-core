class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.11.tar.gz"
  sha256 "f8a2745425967d6dd133a55b9e8431484e50b0d62f6c90b7bca37399bd528dec"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "e75de204bccfd984aa544ac7be99337ee2e0c4f97bcb8794e15d0a22cdfb30e8"
    sha256 arm64_tahoe:       "6f2d39bb8881559788a41d4aa0983818a8a46ae07b30b05df33a67f8dc2533c8"
    sha256 arm64_sequoia:     "45666b5a6246de532ffa5387733b1bf735d3826ce512f178d054ee3617114db6"
    sha256 arm64_linux:       "5b4ddb1aedd0fc2ecd193be7b474afd9482066be0fc8b91ed22d57aef881f655"
    sha256 x86_64_linux:      "c4f77d2e56ca41e3594b308047ecc106b334b3580634d2c8519c226d0fe7f2ab"
  end

  depends_on "pkgconf" => :build

  depends_on "icu4c@79"
  depends_on "yaz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
