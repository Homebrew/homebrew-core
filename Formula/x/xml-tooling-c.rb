class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.3.0/xmltooling-3.3.0.tar.bz2"
  sha256 "0a2c421be976f3a44b876d6b06ba1f6a2ffbc404f4622f8a65a66c3ba77cb047"
  license "Apache-2.0"
  revision 2

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?xmltooling[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "98e9218a11ab243b50f41dc092aa691ea2b67e377c8f4c3180b2534daa3e282a"
    sha256 cellar: :any,                 arm64_sequoia: "88e0d5685d1d26583ce3cac5ae06004e09c1e644a994cbd842edf135c387eeee"
    sha256 cellar: :any,                 arm64_sonoma:  "67698bf4e3539ca4a65b1abedf1412bebfca329752966af395fb6ad26fd01674"
    sha256 cellar: :any,                 sonoma:        "bdccad5c69d8fc2e9b803d308e2a577e186d73126f2550e173bb6e73b5270d12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a2daaf7d5f7c2851c7aedbe0916231d6f05a86bcca21deb89878a69160a8044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e44b389fa4a9ef04945d051fd6b66e6a22b4389b968eccdcae9a1634a221886"
  end

  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "curl"
  depends_on "log4shib"
  depends_on "openssl@3"
  depends_on "xerces-c"
  depends_on "xml-security-c"

  on_sequoia do
    depends_on xcode: ["16.4", :build]
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
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
                    "-L#{lib}", "-lxmltooling", "-L#{Formula["xerces-c"].opt_lib}", "-lxerces-c"
    output = shell_output("./test 2>&1")
    refute_match("libcurl lacks OpenSSL-specific options", output)
  end
end
