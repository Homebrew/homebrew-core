class Wdc < Formula
  desc "WebDAV Client provides easy and convenient to work with WebDAV-servers."
  homepage "https://designerror.github.io/webdav-client-cpp"
  url "https://github.com/designerror/webdav-client-cpp/archive/v1.0.1.tar.gz"
  sha256 "64b01de188032cb9e09f5060965bd90ed264e7c0b4ceb62bfc036d0caec9fd82"

  bottle do
    cellar :any_skip_relocation
    sha256 "5435df9fc38f858a30b3056dbe52f55b6676d5fcad2198aa28e8fb9b37a5b246" => :sierra
    sha256 "2fef8cabcfa1915fa3faf5e1ec68bb8914b0ec45199e444607009afae9f4abd4" => :el_capitan
    sha256 "01f130bb88f4d9bf33338fb44cd8f2f7067d36d345fa8022c9ccea00a09255d4" => :yosemite
  end

  depends_on "cmake" => :build
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
    system ENV.cc,  "test.cpp", "-L#{lib}", "-L/usr/local/lib",
                    "-lwdc", "-lpthread", "-lpugixml",
                    "-lm", "-lcurl", "-lssl", "-lcrypto",
                    "-lstdc++", "-std=c++11", "-o", "test"
    system "./test"
  end
end
