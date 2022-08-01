class Vile < Formula
  desc "Vi Like Emacs Editor"
  homepage "https://invisible-island.net/vile/"
  url "https://invisible-island.net/archives/vile/current/vile-9.8v.tgz"
  sha256 "240edec7bbf3d9df48b3042754bf9854d9a233d371d50bba236ec0edd708eed5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "2f8b35eb4e569fb97eb705f0e289533f87e760d33bc713dd734d0d5ec4b6c1b1"
    sha256 arm64_big_sur:  "2911233eefb048ba942d43900e0f5fa016afc73aa9ba8cda4cbefaf20e0671e3"
    sha256 monterey:       "6afae967ea6dc6887aee00131e940e82c545893021e24f80841f99271fab6bb6"
    sha256 big_sur:        "278f63fe15bda365d971a13f0243ea324362427d4c54e7fcd309b37ced9f3e6b"
    sha256 catalina:       "7fb308e8e8519b0c57b9d445acb18391a9f8fada7057e2f1efb47e44c58d4a63"
    sha256 x86_64_linux:   "0fa6c246dd0732fc76dbab86f9ecc4eeea16f58ada44a7638893655e16c38015"
  end

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
