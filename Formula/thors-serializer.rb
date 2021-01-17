class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      tag:      "2.1.2",
      revision: "735427a7ceb8317f62eee844e51dc2820cfba8cb"
  license "MIT"

  bottle do
    cellar :any
    sha256 "32d1ca4b2195bca9c17d3ff542155985cf56216880f2d9885f66876dca5fe7ce" => :big_sur
    sha256 "dc277afe1f6b2ba3f83d0e8deca405465ddf484aecc234b2531b1eefa20dd195" => :arm64_big_sur
    sha256 "6e736c6c9c571624bf6b53fab2f63921f56a1d5cc875375a1120676ee4d34f04" => :catalina
    sha256 "e1ed8ab93ffd5f40791935c90464a3a90ed77440fc720910bfc3cb8fe149a395" => :mojave
  end

  depends_on "boost" => :build
  depends_on "libyaml"

  def install
    ENV["COV"] = "gcov"

    system "./configure", "--disable-vera",
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
           "-I#{Formula["boost"].opt_include}",
           "-I#{include}", "-L#{lib}", "-lThorSerialize17", "-lThorsLogging17"
    system "./test"
  end
end
