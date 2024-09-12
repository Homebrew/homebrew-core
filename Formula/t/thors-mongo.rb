class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https://github.com/Loki-Astari/ThorsMongo"
  url "https://github.com/Loki-Astari/ThorsMongo.git",
      tag:      "3.5.02",
      revision: "8733a8ec1fe890553a1699127b47356a2dd2f529"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8c267bd939aaf07235445fcee5379c5b2f618ed8c942b745ec85d470831416a2"
    sha256 cellar: :any,                 arm64_ventura:  "8abe3e32c842ef0fdd581016bf041afa7314038fd588351cb249b10c8e3ed8fa"
    sha256 cellar: :any,                 arm64_monterey: "c51d7d09f891df450a3fa929e3c142f9cc285fa8e9e45221f724002b7398e7e3"
    sha256 cellar: :any,                 sonoma:         "995b2206fe80e946ca7ac851cd4acf4b7911a19b05d5fd86f1774d46683891ec"
    sha256 cellar: :any,                 ventura:        "50f16fd5603a8b6add9eb654a134da4a404e47e537cd2ffeb4450c48b82e2378"
    sha256 cellar: :any,                 monterey:       "1848a89258d9df9745d39ec01f152faa03b11253dde733f3734e7f828d5353dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "264bb6caee71190932b4c873cf54be8e7ce0cf0a8eb09d6c51c9a11030744c3d"
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
    system "g++", "--version"
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
