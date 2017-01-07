class Recipes < Formula
  desc "Formula for GNOME recipes"
  homepage "https://wiki.gnome.org/Apps/Recipes"
  url "https://download.gnome.org/sources/recipes/0.4/recipes-0.4.2.tar.xz"
  sha256 "9554d4f5d97eb9cd4032de0e4f9cc27a218c32d022dd1917a7e9efbd379c5bc1"

  bottle do
    sha256 "3942e92f1710d0b1d01d88edfb45417d61c5db77959f8d5e23403529e4406db7" => :sierra
    sha256 "bcb75443d75611020a2a249df3fd50ddb2388860bfebf41319628de8bbc4b0ec" => :el_capitan
    sha256 "fff313a143c4e0f1c6db25e4f895582f1c38603a3f312ecda0a06cc13b722a93" => :yosemite
  end

  depends_on "gtk+3"
  depends_on "gnome-icon-theme"

  def install
    # orces use of gtk3-update-icon-cache instead of gtk-update-icon-cache. No bugreport should
    # be filed for this since it only occurs because Homebrew renames gtk+3's gtk-update-icon-cache
    # to gtk3-update-icon-cache in order to avoid a collision between gtk+ and gtk+3.
    inreplace "data/Makefile.in", "gtk-update-icon-cache", "gtk3-update-icon-cache"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-autoar",
                          "--disable-gspell"
    system "make", "install"
  end

  test do
    system "#{bin}/recipes", "--help"
  end
end
