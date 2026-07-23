class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "11.1.0",
      revision: "679f2c1136293f0275a87f7a718c161aa085ee20"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "98edd3be9c921b930dbe0f9913452147d79e22c3ce5f72f1e43e280fae68c199"
    sha256 cellar: :any, arm64_sequoia: "09543e3761c37183441c582d82070da65eaa7963cc86d84d00900e48ad499ba6"
    sha256 cellar: :any, arm64_sonoma:  "73dcf65e075b0d906879c31dd9ea088434707aefab295f3b8e81410b3b3bb929"
    sha256 cellar: :any, sonoma:        "4ed7f7c8c5d885fd2fb63f31adb5829b87962096b120f24a8856a24ada66c476"
    sha256 cellar: :any, arm64_linux:   "bb44e67ff8909c9cd1cd808064bdc855f98266ec1557dfa37243513ce83aaa6d"
    sha256 cellar: :any, x86_64_linux:  "7c86616a1ff8ed2683b87e98e5577833ebb6551ffa400888f15f16283fb6b208"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "magic_enum"
  depends_on "openssl@3"
  depends_on "snappy"
  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["COV"] = "gcov"
    # Workaround for failure when building with Xcode std::from_chars
    # src/Serialize/./StringInput.h:104:27: error: call to deleted function 'from_chars'
    ENV.append_to_cflags "-DNO_STD_SUPPORT_FROM_CHAR_DOUBLE=1" if DevelopmentTools.clang_build_version == 1700

    system "./configure", "--disable-vera",
                          "--disable-test-with-integration",
                          "--disable-test-with-mongo-query",
                          "--disable-Mongo-Service",
                          "--disable-slacktest",
                          *std_configure_args
    ENV["DISABLE_CONTROL_CODES"] = "TRUE"
    system "make", "-j", "1", "JOBS=" + ENV.make_jobs.to_s
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "ThorSerialize/JsonThor.h"
      #include "ThorSerialize/SerUtil.h"
      #include <sstream>
      #include <iostream>
      #include <string>

      struct HomeBrewBlock
      {
          std::string             key;
          int                     code;
      };
      ThorsAnvil_MakeTrait(HomeBrewBlock, key, code);

      int main()
      {
          using ThorsAnvil::Serialize::jsonImporter;
          using ThorsAnvil::Serialize::jsonExporter;

          std::stringstream   inputData(R"({"key":"XYZ","code":37373})");

          HomeBrewBlock    object;
          inputData >> jsonImporter(object);

          if (object.key != "XYZ" || object.code != 37373) {
              std::cerr << "Fail";
              return 1;
          }
          std::cerr << "OK";
          return 0;
      }
    CPP
    system ENV.cxx, "-std=c++20", "test.cpp", "-o", "test",
           "-I#{include}", "-L#{lib}", "-lThorSerialize", "-lThorsLogging", "-ldl"
    system "./test"
  end
end
