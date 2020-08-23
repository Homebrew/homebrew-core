class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      tag:      "2.0.15",
      revision: "a3105857c3c12365a61c79d96e3a938b1942c385"
  license "MIT"

  bottle do
    cellar :any
    sha256 "b03bf969cade0d22b86d88ad9c7414ee49c585bed65b3aed18dc28c24bd5ddf4" => :catalina
    sha256 "eddf2665dbf5da0f54b4ad942a4b78214afa0242f22106b91a55e6868bb5a2a5" => :mojave
    sha256 "8649be65f46b9cbde2fadc93962d4ad4a4e06478ead0469505ba6c5fa4ea36c4" => :high_sierra
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
           "-I#{include}", "-L#{lib}", "-lThorSerialize17"
    system "./test"
  end
end
