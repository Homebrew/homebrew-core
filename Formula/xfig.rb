class Xfig < Formula
  desc "Facility for interactive generation of figures"
  homepage "https://mcj.sourceforge.io"
  url "https://downloads.sourceforge.net/mcj/xfig-3.2.8b.tar.xz"
  sha256 "b2cc8181cfb356f6b75cc28771970447f69aba1d728a2dac0e0bcf1aea7acd3a"
  license "MIT"
  revision 4

  livecheck do
    url :stable
    regex(%r{url=.*?/xfig[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "8574d41d8a47a3627db72b121b9243901b3e36c78f5e24d1a061b6b3e54c55d7"
    sha256 arm64_monterey: "19e623d10ad5afe8b0dc2aeba0e4f034f04f0419f54aeadef69e0af4a17a4200"
    sha256 arm64_big_sur:  "caaf9d6a60be127104f5ea789913c07b25ce44505e17136c2b3882a688da7416"
    sha256 ventura:        "032f71865561c6e8a68bf9e99c13153fb68461419b67a104b905d04ae73b6ccd"
    sha256 monterey:       "7ad534b38ffc6cfade2018b4e8f85b9d938ade756f048634b8b8dc28d4d3d491"
    sha256 big_sur:        "023e9468783cfca2a0d534e082e40b394e7f04e4b375cba94223262bb2a1ae5f"
    sha256 catalina:       "35cf4130db30aa7204f7246e1eaf95f1e311bb605179099ad865dee6e1ccdedb"
    sha256 x86_64_linux:   "498a522412d4e00411d7f978e881956f9f990a79af2436b045b3900a7b35eec9"
  end

  depends_on "fig2dev"
  depends_on "ghostscript"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxaw3d"
  depends_on "libxi"
  depends_on "libxpm"
  depends_on "libxt"

  def install
    system "./configure", "--with-appdefaultdir=#{etc}/X11/app-defaults",
                          "--disable-silent-rules",
                          *std_configure_args
    system "make", "install-strip"
  end

  test do
    assert_equal "Xfig #{version}", shell_output("#{bin}/xfig -V 2>&1").strip
  end
end
