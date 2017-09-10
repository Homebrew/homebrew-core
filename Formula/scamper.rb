class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/tools/measurement/scamper/"
  url "https://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20170822.tar.gz"
  sha256 "b239f3c302a4c39b329835794b31a9c80da2b2b43baa674ad881a78f4fc5892c"

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
