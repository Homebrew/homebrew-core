class Vifm < Formula
  desc "Ncurses based file manager with vi like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.9.1/vifm-0.9.1.tar.bz2"
  sha256 "28b9a4b670d9ddc9af8c9804dc22fa93f4fd0adabce94d43ebedc157a5dce7b3"

  bottle do
    sha256 "351bfdaa028f9ffd3265391ac9dcd27e5f9818a18fe40dcabfe5adfa84ff920d" => :high_sierra
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
