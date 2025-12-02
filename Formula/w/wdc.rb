class Wdc < Formula
  desc "WebDAV Client provides easy and convenient to work with WebDAV-servers"
  homepage "https://cloudpolis.github.io/webdav-client-cpp"
  url "https://github.com/CloudPolis/webdav-client-cpp/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "3c45341521da9c68328c5fa8909d838915e8a768e7652ff1bcc2fbbd46ab9f64"
  license "curl"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6b30e7b5d8ab33c0831c6a217a4f1ec5b28745ba8f068a8fb81e714b6ca75287"
    sha256 cellar: :any,                 arm64_sequoia: "88067ae5f0b55bc266ee7ad8b64e5d6fb4f445965cbfc6b2e212be792f9af9f9"
    sha256 cellar: :any,                 arm64_sonoma:  "e64bd5d5a196023df1f0e99be1501a36a12261cfeafa8674af3605b5f6e0337d"
    sha256 cellar: :any,                 arm64_ventura: "144bf99589283a042b25507aecc6b2865341a806fb9f35436b9ba4aa272476f7"
    sha256 cellar: :any,                 sonoma:        "a5a1823e37f7aced3a355008f7b85768d1c37600c2da80cf385d2efdf5c2543d"
    sha256 cellar: :any,                 ventura:       "253521687c9eb9ef2a8367d1bcbb193617cbce57005ba4fb75558474f2272d20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6027f317ac27ca1e4769b2c7337215d1e81354d627d55ade164b359b1092f524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68eb8337eee2c79f2892966a4311e56a5af9c24e32c07795f7dd8c5089474c8b"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"
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
