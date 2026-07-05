class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "11.0.6",
      revision: "2253c73c0360746f94218b4fe32908ee2214c0b9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3237331d2a53bed86fd350f88d01695e891db156496bf73135ddf5018b705af8"
    sha256 cellar: :any, arm64_sequoia: "d1a02c2ee851463f04e75cd8347dac6703908fc48fc6b343b2026fda9e7af049"
    sha256 cellar: :any, arm64_sonoma:  "31b0e2e3c22d10faedbd273c625fcb827cfb8e8ded63105083b45f85b4901369"
    sha256 cellar: :any, sonoma:        "501e68035c990538d3322ed40ed8e43776380daa2dcf83df4c8852945ae2690e"
    sha256 cellar: :any, arm64_linux:   "f964763633c8c9b53eb5fd77d19107e7e2a83dd3b04b86a65a898e8f30b7c510"
    sha256 cellar: :any, x86_64_linux:  "236342ade5655d2b8736d39e4bad0ca22758e3eec5cd80e730723fa521816ce3"
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
