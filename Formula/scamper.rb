class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/tools/measurement/scamper/"
  url "https://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20171204.tar.gz"
  sha256 "556596a138b6a403fbe105affdc7beb8fa98e292767304378c8308fa11b73529"

  bottle do
    cellar :any
    sha256 "4b168f7c545d74832238c7e20eb15ea33be7c350cbf589cadbf15f037eca086f" => :high_sierra
    sha256 "df41e331b530c669f3de0030def505a993a83b2c2800b5ae4b7e9e2ab9234d23" => :sierra
    sha256 "14c56f27c7f7acea88ebaae5606f9bc836f98e0110d340c1b1870d5f48aebe75" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
