class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      tag:      "2.1.3",
      revision: "be7fc13c953cb4f04a66238219f300a4f579347c"
  license "MIT"

  bottle do
    cellar :any
    sha256 "febdec67998826f6c02d103d7fc1392791f6674fb33c86dd727278b8b58583d0" => :big_sur
    sha256 "7f6c671e7842eea5f5e6ab76a8e961805fb9f09f16f381101e1037ae2270b220" => :arm64_big_sur
    sha256 "9bbd671562f15494d9bb012ed94d952c101d6864fb8320951fdcab8ea3810a68" => :catalina
    sha256 "52f4348cba84e1b0f2b6f400c9519e094146715c592baf6501eb8772c55c7611" => :mojave
  end

  depends_on "boost" => :build
  depends_on "libyaml"

  def install
    ENV["COV"] = "gcov"

    system "./configure", "--disable-vera",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
           "-I#{Formula["boost"].opt_include}",
           "-I#{include}", "-L#{lib}", "-lThorSerialize17", "-lThorsLogging17"
    system "./test"
  end
end
