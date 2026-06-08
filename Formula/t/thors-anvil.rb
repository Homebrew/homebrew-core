class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "10.2.3",
      revision: "0d5baccc7801f1ca6fb34d85e168403e1392cddd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4ff481b04c15a188a9ec47f1a1307b3521fb5aa9cd3039f76f3bbaf23ce73752"
    sha256 cellar: :any,                 arm64_sequoia: "5f139c4cec14af2ae2283d1bf935e70e605ca410308db11c6a94b041037e8d70"
    sha256 cellar: :any,                 arm64_sonoma:  "58f66840702b2d2cd9b68e5dc8ce601e8c182d0b1aeaa20266f79aa149d48fe3"
    sha256 cellar: :any,                 sonoma:        "cd510380f6c43bd9c1e3a7af31d56481b9a19b9a72f0b9a52498c75e97746a2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e279891d2a6c03d6aa5020d78b9288e4f9e023ae01daaef1be56475cacdd743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e95b70877410f8c8e91f5da832f76af119b2d484a0530b9f3d01dc1377d7f00b"
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

    system "./brew/init"
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
