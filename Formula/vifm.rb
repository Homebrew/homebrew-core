class Vifm < Formula
  desc "Ncurses based file manager with vi like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.10.1/vifm-0.10.1.tar.bz2"
  sha256 "99006f56db05e1bdfb7983e8d5c31c9ac93bf2ac9e0409a577c8ca660fecd03b"

  bottle do
    sha256 "ecd4ded0553705dff6ce635bfd424671e9ce8e4c7aebb279fc4040763041e98b" => :mojave
    sha256 "26afd08c530568c64968da378e4913e169fc478d427ebc70f1aba43dc89cc39b" => :high_sierra
    sha256 "ebeea80fbbce5f75d6541c1ee2b1bad9d29076a84ead9b6b9d019b259d7c3566" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gtk",
                          "--without-libmagic",
                          "--without-X11"
    system "make"
    system "make", "check"

    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vifm --version")
  end
end
