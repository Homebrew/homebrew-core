class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v4.6.0/qalculate-gtk-4.6.0.tar.gz"
  sha256 "bbbd7fae6a6d367bbb692fbdf9bf7235828408b044284b2f0542d42a7d65e877"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "bd62aa9776ac99e489523a00c4ad24918c273af99fa82eba748a820dd12a7a7a"
    sha256 arm64_monterey: "e844da82b884a64edae253bbd17bff5d115cc6e1939d3caa1fb6661f54717658"
    sha256 arm64_big_sur:  "ea40cc0104b9135f7fb2be33152f44fe2b2da4af22d58a01945451852e33d00b"
    sha256 ventura:        "6af5c224461a517323c7c4cc5bf62190470d8924a6c72c34272c201861dc2b40"
    sha256 monterey:       "018b2f2d361dd7b97c2bd5d208f9566b4cbf96affc4acd79b28dcd32414b66cd"
    sha256 big_sur:        "edee295d4eb84dc70eebaf06e185c95cee41cffacf21033ae6338043e21d0f36"
    sha256 x86_64_linux:   "64b8458dcaa1248b6d1c470f55d852b3511b5826de83a538cebf24cd0675872f"
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
