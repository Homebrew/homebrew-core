class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v4.5.1/qalculate-gtk-4.5.1.tar.gz"
  sha256 "1f8b95cfb8267c60c8e1c2faf78f6fc487714d6d504b2a121809ca5582e2d656"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "23207d7f0652b0eb38863544a3fa30aa78b03cdf87a6a72f9443a283d48f7cfd"
    sha256 arm64_monterey: "975f4e35a02d3b899735ba9bc69e8069fcece2fdcec59ded9a0d2151aac63e8b"
    sha256 arm64_big_sur:  "7bf6e27696b995e4831f89daa5e9ef5cdcc6b448093dd220c3a4de089e914a0d"
    sha256 ventura:        "804eb77dc110aaae2ddcb85f6d0bb54f1430399acdb2e4fcab08d03ec16c5aee"
    sha256 monterey:       "9b17f0852ecfa6d3d473305c30f5745603c7f51f54897a5e1668967bb983716d"
    sha256 big_sur:        "5de38867feb79cc54f1eae365c73715af4b961a5120ea3e571ab4fa95aaaf37e"
    sha256 x86_64_linux:   "e4b016608db1c5f59b480d829c970117b77860bd08dac7c3ee6e4d8affa35597"
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
