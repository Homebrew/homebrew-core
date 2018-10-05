class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://wiki.gnome.org/Projects/Zenity"
  url "https://download.gnome.org/sources/zenity/3.30/zenity-3.30.0.tar.xz"
  sha256 "995ef696616492c40be6da99919851d41faed6643a97c9d24743b46bc8b537f2"

  bottle do
    sha256 "131e608af29f2a459abeeeb7d97e181d38a236fa5782079096fdfda22467ba41" => :mojave
    sha256 "33e96b6ef96ab194ced8ec552e5bb1de8212bc782d82320873ba0a6413547366" => :high_sierra
    sha256 "e6a508f02eae50cad3ba7c1f39bb712a4136c8caba9569f563cb2d0fa016f428" => :sierra
    sha256 "eb4386c1857fb2b4a41f5d0c8fb596b58add38a4e3f30d78b7223233aefa18c9" => :el_capitan
  end

  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"zenity", "--help"
  end
end
