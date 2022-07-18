class Vile < Formula
  desc "Vi Like Emacs Editor"
  homepage "https://invisible-island.net/vile/"
  url "https://invisible-island.net/archives/vile/current/vile-9.8v.tgz"
  sha256 "240edec7bbf3d9df48b3042754bf9854d9a233d371d50bba236ec0edd708eed5"
  license "GPL-2.0-or-later"

  depends_on "groff" => :build
  uses_from_macos "flex" => :build

  uses_from_macos "libiconv"
  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-imake",
                          "--enable-colored-menus",
                          "--with-ncurses",
                          "--with-screen=ncurses",
                          "--without-x"
    system "make", "install"
  end

  test do
    assert_match "vile ", shell_output("#{bin}/vile -V").chomp
  end
end
