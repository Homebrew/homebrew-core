class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      :tag      => "1.10.4",
      :revision => "7228aa6e41dd9eaa8e65a2405e7718cb339c671e"

  bottle do
    cellar :any
    sha256 "4b86902fb5ecb5dcffbcfdc6c1afe86bdf5d3ec84b21ddc1e301cae1f3e1318e" => :mojave
    sha256 "6af70ec467c673387455eba1f4f6d032aa3dd319fc6736192d4a9115f23c9b5f" => :high_sierra
    sha256 "3b5cb856a0c0847a3c33295c1fe320752bedd1fb34b6bf55991d1552d4251d44" => :sierra
  end

  depends_on "libyaml"

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
