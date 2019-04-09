class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://wiki.gnome.org/Projects/Zenity"
  url "https://download.gnome.org/sources/zenity/3.32/zenity-3.32.0.tar.xz"
  sha256 "e786e733569c97372c3ef1776e71be7e7599ebe87e11e8ad67dcc2e63a82cd95"

  bottle do
    sha256 "b89a6459e7443dc44c1b169475395d69e17cd5ad470406c6301601b3994d0c2b" => :mojave
    sha256 "0668d5ce6d1ab6bd137ded2a2e00d3884cebad189de0c93b96e4f6ff21d1f2ce" => :high_sierra
    sha256 "c528bd358e65b87fbc82d7b637a8b48319e5a07432cd6ca88bf55a295c008afd" => :sierra
  end

  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"zenity", "--help"
  end
end
