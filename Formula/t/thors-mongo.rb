class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https://github.com/Loki-Astari/ThorsMongo"
  url "https://github.com/Loki-Astari/ThorsMongo.git",
      tag:      "6.0.05",
      revision: "f94b98fcc6d81f0436660bb1bf32a49a0ef54cf4"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5e5703ca4466f257fe4df1e87bf5ed931e9b5cf46dbc11e52b57179bb3910ed9"
    sha256 cellar: :any,                 arm64_sonoma:  "69bf675579a5c2979e8f9ec37398f49b2b050a33eb33ee87eb4ee13b713110c8"
    sha256 cellar: :any,                 arm64_ventura: "fa6c6425715f67de5ba77abdc591942750f99b28aed44eedd2d1d8ab551a6ee5"
    sha256 cellar: :any,                 sonoma:        "34c6e8697544a32cea1e57afc0f7775c954f83b520185dfc27e66df9e1ea74c1"
    sha256 cellar: :any,                 ventura:       "7ffeca0a285f66cecedb1e77ad4072bb50d95e71393d85904e7685564b781df3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f842be64e74a323ee4c0116a84c54a1976fe38c221fe556d001b0c4b42d43d7"
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
