class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.11.tar.gz"
  sha256 "f8a2745425967d6dd133a55b9e8431484e50b0d62f6c90b7bca37399bd528dec"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a9dc199e6eda7f988acc9aa56c77ee8375c2f9a2fd5dba0c71549438c9fee673"
    sha256 arm64_sequoia: "37b94ad46aa43a46f06941e2854e6d30f7e54006a9a5af5237b43e141086895c"
    sha256 arm64_sonoma:  "eff491efc8f14581f610db4c42b9cf829736dff9a65785401f09544b62f7ee35"
    sha256 sonoma:        "12f6eecd7d7428099b2905e4e4cf4cdf5d3e4a371681eb9f3f6fc23dc46b4222"
    sha256 arm64_linux:   "060db00fbe4eee714ca1ef2b2c3a307a8f36ef400d23b9fdcbf6bbe7456ef480"
    sha256 x86_64_linux:  "cad3e1f50abfa72fa4de40e462c4bdf2a24cd0ca90d34885ab36c866a9170415"
  end

  depends_on "pkgconf" => :build

  depends_on "icu4c@78"
  depends_on "yaz"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
