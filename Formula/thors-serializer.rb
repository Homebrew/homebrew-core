class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      :tag      => "1.13.8",
      :revision => "30961b11a014649f5609199467efcf8147791f49"

  bottle do
    cellar :any
    sha256 "ef0908820acc388838e8cccc7f0ff2ee386c2e53d5cc2c5c36be15c97245e763" => :catalina
    sha256 "3d011528fed969a558de8ab2e934a2dd3ebc5d214be7a4b349402e62c7f79dc0" => :mojave
    sha256 "8cb508500dca074ad4a887342eb58742ee105469ba026840becf458a32b448f0" => :high_sierra
    sha256 "410b0132998dd4954fc452f62fad535b572ca39a6cf0e18baeab78242523a07a" => :sierra
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
