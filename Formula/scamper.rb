class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/tools/measurement/scamper/"
  url "https://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20180504.tar.gz"
  sha256 "f8e192a12439ccba712870a47fb0a239715f2c43a98df3d1ae6761fa688fe189"

  bottle do
    cellar :any
    sha256 "1f5e9c904d762e67cbecd60d9f8aa55813bb0e59692667fed317035e8c318863" => :high_sierra
    sha256 "d09261ac873347dc1735f48bd1eb47cdf273b9195cff1f134ad89854ce419897" => :sierra
    sha256 "b639bb79c80d2916f5d2954d2f4162cd4615944d6efcb903b42c8c692a93e1d1" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
