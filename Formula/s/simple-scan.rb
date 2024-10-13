class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/46/simple-scan-46.0.tar.xz"
  sha256 "c16e6590142fe563be5143122b3bbb53f6b00a7da9d952f61c47fa26f7b4f0a9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "a2cf3bd809f6f5ddd550bbb84aaa8645fdad54d614f4080dfb726e79cef74e1f"
    sha256 arm64_sonoma:   "1a630e40d1d5dd033d1797fbfc747b536565e025afff4d389983550a73541faf"
    sha256 arm64_ventura:  "710b448ae8e62de98dd11cbac8b58338fbef90f0fe7a7b7c288b01bd73885c6d"
    sha256 arm64_monterey: "bfb59ff1bb224ef61826a2015949a870abd29ff3ad0b62ef79d51dbdf41be9f7"
    sha256 sonoma:         "f5eb28ebc19c028cda3c385f7f56ac31aaf59a31cef9399e11df3806f2030654"
    sha256 ventura:        "b0e2cefa0b2f040a784328ea91b952ecaab721e90cede5d59e3631444ef425cd"
    sha256 monterey:       "cd024056d7d2adb8de0ba6a4bd6bc7bc1371671b056f75f355942bcbb5d9329d"
    sha256 x86_64_linux:   "877a4b7d0279114908c924bd91e6e0e7062ecfdcf2323d205754fcf38ae3f0f1"
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "libgusb"
  depends_on "sane-backends"
  depends_on "webp"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Work-around for build issue with Xcode 15.3
    # upstream bug report, https://gitlab.gnome.org/GNOME/simple-scan/-/issues/386
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # Errors with `Cannot open display`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system bin/"simple-scan", "-v"
  end
end
