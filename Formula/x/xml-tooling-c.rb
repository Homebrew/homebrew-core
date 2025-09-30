class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/3.3.0/xmltooling-3.3.0.tar.bz2"
  sha256 "0a2c421be976f3a44b876d6b06ba1f6a2ffbc404f4622f8a65a66c3ba77cb047"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?xmltooling[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "30aff8b38565a8ff0f556546fa40157724e1413bd98dbb8add9b51434495f88e"
    sha256 cellar: :any,                 arm64_sequoia: "43c77b2eb3b489049fe4a1923c12ad380f85a8817029da1bc9bfd98a6e7accdf"
    sha256 cellar: :any,                 arm64_sonoma:  "b28b7d9e5601ecfd757a2fe9c5a19e47d859af11a26b8eb39c83b7917ada9060"
    sha256 cellar: :any,                 arm64_ventura: "95b9dfadcc9aa4a18ae2459d7b79c3a12506d4b036f6fbe3cd03c7fa3c2bdeb7"
    sha256 cellar: :any,                 sonoma:        "2e4883f70650b2c17c5e946d67d439926c3cdfc9372d2c63f0dafb99206b0b00"
    sha256 cellar: :any,                 ventura:       "5a302d62d4b80b032df08c5f5089996eb67fcfc069532ede784d678aa5cbad1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de426f7944b9e73ed9281fa8f38c9d75c41c7774aacb57cd29850bb1d36e06e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92ba2dd5fcc658ebf719b038445a0a576b03feb3079ac7cba9c9822b04d8516b"
  end

  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "curl"
  depends_on "log4shib"
  depends_on "openssl@3"
  depends_on "xerces-c"
  depends_on "xml-security-c"

  uses_from_macos "zlib"

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
