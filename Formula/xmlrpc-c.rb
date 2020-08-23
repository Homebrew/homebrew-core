class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "https://xmlrpc-c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.51.06/xmlrpc-c-1.51.06.tgz"
  sha256 "06dcd87d9c88374559369ffbe83b3139cf41418c1a2d03f20e08808085f89fd0"

  bottle do
    cellar :any
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
