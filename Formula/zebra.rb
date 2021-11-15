class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/resources/software/zebra/"
  url "https://ftp.indexdata.com/pub/zebra/idzebra-2.2.3.tar.gz"
  sha256 "85ade449d161d97df47d4a8910a53a5ea3bd5e3598b6189d86fc8986a8effea4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.indexdata.com/pub/zebra/"
    regex(/href=.*?idzebra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "eaef0ac6043ea6d81351dd34bd2a96df357dedb4f23c24b72fff47193590c2c6"
    sha256 arm64_big_sur:  "7a974b65d88ed87b9a83990a357b09aa0c4215a9281961a1a5def5108c307c91"
    sha256 monterey:       "a9f08214eecf10f5ddc11d591fd6e4b7fa28173d2b642b1abf99ef3b1be7ae6c"
    sha256 big_sur:        "a1ea1081a94d89b8f47395528de594a0516c3c3f915ce30f54c05b7b73e883e2"
    sha256 catalina:       "6063cecb5f7cced53e56fe465b5030bfb5f34cd6ea322e5994793b15c836953e"
    sha256 mojave:         "1114c380d8a57a0f052bca099a7902a42bea70fdf0ff6b88d9d9985c44c5ab6d"
  end

  depends_on "icu4c"
  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-mod-text",
                          "--enable-mod-grs-regx",
                          "--enable-mod-grs-marc",
                          "--enable-mod-grs-xml",
                          "--enable-mod-dom",
                          "--enable-mod-alvis",
                          "--enable-mod-safari"
    system "make", "install"
  end

  test do
    cd share/"idzebra-2.0-examples/oai-pmh/" do
      system bin/"zebraidx-2.0", "-c", "conf/zebra.cfg", "init"
      system bin/"zebraidx-2.0", "-c", "conf/zebra.cfg", "commit"
    end
  end
end
