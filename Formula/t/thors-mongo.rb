class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https://github.com/Loki-Astari/ThorsMongo"
  url "https://github.com/Loki-Astari/ThorsMongo.git",
      tag:      "4.6.02",
      revision: "099303908620fbc44b535db3d32acc2ca0e9eb04"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15f86b32d54040b2a3524e00249327976516e12a6a218a492b383d1e6b06b1b8"
    sha256 cellar: :any,                 arm64_sonoma:  "b7c7bb3252dfed1c711d3c119e51bea89256cc022384a3259b01ad1bd70826ba"
    sha256 cellar: :any,                 arm64_ventura: "b3d740fb3102b34b85941995fea4a473eef709decaeea4dcdf52608e95689a03"
    sha256 cellar: :any,                 sonoma:        "f2090fa2b637687796ec84b7fd9e73e48e10b2f34c4fdfe3a35b8d1ddcc835fb"
    sha256 cellar: :any,                 ventura:       "1e83087aad1665bd603b41792c83a6364dd91333d1f6069d4db629b823062a2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a71263be827427206e5b78b9c5a442120f14aa779ebde55020c9eddfe8deb30"
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
