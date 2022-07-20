class Vile < Formula
  desc "Vi Like Emacs Editor"
  homepage "https://invisible-island.net/vile/"
  url "https://invisible-island.net/archives/vile/current/vile-9.8v.tgz"
  sha256 "240edec7bbf3d9df48b3042754bf9854d9a233d371d50bba236ec0edd708eed5"
  license "GPL-2.0-or-later"

  uses_from_macos "flex" => :build
  uses_from_macos "groff" => :build
  uses_from_macos "expect" => :test
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "perl"

  def install
    system "./configure", *std_configure_args,
                          "--disable-imake",
                          "--enable-colored-menus",
                          "--with-ncurses",
                          "--without-x",
                          "--with-screen=ncurses"
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    (testpath/"vile.exp").write <<~EOS
      spawn #{bin}/vile
      expect "unnamed"
      send ":w new\r:q\r"
      expect eof
    EOS
    system "expect", "-f", "vile.exp"
    assert_predicate testpath/"new", :exist?
  end
end
