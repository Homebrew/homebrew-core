class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      :tag => "1.8.4",
      :revision => "a4731926c876fb5352857822163aa5b10efcf2b3"

  bottle do
    cellar :any
    sha256 "46a4cf2b6dde0a36798675dc0a91ab0e7dc53083ca1e939d5be9fe4ed8a3797b" => :mojave
    sha256 "2d28e54c2bd7122391c29fb23f6ae56aee7ec15e809a0b92289b813d9581ba32" => :high_sierra
    sha256 "93fcbc206aeec785f4e3b702f5fcac69f0c8ae380ea7c927dd5610511c570e3c" => :sierra
    sha256 "ccdd899f310be6b41c5390df81a8db5679c488058ccc8b2b442c5ad8b1603b44" => :el_capitan
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
