class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https://github.com/Loki-Astari/ThorsMongo"
  url "https://github.com/Loki-Astari/ThorsMongo.git",
      tag:      "4.2.02",
      revision: "6502639bfa2db6d904fe96e708ce40d04640c6bf"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d4e135ded4f02c304af2392e7ef61b481762394deddfd1d2113fbdf0cc5e0ea3"
    sha256 cellar: :any,                 arm64_sonoma:  "36752ef75cf42dd31f7e03cfcd7a8b6fef25194d89c45950f029a67a9d2f5783"
    sha256 cellar: :any,                 arm64_ventura: "7d841cf5de834a20750dfb068818dcf50e6a367b2f464fd92f16150c764ae3bc"
    sha256 cellar: :any,                 sonoma:        "8ef5d0968634ffff8289dac489d905342aae3a68ad24ab95fe26e5250301d5fb"
    sha256 cellar: :any,                 ventura:       "243a518683661d90fdd26ec2ee6024f8bd08b376df32ba8c346488c658fd0253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d2b19973849927701962e5038e068482c474b9b4ba4df4ebee2893707052064"
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
