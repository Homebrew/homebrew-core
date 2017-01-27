class Xclip < Formula
  desc "Command-line utility that is designed to run on any system with an X11"
  homepage "https://github.com/astrand/xclip"
  url "https://downloads.sourceforge.net/project/xclip/xclip/0.12/xclip-0.12.tar.gz"
  sha256 "b7c7fad059ba446df5692d175c2a1d3816e542549661224806db369a0d716c45"

  depends_on :x11

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/xclip", "-version"
  end
end
