class Vile < Formula
  desc "Vi Like Emacs Editor"
  homepage "https://invisible-island.net/vile/"
  url "https://invisible-island.net/archives/vile/current/vile-9.8v.tgz"
  sha256 "240edec7bbf3d9df48b3042754bf9854d9a233d371d50bba236ec0edd708eed5"
  license "GPL-2.0-or-later"

  uses_from_macos "flex" => :build
  uses_from_macos "groff" => :build
  uses_from_macos "libiconv"
  uses_from_macos "ncurses"

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
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/vile -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end
