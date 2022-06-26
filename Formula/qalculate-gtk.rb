class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v4.2.0/qalculate-gtk-4.2.0.tar.gz"
  sha256 "50624344d12240f6eac68555c9a03747d0c2d90dd0de1bfe1b024fd5be8149d7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "edf88ad9b92a3c30017882a92f86b7f6a91dd4ff01e0afb147f8863bbc8ee558"
    sha256 arm64_big_sur:  "7f9080a5408202557708fad7f7f651c0e1a855cdc425eb805867513bcdbc5ee2"
    sha256 monterey:       "1d300cd87fa01c25e5d1ca70162ac86b17f1f0dcced83a2a093cdb159f38fb8f"
    sha256 big_sur:        "b8ddc53272e7509148711b58d14176200903f03522772900101da2b91126c61a"
    sha256 catalina:       "0f7e937b29ccabfbe69803daf803e2b98cfd4278633f47af1c85e0261b58e068"
    sha256 x86_64_linux:   "c5a26b87a0b06a00a97b3cf8e0ba36f611717645df00ef6d4bb78b10cfc2fe02"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "libqalculate"

  uses_from_macos "perl" => :build

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalculate-gtk", "-v"
  end
end
