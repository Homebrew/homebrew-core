class Vifm < Formula
  desc "Ncurses based file manager with vi like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.9/vifm-0.9.tar.bz2"
  sha256 "ab10c99d1e4c24ff8a03c20be1c202cc15874750cc47a1614e6fe4f8d816a7fd"

  bottle do
    sha256 "43c49f57d80cae5391aa31e7f344b2082e163bf9ff0003988c5fa4f419d46566" => :sierra
    sha256 "427c8115c17a6a7143a2ce8b9a00d1f0639a15d2f61f7492623d6f958351cd35" => :el_capitan
    sha256 "d9eb249223e2cc06049f21e9e14c544d640858d10faafeca395c99005c7c0125" => :yosemite
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
