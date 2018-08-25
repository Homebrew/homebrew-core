class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      :tag => "1.8.2",
      :revision => "595c7690f9e8a08fa5bfce1c7d703a3724136878"

  bottle do
    cellar :any
    sha256 "182f8d09a661835876b0a9dcdda459fde61bf5825c20b7ab2b2c5f68d83b3474" => :high_sierra
    sha256 "0e6f157a21e63d4b6df9cd4d836d774e49ed48cec94f56f52f7e441ce6640e04" => :sierra
    sha256 "dac6b3ac6f6e5a0f9bcd71695944700baf2a726a94aca3695ffb538732483391" => :el_capitan
  end

  depends_on "libyaml"

  needs :cxx14

  def install
    ENV["COV"] = "gcov"

    system "./configure", "--disable-binary",
                          "--disable-vera",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "ThorSerialize/JsonThor.h"
      #include "ThorSerialize/SerUtil.h"
      #include <sstream>
      #include <iostream>
      #include <string>

      struct Block
      {
          std::string             key;
          int                     code;
      };
      ThorsAnvil_MakeTrait(Block, key, code);

      int main()
      {
          using ThorsAnvil::Serialize::jsonImport;
          using ThorsAnvil::Serialize::jsonExport;

          std::stringstream   inputData(R"({"key":"XYZ","code":37373})");

          Block    object;
          inputData >> jsonImport(object);

          if (object.key != "XYZ" || object.code != 37373) {
              std::cerr << "Fail";
              return 1;
          }
          std::cerr << "OK";
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
           "-I#{include}", "-L#{lib}", "-lThorSerialize17"
    system "./test"
  end
end
