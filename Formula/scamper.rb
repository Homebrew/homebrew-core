class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/tools/measurement/scamper/"
  url "https://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20141211e.tar.gz"
  version "20141211e"
  sha256 "5b8c81a6e4703253625e872323a7c16242a13de0d8edd3ec5ff8441d43f40a29"

  bottle do
    cellar :any
    sha256 "1dc57d10084cc92178a0824c552dd014fdac0d44372309b4f5a6d30d7c9120d5" => :el_capitan
    sha256 "812c9f540f76595b237570cfec1ffac14be32a8e013a4209b73cce9967369905" => :yosemite
    sha256 "81c7d9bc7aa27886acf4e1ae5e95dfab2539332ac98f6a3220ee2b463dd1b7b1" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
