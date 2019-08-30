class Wdc < Formula
  desc "WebDAV Client provides easy and convenient to work with WebDAV-servers"
  homepage "https://designerror.github.io/webdav-client-cpp"
  url "https://github.com/designerror/webdav-client-cpp/archive/v1.0.1.tar.gz"
  sha256 "64b01de188032cb9e09f5060965bd90ed264e7c0b4ceb62bfc036d0caec9fd82"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "032a33394e17f8815884d95b723081a059b6ff67c2dede3399782531ca239efa" => :mojave
    sha256 "8bccdfeac8fe563d940504f4674ea55443cc9a34fbd87411a5a14037e720f47d" => :high_sierra
    sha256 "de61e873a1a9eb37c29778ccbc7c0f8ceae61ca7b19cf98c45ec1a4569a842df" => :sierra
    sha256 "6ede103d6893034ebd55d00f47d00056a081bfa0ca0a7dd51e06330896dbb743" => :el_capitan
    sha256 "9bf61a23f849c5f60314ef58bdf3f988ed98618601eea67a65949e89f52593eb" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "pugixml"

  def install
    pugixml = Formula["pugixml"]
    ENV.prepend "CXXFLAGS", "-I#{pugixml.opt_include.children.first}"
    system "cmake", ".", "-DPUGIXML_INCLUDE_DIR=#{pugixml.opt_include}",
                         "-DPUGIXML_LIBRARY=#{pugixml.opt_lib}", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    openssl = Formula["openssl@1.1"]
    system ENV.cc, "test.cpp", "-o", "test", "-lcurl", "-lstdc++", "-std=c++11",
                   "-L#{lib}", "-lwdc", "-I#{include}",
                   "-L#{openssl.opt_lib}", "-lssl", "-lcrypto",
                   "-I#{openssl.opt_include}",
                   "-L#{Dir["#{pugixml.opt_lib}/pug*"].first}", "-lpugixml",
                   "-I#{pugixml.opt_include.children.first}"
    system "./test"
  end
end
