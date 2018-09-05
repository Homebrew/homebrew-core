class Vifm < Formula
  desc "Ncurses based file manager with vi like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.9.1/vifm-0.9.1.tar.bz2"
  sha256 "28b9a4b670d9ddc9af8c9804dc22fa93f4fd0adabce94d43ebedc157a5dce7b3"

  bottle do
    sha256 "f390e5effa7cc533944c35e9ea4f389b0ab38780f2011c69de759e8bc7dbe784" => :mojave
    sha256 "85ed156c78b6259286e1bbde0559efbb7d184f061f1fe6d7dfa3c9e73262cbce" => :high_sierra
    sha256 "7123769c4a1a3ea3e59871d3150182bbf3da2d98a4036b3a06a39ebacfaf65ed" => :sierra
    sha256 "88bda24c638a68880447a6e10dcfa06ac2e49a2b77415b6a85ac3dfd33c20114" => :el_capitan
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
