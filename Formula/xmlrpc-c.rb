class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "https://xmlrpc-c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.51.06/xmlrpc-c-1.51.06.tgz"
  sha256 "06dcd87d9c88374559369ffbe83b3139cf41418c1a2d03f20e08808085f89fd0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "4bf06fc636da854ff791a9d0af52db23e08b42fa9b8fe062cf22e10c57605822" => :big_sur
    sha256 "43d9a3b95d745bc46c1a22e4d853a7f874d3f833c437032963331490a34ce00b" => :arm64_big_sur
    sha256 "f7d6a12c5e57d9ceb97b88dba518a6bae79e41e95343395a3f3c94bc168c92ab" => :catalina
    sha256 "638d1d6484717f57228174db4b9e875798b3ee1558ac6bcab59c96d80fcdab56" => :mojave
    sha256 "88a9ab0c2baea0aac627427628b00bce6828e5fc436533c0de8cfb0a99c21a24" => :high_sierra
  end

  def install
    ENV.deparallelize
    # --enable-libxml2-backend to lose some weight and not statically link in expat
    system "./configure", "--enable-libxml2-backend",
                          "--prefix=#{prefix}"

    # xmlrpc-config.h cannot be found if only calling make install
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/xmlrpc-c-config", "--features"
  end
end
