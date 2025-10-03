class Smartmontools < Formula
  desc "SMART hard drive monitoring"
  homepage "https://www.smartmontools.org/"
  url "https://downloads.sourceforge.net/project/smartmontools/smartmontools/7.5/smartmontools-7.5.tar.gz"
  sha256 "690b83ca331378da9ea0d9d61008c4b22dde391387b9bbad7f29387f2595f76e"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "1059107fe65fbaa54f25cba7f2d9160cba2ca90cb0b9ba3d3635f78639c46a29"
    sha256 arm64_sequoia: "40ae2e7c1fe5a99587149ea92c170bd8a89f97b44cb0b1d616635c45dfac2074"
    sha256 arm64_sonoma:  "55f5004cb84ed1a3ca63ad5d312dfad8eb85d5fe5adeefb317187729b37af0f6"
    sha256 arm64_ventura: "43f66ca1752c078cf5a4f9bb7943bcb27e3ddef33ca0479c69c4491c7f567978"
    sha256 sonoma:        "bcff6e0f0d53730dd07c8847cb83bf28a5164b63d31e88a54ef9d70351548688"
    sha256 ventura:       "6efc9fd70ae3cc6dfbfb30ef3ab20bd5ca81516d6beaafde3d3b8e3ccd9691a3"
    sha256 arm64_linux:   "242eb99f15e071df38712e5b55a3b4b7bac49def0e6f08263bfcecb9b3257a99"
    sha256 x86_64_linux:  "61712e27dc30e3b492fe259a6dbf69f637018f8348abd5dd1be752526abdd811"
  end

  def install
    (var/"run").mkpath
    (var/"lib/smartmontools").mkpath

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-savestates",
                          "--with-attributelog",
                          "--with-nvme-devicescan"
    system "make", "install"
  end

  test do
    system bin/"smartctl", "--version"
    system bin/"smartd", "--version"
  end
end
