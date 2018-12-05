class XmlSecurityC < Formula
  desc "Implementation of primary security standards for XML"
  homepage "https://santuario.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/santuario/c-library/xml-security-c-2.0.2.tar.bz2"
  mirror "https://archive.apache.org/dist/santuario/c-library/xml-security-c-2.0.2.tar.bz2"
  sha256 "39e963ab4da477b7bda058f06db37228664c68fe68902d86e334614dd06e046b"

  bottle do
    cellar :any
    sha256 "a4c67e70aa812e3801f0a06036bf9789a7d83067894e78633ac2afe7d407fbbb" => :mojave
    sha256 "0abac2dae270972195b05a448fbdbda33715debbc6d4dbc8f13635fe677abce2" => :high_sierra
    sha256 "775625bac9adfbfc9112f82f70e716c4d8053354ac62de4bde39416ff4bf7a7a" => :sierra
    sha256 "a1b7250c76b65481fdb7d4f368ade7111ec495dde8c77b3739887c7d17415303" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "xerces-c"

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
