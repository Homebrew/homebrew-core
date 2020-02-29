class Wdc < Formula
  desc "WebDAV Client provides easy and convenient to work with WebDAV-servers"
  homepage "https://cloudpolis.github.io/webdav-client-cpp"
  url "https://github.com/CloudPolis/webdav-client-cpp/archive/v1.1.5.tar.gz"
  sha256 "3c45341521da9c68328c5fa8909d838915e8a768e7652ff1bcc2fbbd46ab9f64"

  bottle do
    cellar :any_skip_relocation
    sha256 "18365f76dafd05a312e9a7862f2fa747caa8c63e881469719a8ef45d07dce3c6" => :catalina
    sha256 "fbcaccbaa2440ac38f9efa41a342eef4d883e522fa5df7d642aaa1563d38f28b" => :mojave
    sha256 "92dcb68d02f64ff51446052bf5c41fa178cc48ade406a9533199461476f7c849" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "pugixml"

  uses_from_macos "curl"

  def install
    pugixml = Formula["pugixml"]
    ENV.prepend "CXXFLAGS", "-I#{pugixml.opt_include.children.first}"
    inreplace "CMakeLists.txt", "CURL CONFIG REQUIRED", "CURL REQUIRED"
    system "cmake", ".", "-DPUGIXML_INCLUDE_DIR=#{pugixml.opt_include}",
                         "-DPUGIXML_LIBRARY=#{pugixml.opt_lib}",
                         "-DHUNTER_ENABLED=OFF", *std_cmake_args
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
        std::unique_ptr<WebDAV::Client> client{ new WebDAV::Client{ options } };
        auto check_connection = client->check();
        assert(!check_connection);
      }
    EOS
    pugixml = Formula["pugixml"]
    openssl = Formula["openssl@1.1"]
    system ENV.cxx, "test.cpp", "-o", "test", "-lcurl", "-std=c++11",
                   "-L#{lib}", "-lwdc", "-I#{include}",
                   "-L#{openssl.opt_lib}", "-lssl", "-lcrypto",
                   "-I#{openssl.opt_include}",
                   "-L#{pugixml.opt_lib}", "-lpugixml",
                   "-I#{pugixml.opt_include}"
    system "./test"
  end
end
