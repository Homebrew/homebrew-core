class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      :tag      => "1.15.1",
      :revision => "89ee7d6ae390547054c2c8603d8654dbfeff85e4"

  bottle do
    cellar :any
    sha256 "5384f3fe05e0e8104acd67946da1447bd3e9f4032430cdbb0c5f4e79218ee730" => :catalina
    sha256 "e6419d59178dcd4046aee407a495c499bddd7c208aabcaa493c606cd99ff7c3f" => :mojave
    sha256 "be2f7a7646069be3a60a64868321a2eb572c94a77a049a6fd95ecb939d743026" => :high_sierra
  end

  depends_on "libyaml"

  def install
    ENV["COV"] = "gcov"

    system "./configure", "--disable-binary",
                          "--disable-vera",
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
