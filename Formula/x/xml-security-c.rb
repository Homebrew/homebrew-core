class XmlSecurityC < Formula
  desc "Implementation of primary security standards for XML"
  homepage "https://santuario.apache.org/"
  url "https://shibboleth.net/downloads/xml-security-c/3.0.0/xml-security-c-3.0.0.tar.bz2"
  sha256 "a4c9e1ae3ed3e8dab5d82f4dbdb8414bcbd0199a562ad66cd7c0cd750804ff32"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://shibboleth.net/downloads/xml-security-c/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8e258dd35c83055e4ea2e3f87d161fd6c1e305aef96127aaf3976de906f874cd"
    sha256 cellar: :any, arm64_tahoe:       "221f874bb731ad783cbc0fe9f87f6303312a5bedbc7647ab0a9baf45965bd696"
    sha256 cellar: :any, arm64_sequoia:     "dace6d864716bcdaa77cfd543116acf83ce7a2d4f673d85d16bda59a060addc5"
    sha256 cellar: :any, arm64_linux:       "3391151d9c7264e40ff760b6c7664adc6d2232a831d1b339e57f5b8fc439778b"
    sha256 cellar: :any, x86_64_linux:      "e8ad0a14dfa3bdcdd9cdd2642388f0d736a18aadd1d2e7c5c8b53dab1313d8d1"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"
  depends_on "xerces-c"

  # Apply Debian patch to avoid segfault in test
  patch do
    url "https://sources.debian.org/data/main/x/xml-security-c/3.0.0-2/debian/patches/Provide-the-Xerces-URI-Resolver-for-the-tests.patch"
    sha256 "585938480165026990e874fecfae42601dde368f345f1e6ee54b189dbcd01734"
    type :unofficial
  end

  # Apply Ubuntu patch to support OpenSSL 4
  patch do
    url "https://archive.ubuntu.com/ubuntu/pool/universe/x/xml-security-c/xml-security-c_3.0.0-2ubuntu2.debian.tar.xz"
    sha256 "bfbf7ad525046e4b76a91ac034b103da0d63e14118c9778877af5c8f85e62a86"
    apply "patches/fix-for-openssl4-compat.patch"
    type :unofficial
  end

  def install
    system "./configure", "--with-openssl=#{formula_opt_prefix("openssl@4")}", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "All tests passed", pipe_output("#{bin}/xsec-xtest 2>&1")
  end
end
