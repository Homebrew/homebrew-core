class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/44/simple-scan-44.0.tar.xz"
  sha256 "39b870fd46f447f747eaecc2df26049ef773185099f0e13c675656264dd98e95"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "ede4b8f1b73d0d696dd111ceb935176a9229cef508511a94a8643e89237b2107"
    sha256 arm64_ventura:  "95d221ebd8db12997effdb57b515dcdf67db873967459990c7adfd051051d3a1"
    sha256 arm64_monterey: "a80f90b79f99908c1cc605e094e95dadccaec4fd4e8d5787779f8165b5a03320"
    sha256 sonoma:         "d41e03717c1b7a381c790aa4223553fc51ba20c58217f8bccd3dddd4775fa19c"
    sha256 ventura:        "604b9a994a1849c54d3d85a3a8ec5b841e8548880fc3a9ba5537380314eff5b6"
    sha256 monterey:       "6369e2e883f9bf6f69290c4ca660e7e21c2ce742b2102cd7c3cd2861584765ab"
    sha256 x86_64_linux:   "e3dc89775898ce3019d4c3625ee196ce4c4f443001cb4b271001a6171080c105"
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libgusb"
  depends_on "libhandy"
  depends_on "sane-backends"
  depends_on "webp"

  def install
    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # Errors with `Cannot open display`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system "#{bin}/simple-scan", "-v"
  end
end
