class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://wiki.gnome.org/Projects/Zenity"
  url "https://download.gnome.org/sources/zenity/3.42/zenity-3.42.1.tar.xz"
  sha256 "a08e0c8e626615ee2c23ff74628eba6f8b486875dd54371ca7e2d7605b72a87c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "11f9ebc29350cee0d9d7769c37f4ecbf36c9484061e6705cfd5b51f599b19612"
    sha256 arm64_monterey: "a9e84c3b0eefa50aafb0f41cc6e0a9ccdce95ece584680c1d14591fd9fa4250c"
    sha256 arm64_big_sur:  "0df17f657645d0075244735559ee97fb35ea64356843f5a1be5bbb1f29472293"
    sha256 ventura:        "67c6c5160dfa1556312abfd19bd34173a757d118071667c34bf2cdda98a680d5"
    sha256 monterey:       "c102812429cf49155840fd2aeccae7bda7aec45f26ebea12848b628aa4f44397"
    sha256 big_sur:        "e3b50cd62e794c4efe5355adb5eafabc4d93b2785a6fc1a8c638eb5bae681aee"
    sha256 catalina:       "98f1939e7cf78bc7a66329c20e84f0067009d3e7be13d9f3b2f2156ea11f5b26"
    sha256 x86_64_linux:   "3b64e8ebc5f116dc1d0b85f9c42f2a0adb7e0cdbef3930fc69eb249a8b0d1374"
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
