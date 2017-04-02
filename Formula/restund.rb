class Restund < Formula
  desc "Modular STUN/TURN server"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/restund-0.4.11.tar.gz"
  sha256 "d4630dfb8777f12cc48ed118da0ea6445bc60e94ff916ab0ca5d436c74bdc2d7"

  bottle do
    cellar :any
    sha256 "17efaad7de4d9fedca7f71b2381d27d0520aaa4bb06f232ac1f42cc815d70110" => :sierra
    sha256 "215521ec7fea46b6060e35b674d905ebafe0bf2aa5135793e1e1698db5680c07" => :el_capitan
    sha256 "39260c5e38d471692edc0b140ea1d684bb1b86549a4299d1606256d9165df706" => :yosemite
    sha256 "6ac6767f9ce4917b089be8545532768fc5318e40feed05c34ca0ea0580c4c749" => :mavericks
    sha256 "08ec540956dd4491876f7edd6c00bcab38b019579c92de565390efedeac50822" => :mountain_lion
  end

  depends_on "libre"

  # this patch is needed for restund to work on OSX, because it is
  # using select() for polling with max 1024 file descriptors.
  patch :p0 do
    url "http://www.creytiv.com/tmp/restund-homebrew.patch"
    sha256 "5890036319dd55e6522762a28022554024c849ce25e5c690364686e6a5571c93"
  end

  def install
    libre = Formula["libre"]
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
    system "make", "config", "DESTDIR=#{prefix}",
                              "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
  end

  test do
    system "#{sbin}/restund", "-tdnf", "#{etc}/restund.conf"
  end
end
