class XmlSecurityC < Formula
  desc "Implementation of primary security standards for XML"
  homepage "https://santuario.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/santuario/c-library/xml-security-c-2.0.1.tar.bz2"
  sha256 "e7e9ccb8fd9d67eb1b981b191c724112f0b45f5b601f5fcc64708ebd6906e791"

  bottle do
    cellar :any
    sha256 "d473445b469fa45fb5767e5a6a083818c28619a5fe36136ae60bcc3bb1f8d8e9" => :high_sierra
    sha256 "0c8c5da1da5c93b28c36b10bb8bd7f9c57bec859a5999497221fa28369df9bf3" => :sierra
    sha256 "969639781722574718521ccf081feb092058716bea28c44337e2b2d9ef50b53f" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "xerces-c"
  depends_on "openssl"

  needs :cxx11

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match /All tests passed/, pipe_output("#{bin}/xsec-xtest 2>&1")
  end
end
