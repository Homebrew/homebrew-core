class Wdc < Formula
  desc "WebDAV Client provides easy and convenient to work with WebDAV-servers"
  homepage "https://cloudpolis.github.io/webdav-client-cpp"
  url "https://github.com/CloudPolis/webdav-client-cpp/archive/v1.1.5.tar.gz"
  sha256 "3c45341521da9c68328c5fa8909d838915e8a768e7652ff1bcc2fbbd46ab9f64"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62495852d3c1071bf9d1f3121e330edae3fdbc9e9c63fb65e766be3f38c2a885"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be11e8b817c20749111b09db86ff335c6c97bad37575f715e9a7e7ec7ca0335a"
    sha256 cellar: :any_skip_relocation, monterey:       "c039308564cb3c12b33cd01344b939187d0172426fc8d3beb277bf4a55ce8843"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0d2e5d13ef2dca786d050eb726cdd240a8c7da8f56868f2a85aae67ee99ee8c"
    sha256 cellar: :any_skip_relocation, catalina:       "18365f76dafd05a312e9a7862f2fa747caa8c63e881469719a8ef45d07dce3c6"
    sha256 cellar: :any_skip_relocation, mojave:         "fbcaccbaa2440ac38f9efa41a342eef4d883e522fa5df7d642aaa1563d38f28b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "92dcb68d02f64ff51446052bf5c41fa178cc48ade406a9533199461476f7c849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "540ee4f07372f9080c4cf88d17a067379fbef4af4f69240cfced99f4944c07df"
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
