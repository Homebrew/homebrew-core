class Xclip < Formula
  desc "Command-line utility that is designed to run on any system with an X11"
  homepage "https://github.com/astrand/xclip"
  url "https://downloads.sourceforge.net/project/xclip/xclip/0.12/xclip-0.12.tar.gz"
  sha256 "b7c7fad059ba446df5692d175c2a1d3816e542549661224806db369a0d716c45"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2b9571202947dbcb572e6a30c7083a67f95d1a2df67cbf4e416a386ac3b8f5b" => :sierra
    sha256 "4e5bfbd56dbb84b22542d930e261c0a45e23e287064e19b3932926af6c214466" => :el_capitan
    sha256 "6870e6606bfbbb10f29d212beae6aa9cdb1fed938a2fe9e54b0acf15ae09de0e" => :yosemite
  end

  depends_on :x11

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/xclip", "-version"
  end
end
