class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https://github.com/Loki-Astari/ThorsMongo"
  url "https://github.com/Loki-Astari/ThorsMongo.git",
      tag:      "8.0.02",
      revision: "6b978082056e1602ce6fb7b5f849c3e66c09f94e"
  license "GPL-3.0-only"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca3983dbd95526122f10a78064e756f3f90d829604cb168a765e0a9e75344360"
    sha256 cellar: :any,                 arm64_sequoia: "89d6d42df7cfc52a30d7884070849f229d2cdc425d56a138a5a6bc68ad44416a"
    sha256 cellar: :any,                 arm64_sonoma:  "5994fb06d923da3c7c68b1ea870607df52d9b82b997d407ca1aff584ad36ef0e"
    sha256 cellar: :any,                 sonoma:        "4021e799de76d216246d7ac2b9363eea560358dac80991d1ff84981635bd8884"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bb7f9b21748fa1496244acb38998fea16dd4a26183bd2fe9088b293f29155a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "531126a413e351f90156162f7ca9265ebe38e72965ea3e846d7847dbe6ecee21"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "magic_enum"
  depends_on "openssl@3"
  depends_on "snappy"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
    ENV.deparallelize
    system "make"
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
