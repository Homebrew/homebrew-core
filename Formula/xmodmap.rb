class Xmodmap < Formula
  desc "Modify keymaps and pointer button mappings in X"
  homepage "https://gitlab.freedesktop.org/xorg/app/xmodmap"
  url "https://www.x.org/releases/individual/app/xmodmap-1.0.11.tar.xz"
  sha256 "9a2f8168f7b0bc382828847403902cb6bf175e17658b36189eac87edda877e81"
  license "MIT-open-group"

  depends_on "pkg-config"  => :build
  depends_on "xorgproto"   => :build
  depends_on "xorg-server" => :test

  depends_on "libx11"

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    fork do
      exec Formula["xorg-server"].bin/"Xvfb", ":1"
    end
    ENV["DISPLAY"] = ":1"
    sleep 10
    assert_match "pointer buttons defined", shell_output(bin/"xmodmap -pp")
  end
end
