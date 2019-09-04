class XmlSecurityC < Formula
  desc "Implementation of primary security standards for XML"
  homepage "https://santuario.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/santuario/c-library/xml-security-c-2.0.2.tar.bz2"
  mirror "https://archive.apache.org/dist/santuario/c-library/xml-security-c-2.0.2.tar.bz2"
  sha256 "39e963ab4da477b7bda058f06db37228664c68fe68902d86e334614dd06e046b"
  revision 1

  bottle do
    cellar :any
    sha256 "b2749de079a163a5e8c00850c3aaa459e772e615641c9fa4766d7352d836414a" => :mojave
    sha256 "ea397178085b69d9068c0d484443233f9450ed3493aa9ee5f769c37c6e422d8a" => :high_sierra
    sha256 "9e677246828b986d73457de275d9c6afe5dd2705aa01445d49a1c1b90e3245de" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "xerces-c"

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match /All tests passed/, pipe_output("#{bin}/xsec-xtest 2>&1")
  end
end
