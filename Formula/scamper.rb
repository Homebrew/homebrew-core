class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/tools/measurement/scamper/"
  url "https://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20161204a.tar.gz"
  sha256 "78eeabed8a4161a2238d02dac4c4361c9fb78f53d52fd8dd4bdb27434b512038"

  bottle do
    cellar :any
    sha256 "626e7d78b4c32c7f8d3c78ae13951767fd4a60be78ad517e01768d36c07df076" => :sierra
    sha256 "0858a7f973b612a47adc86eaf03c37ce41a1520afe0501315636e1be64da9b48" => :el_capitan
    sha256 "7b7b9d125411ca05a453c00bad2268085732e0e5e1bd8e48b7d30d6a8b789631" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
