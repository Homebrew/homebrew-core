class Vile < Formula
  desc "Vi Like Emacs Editor"
  homepage "https://invisible-island.net/vile/"
  url "https://invisible-island.net/archives/vile/current/vile-9.8v.tgz"
  sha256 "240edec7bbf3d9df48b3042754bf9854d9a233d371d50bba236ec0edd708eed5"
  license "GPL-2.0-or-later"

  uses_from_macos "flex" => :build
  uses_from_macos "groff" => :build
  uses_from_macos "ncurses"
  uses_from_macos "perl"

  def install
    system "./configure", *std_configure_args,
                          "--disable-imake",
                          "--enable-colored-menus",
                          "--with-ncurses",
                          "--with-screen=ncurses",
                          "--without-x"
    system "make", "install"
  end

  test do
    require "pty"

    PTY.spawn(bin/"vile") do |_, w,|
      r.winsize = [80, 40]
      w.write ":w new\n"
      w.write ":q\n"
    end
    sleep 5
    assert_predicate testpath/"new", :exist?
  end
end
