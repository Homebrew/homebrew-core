class Wdc < Formula
  desc "WebDAV Client provides easy and convenient to work with WebDAV-servers."
  homepage "https://designerror.github.io/webdav-client-cpp"
  url "https://github.com/designerror/webdav-client-cpp/archive/v1.0.3.tar.gz"
  sha256 "e0297e72fa09656e0f38745560a10a77f5d640122966edc2ffcd3cc58ef1a03f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "de61e873a1a9eb37c29778ccbc7c0f8ceae61ca7b19cf98c45ec1a4569a842df" => :sierra
    sha256 "6ede103d6893034ebd55d00f47d00056a081bfa0ca0a7dd51e06330896dbb743" => :el_capitan
    sha256 "9bf61a23f849c5f60314ef58bdf3f988ed98618601eea67a65949e89f52593eb" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "pugixml"

  def install
    pugixml = Formula["pugixml"]
    ENV.prepend "CXXFLAGS", "-I#{pugixml.opt_include.children.first}"
    system "cmake", ".", "-DPUGIXML_INCLUDE_DIR=#{pugixml.opt_include}",
                         "-DPUGIXML_LIBRARY=#{pugixml.opt_lib}", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <webdav/client.hpp>
      #include <cassert>
      #include <string>
      #include <memory>
      #include <map>
      int main(int argc, char *argv[]) {
        std::map<std::string, std::string> options =
        {
          {"webdav_hostname", "https://webdav.example.com"},
          {"webdav_login",    "webdav_login"},
          {"webdav_password", "webdav_password"}
        };
        std::shared_ptr<WebDAV::Client> client(WebDAV::Client::Init(options));
        auto check_connection = client->check();
        assert(!check_connection);
      }
    EOS
    pugixml = Formula["pugixml"]
    openssl = Formula["openssl"]
    system ENV.cc, "test.cpp", "-o", "test", "-lcurl", "-lstdc++", "-std=c++11",
                   "-L#{lib}", "-lwdc", "-I#{include}",
                   "-L#{openssl.opt_lib}", "-lssl", "-lcrypto",
                   "-I#{openssl.opt_include}",
                   "-L#{Dir["#{pugixml.opt_lib}/pug*"].first}", "-lpugixml",
                   "-I#{pugixml.opt_include.children.first}"
    system "./test"
  end
end
