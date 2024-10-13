class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https://github.com/Loki-Astari/ThorsMongo"
  url "https://github.com/Loki-Astari/ThorsMongo.git",
      tag:      "4.5.01",
      revision: "32f4f9c8ba5f019f59ae5c4cdd2ad63b9af8903b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bfa5bcc80e889c79800aab1cf903fe61645e1e4d9d58796e158fd9d8a6929b51"
    sha256 cellar: :any,                 arm64_sonoma:  "2e26ec24da955d77cda1328d1e378ce16a5c3e86c827f4b0e35242fa4a80fac5"
    sha256 cellar: :any,                 arm64_ventura: "f817bc8a40defeaa8d6c552cabe89ca25e0d8a6f9ad37376897a7860c76b1123"
    sha256 cellar: :any,                 sonoma:        "a30e2d46a6375baaa79682cc1264492a380605fd3452934e916ada2cc8e2ab9f"
    sha256 cellar: :any,                 ventura:       "1df9cbbc8929724137a51c814bce1c08733e240d7d09ffa8ceec9c35d59e33b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36f81f7d1cdca48f165245cc39c4ea500e1b5c52f32d94c280eb44128a6e483b"
  end

  depends_on "libyaml"
  depends_on "magic_enum"
  depends_on "openssl@3"
  depends_on "snappy"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    ENV["COV"] = "gcov"

    system "./brew/init"

    system "./configure", "--disable-vera",
                          "--prefix=#{prefix}",
                          "--disable-test-with-integration",
                          "--disable-test-with-mongo-query",
                          "--disable-Mongo-Service"

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
    system ENV.cxx, "-std=c++20", "test.cpp", "-o", "test",
           "-I#{include}", "-L#{lib}", "-lThorSerialize", "-lThorsLogging", "-ldl"
    system "./test"
  end
end
