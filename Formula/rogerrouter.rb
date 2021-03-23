class Rogerrouter < Formula
  desc "All-in-one solution for FRITZ!Box routers"
  homepage "https://www.tabos.org"
  url "https://gitlab.com/tabos/rogerrouter/-/archive/2.3.90/rogerrouter-2.3.90.tar.bz2"
  sha256 "11dd452f608215db7bfd027fee666694f473378d8f936f4410a99f8b1c94ddf3"
  license "GPL-2.0-only"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "capi20"
  depends_on "gettext"
  depends_on "ghostscript"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libgdata"
  depends_on "libhandy"
  depends_on "librm"
  depends_on "libsoup"
  depends_on "poppler"

  def install
    args = %W[
      --prefix=#{prefix}
      -Denable-post-install=false
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja"
      system "ninja", "install"
    end

    # meson-internal gives wrong install_names for dylibs due to their unusual installation location
    # create softlinks to fix
    ln_s Dir.glob("#{lib}/roger/*dylib"), lib
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "lpadmin", "-p", "Roger-Router-Fax", "-m", "drv:///sample.drv/generic.ppd", \
           "-v", "socket://localhost:9100/", "-E", "-o", "PageSize=A4"
  end

  test do
    system "#{bin}/roger", "--help"
  end
end
