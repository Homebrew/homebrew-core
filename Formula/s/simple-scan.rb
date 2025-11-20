class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/49/simple-scan-49.1.tar.xz"
  sha256 "9ae8d4151ecaf95845eb9f99b436d579c838f2cf02763fba3bc03780251be334"
  license "GPL-3.0-or-later"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "5fe085c85f2967327041afa613d8016352f19156b098d67ca010148a217be3ff"
    sha256 arm64_sequoia: "d89032a5bf6c0e345c6ddc07fcfdfda8418c7d5a08e9e1d98bdb7b1005442ddd"
    sha256 arm64_sonoma:  "2227cf61e91dce38d6fe1940f68f3ec0479e2dd4281e0e968d4667e8d45572a7"
    sha256 sonoma:        "32b1b1a42f0a31b9b8bf40a679405cebcbcd68b7bde435cd0a3cb04470c5fedf"
    sha256 arm64_linux:   "a4f06e8f35418562c92bcd97ca36a81796c147679c881dcb1bb10aa6c04fad75"
    sha256 x86_64_linux:  "219f864806981e8005ffe0749d53e4fd8b927da202d5892cecd093f5f52255eb"
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
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
