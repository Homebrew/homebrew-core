class Wdc < Formula
  desc "WebDAV Client provides easy and convenient to work with WebDAV-servers"
  homepage "https://cloudpolis.github.io/webdav-client-cpp"
  url "https://github.com/CloudPolis/webdav-client-cpp/archive/v1.1.5.tar.gz"
  sha256 "3c45341521da9c68328c5fa8909d838915e8a768e7652ff1bcc2fbbd46ab9f64"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bf82be52c38f175bcfbf0e4bd06af35bfadc8c9f5d59efcb7e40a9afbaca0ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89c0f41a2fb78d5f63e5242652f8a7b5e14991b0ae04949b46ad73d09690f179"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0d034056bfb1e51c26134f639d7d2b0fa3edf5b16ef0956f72b7211efd2103d"
    sha256 cellar: :any_skip_relocation, ventura:        "4fe97e89777f69767c2298717c64ce40f13a4a3a71aaec16a843dff375207991"
    sha256 cellar: :any_skip_relocation, monterey:       "b1c38fc88f4367f244fc4516799ae9fc5c97c71fdcd82a7d1fa8c5c2b2f4bf97"
    sha256 cellar: :any_skip_relocation, big_sur:        "79ee8ab9fd6385a5db733582c6ecb3a28369dd2510f29abc4d02a4ec83d0083c"
    sha256 cellar: :any_skip_relocation, catalina:       "40528e275df5a1df4985b461180eaa795283f0f19f816d0eb249aa14d73ff5d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "979e255fa0e9ef8558dfb3b09e2ae5463d4b00eb0418e8bda1376cc00ab32f11"
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
    curl_args = ["-lcurl"]
    if OS.linux?
      curl = Formula["curl"]
      curl_args << "-L#{curl.opt_lib}"
      curl_args << "-I#{curl.opt_include}"
    end
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-pthread",
                   "-L#{lib}", "-lwdc", "-I#{include}",
                   "-L#{openssl.opt_lib}", "-lssl", "-lcrypto",
                   "-I#{openssl.opt_include}",
                   "-L#{pugixml.opt_lib}", "-lpugixml",
                   "-I#{pugixml.opt_include}",
                   *curl_args
    system "./test"
  end
end
