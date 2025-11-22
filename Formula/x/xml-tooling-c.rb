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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8066c92da48faaf215c42fe835ee7897ab96f1ef69a998bc320f770f4b3972e4"
    sha256 cellar: :any,                 arm64_sequoia: "630e6250b3e920b48594b4ad12d9b767c11d4125cda066d9e31e21c574726115"
    sha256 cellar: :any,                 arm64_sonoma:  "28f81943a2555ac19238557bb770c0be88a0960094e746b7ad76dfe8d4d0c7b2"
    sha256 cellar: :any,                 sonoma:        "2d015bc6fc3598c7e92532dd2c59c6cc409b9c338919428b739e55d830d9ba9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb1b9d4b9ccbc7d694a610e1a0cb3f3f8e6d6c3a2dee3d8f23fd79b383d8d8bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1fc1fab678ee891d8859fdfcc0c454305cd669fb9d47503269318a86ba6c25a"
  end

  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "curl"
  depends_on "log4shib"
  depends_on "openssl@3"
  depends_on "xerces-c"
  depends_on "xml-security-c"

  uses_from_macos "zlib"

  on_sequoia do
    depends_on xcode: ["16.4", :build]
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
