class Sysprof < Formula
  desc "Statistical, system-wide profiler"
  homepage "https://gitlab.gnome.org/GNOME/sysprof"
  url "https://download.gnome.org/sources/sysprof/51/sysprof-51.0.tar.xz"
  sha256 "f2c8d9c5c8294ce3fdc8be7d9f4be56a72ed71522cb54987f1723a8cfd91637d"
  # See Debian's Copyright File. https://metadata.ftp-master.debian.org/changelogs//main/s/sysprof/sysprof_47.0-2_copyright
  license all_of: [
    "GPL-2.0-or-later",
    "GPL-3.0-or-later",
    "LGPL-2.0-or-later",
    "LGPL-3.0-or-later",
    "BSD-2-Clause-Patent",
    "BSD-3-Clause",
    :public_domain,
  ]
  head "https://gitlab.gnome.org/GNOME/sysprof.git", branch: "master"

  bottle do
    sha256 arm64_linux:  "9c472a201104527f209526fd92285d3fe5b25951fc8ecd3e19a3d6fbd6b403a6"
    sha256 x86_64_linux: "53fd3f707c7a8beac16d11716b98691da2afb304376d81e5cbb057e6400fdfec"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "elfutils"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "libdex"
  depends_on "libpanel"
  depends_on "libunwind"
  depends_on :linux
  depends_on "pango"
  depends_on "polkit"
  depends_on "systemd"

  def install
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build",
                    "-Dgtk=true",
                    "-Dhelp=false",
                    "-Dtools=true",
                    "-Dtests=false",
                    "-Dexamples=false",
                    "-Dsystemdunitdir=#{lib}/systemd/system",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "examples"
  end

  post_install_steps do
    update_gtk_icon_cache
  end

  test do
    cp pkgshare/"examples/app.c", "."
    flags = shell_output("pkgconf --cflags --libs glib-2.0 sysprof-capture-4").chomp.split
    system ENV.cc, "app.c", "-o", "app", *flags
    assert_equal "SYSPROF_TRACE_FD not found, exiting.", shell_output("./app 2>&1", 1).chomp
  end
end
