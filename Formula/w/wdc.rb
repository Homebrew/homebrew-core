class Wdc < Formula
  desc "WebDAV Client provides easy and convenient to work with WebDAV-servers"
  homepage "https://cloudpolis.github.io/webdav-client-cpp"
  url "https://github.com/CloudPolis/webdav-client-cpp/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "3c45341521da9c68328c5fa8909d838915e8a768e7652ff1bcc2fbbd46ab9f64"
  license "curl"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7936af69dde22084ed7f8e49514403a1c9b9aa82938548ea110cb466aace40ce"
    sha256 cellar: :any,                 arm64_sequoia: "f5f2eb2d863e95dfe16936400d38d639503fdca5d2b5130012e14237b0801a6b"
    sha256 cellar: :any,                 arm64_sonoma:  "47ef26615ac4537bd7adc342a54ec5f44ac088dcdff80cc56a592b1a3dbd573e"
    sha256 cellar: :any,                 sonoma:        "4731f9ad6c7028ef56322152f5806e2371a048cdd8cafb6d9e5fee41dcff3337"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddbcb3d0568595c508fdfc4d351459bcaa751ad816407a671d88a6d5ddf8fa2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e37799dd0aaf7639a3871401f48ab30e287255eb6cf295e1fabba3331425fae"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@4"
  depends_on "pugixml"

  uses_from_macos "curl"

  def install
    inreplace "CMakeLists.txt", "CURL CONFIG REQUIRED", "CURL REQUIRED"

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    "-DHUNTER_ENABLED=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    pugixml = Formula["pugixml"]
    curl_args = ["-lcurl"]
    if OS.linux?
      curl = Formula["curl"]
      curl_args << "-L#{curl.opt_lib}"
      curl_args << "-I#{curl.opt_include}"
    end
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-pthread",
                   "-L#{lib}", "-lwdc", "-I#{include}",
                   "-L#{pugixml.opt_lib}", "-lpugixml",
                   "-I#{pugixml.opt_include}",
                   *curl_args
    system "./test"
  end
end
