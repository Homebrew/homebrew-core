class Wdc < Formula
  desc "WebDAV Client provides easy and convenient to work with WebDAV-servers."
  homepage "https://designerror.github.io/webdav-client-cpp"
  url "https://github.com/designerror/webdav-client-cpp/archive/v#{version}.tar.gz"
  version "1.0.0"
  sha256 "938aa52ae96595d0370f4d6d13beb7b70bbea56434aecd6259e7ead2dd6f9050"

  depends_on "cmake" => :build
  depends_on "curl"
  depends_on "openssl"
  depends_on "pugixml"

  def install
    system "cmake", ".", *std_cmake_args
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
     
    system ENV.cc, "test.cpp", "-L#{lib}", "-lwebdavclient", "-lpugixml", "-lcurl", "-lssl", "-lcrypto",  "-lstdc++", "-std=c++11", "-o", "test"
    system "./test"
  end 
end
