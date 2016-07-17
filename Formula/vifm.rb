class Vifm < Formula
  desc "Ncurses based file manager with vi like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.8.2/vifm-0.8.2.tar.bz2"
  sha256 "8b466d766658a24d07fc2039a26fefc6a018f5653684a6035183ca79f02c211f"

  bottle do
    sha256 "46ad2f98c56e9306c00540ead159cbc70f02e4a7947e9f3f80f2408a01752f01" => :el_capitan
    sha256 "140c708112af6fc1c4f7c740abdca3af0e3fc12a8205cfa428800f7794541b6f" => :yosemite
    sha256 "ba80ce8c6d4762404cfd8f1595823ad1d7e347447dbbe50c1d73ad75a10efdcf" => :mavericks
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
