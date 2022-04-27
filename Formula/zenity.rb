class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://wiki.gnome.org/Projects/Zenity"
  url "https://download.gnome.org/sources/zenity/3.42/zenity-3.42.1.tar.xz"
  sha256 "a08e0c8e626615ee2c23ff74628eba6f8b486875dd54371ca7e2d7605b72a87c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "0ebacd1447f8fba2bd8c40e962d3966e53d627b08e365fb9420d8aad83ccec47"
    sha256 arm64_big_sur:  "d356f3fadb082e7d3eae3f5ca6968ec5af1aef95053ce798b45410d9e81f34c4"
    sha256 monterey:       "29cd27529dbfe9f0fce0d640fa36711368869a10d565d067bdd43107e8a1cfed"
    sha256 big_sur:        "d82c92a871f056e04c151f2527b91acecea2d90da4758af1767785aef876a715"
    sha256 catalina:       "44339c221ebcd8115cc581783af487a3ccca81921e228aba029ab6caa08186be"
    sha256 x86_64_linux:   "b54070df2689dec6df7baf5db505445d6a97e2292e3318d1b9f0c11006dc4400"
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk+3"

  def install
    ENV["DESTDIR"] = "/"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    # (zenity:30889): Gtk-WARNING **: 13:12:26.818: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"zenity", "--help"
  end
end
