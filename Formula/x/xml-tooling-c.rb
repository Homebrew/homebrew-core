class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.3.0/xmltooling-3.3.0.tar.bz2"
  sha256 "0a2c421be976f3a44b876d6b06ba1f6a2ffbc404f4622f8a65a66c3ba77cb047"
  license "Apache-2.0"
  revision 4

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?xmltooling[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "24f8416d12a12404f420d824d72a8b7ca6a8dfcab15902746c5d4bf3aef12193"
    sha256 cellar: :any, arm64_tahoe:       "d889fdfae1d6248708e26a28c14d68b4e534a8106e921722740038b4db0b70f7"
    sha256 cellar: :any, arm64_sequoia:     "cfd6b7765d312c1fde25856e0b1a57ef15c02a459666a7b8292e333567a781b1"
    sha256 cellar: :any, arm64_linux:       "35257f3fb8970b5f719c149d2887d6b4dd1bc6d70985ae39a889a774aeb93a38"
    sha256 cellar: :any, x86_64_linux:      "ced2458cb470dbbd61bd23b7bb3460f20670d4755431195e9ff65edd790e514b"
  end

  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "curl"
  depends_on "log4shib"
  depends_on "openssl@4"
  depends_on "xerces-c"
  depends_on "xml-security-c"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Apply Ubuntu patch to support OpenSSL 4
  patch do
    url "https://archive.ubuntu.com/ubuntu/pool/universe/x/xmltooling/xmltooling_3.3.0-3ubuntu2.debian.tar.xz"
    sha256 "ec8c5c3729cb90d868ef67f8851d23948e008986cdb986bd118b7dd9a14411a9"
    apply "patches/fix-for-openssl4-compat.patch"
    type :unofficial
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"

    inreplace [lib/"pkgconfig/xmltooling.pc", lib/"pkgconfig/xmltooling-lite.pc"], prefix, opt_prefix
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <xmltooling/XMLToolingConfig.h>
      int main() {
        xmltooling::XMLToolingConfig::getConfig().log_config("CRIT");
        xmltooling::XMLToolingConfig::getConfig().init();
        xmltooling::XMLToolingConfig::getConfig().getPathResolver();
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-L#{lib}", "-lxmltooling", "-L#{formula_opt_lib("xerces-c")}", "-lxerces-c"
    output = shell_output("./test 2>&1")
    refute_match("libcurl lacks OpenSSL-specific options", output)
  end
end
