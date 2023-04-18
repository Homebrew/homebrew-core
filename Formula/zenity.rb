class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://wiki.gnome.org/Projects/Zenity"
  url "https://download.gnome.org/sources/zenity/3.44/zenity-3.44.0.tar.xz"
  sha256 "c15582301ed90b9d42ce521dbccf99a989f22f12041bdd5279c6636da99ebf65"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "c357680928b4fff49b05253e988b4d2f27bd7ee44840e6627958ac02256c716e"
    sha256 arm64_monterey: "8b2d5bfe433a2cea63be29e5650cb17525e1367bbddc4ad4f3541e29be66e164"
    sha256 arm64_big_sur:  "564c063d6868c14a57ba80960932b068c9baefc2fa38ef8826c362000e8d1f51"
    sha256 ventura:        "02b6dcb438a50ad9cc4245e39e4c97fd31272292f901b73a2b09c68bcb78e9fd"
    sha256 monterey:       "015ce30aa552f2ed0477a62ce809a1e789e378dacdd4bdf2d34555222400ccb3"
    sha256 big_sur:        "863f450b00c419071758c82b69be87492583982c77e53581b56fe74a4233f643"
    sha256 x86_64_linux:   "5dab4775576855f3417eb028518c4a30f0231fe8bdbefcba4a68ff01ca24c501"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk+3"

  def install
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # (zenity:30889): Gtk-WARNING **: 13:12:26.818: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"zenity", "--help"
  end
end
