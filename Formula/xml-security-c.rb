class XmlSecurityC < Formula
  desc "Implementation of primary security standards for XML"
  homepage "https://santuario.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=/santuario/c-library/xml-security-c-1.7.3.tar.gz"
  sha256 "e5226e7319d44f6fd9147a13fb853f5c711b9e75bf60ec273a0ef8a190592583"
  revision 1

  bottle do
    cellar :any
    sha256 "61e946e23456e4572fa15865bc8d113a8941a5831b9c1572d7ec871fff603098" => :high_sierra
    sha256 "9c6fbd5beba054bfa6c023133f27efb2a5441bd7facc05682101045d96e78b21" => :sierra
    sha256 "c0ae50ab8c6dff34a904a2419ac386f6da960d64b3ba745c0244cbfbd75bd1bc" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "xerces-c"
  depends_on "openssl"

  needs :cxx11

  # See https://issues.apache.org/jira/browse/SANTUARIO-471
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/xml-security-c/c%2B%2B11.patch"
    sha256 "b8ced4b8b7977d7af0d13972e1a0c6623cbc29804ec9fea1eb588f0869503b1c"
  end

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match /All tests passed/, pipe_output("#{bin}/xtest 2>&1")
  end
end
