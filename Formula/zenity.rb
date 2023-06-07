class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://wiki.gnome.org/Projects/Zenity"
  url "https://download.gnome.org/sources/zenity/3.44/zenity-3.44.1.tar.xz"
  sha256 "d65400aec965411f4c0b3d8e0e0dac54be55d807a29279697537da2dfee93eaa"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "ba1c5c2167851eeccaaa2fc676891b7dd34cf4e3bc8cdf9cf52a8bce3c45f2aa"
    sha256 arm64_monterey: "4164bc0ac6dd94a51d0463466dca94715c51fbef57a2e51dc76d3a424ceb3419"
    sha256 arm64_big_sur:  "8620b50be3b956699488a5a159ba2914a49d7f7d0af440212f7b5697c45e0b86"
    sha256 ventura:        "f38a03a991a768d1d1687106d52980aa2ed47578547c00eff60941cdeb815eda"
    sha256 monterey:       "57d157699df3973bca193a44b8690789cad6dc65d7416eab58dd08d9e9d9b68d"
    sha256 big_sur:        "44fe1a699975c83850ee0f0e7780f95579c017e6d4637587368574f289f03ac3"
    sha256 x86_64_linux:   "643699d19e8bd631b4c84308b0f1e6adcb02f228deb9251599d0246fd5658566"
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
