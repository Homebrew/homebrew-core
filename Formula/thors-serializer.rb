class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      tag:      "2.2.0",
      revision: "e51bb10e1f95a3d52391358c941a5e8dd92c1e4e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6511e30afbe0f7e468d4b25d1d86ab9e2068e2c560605916822145fefd548dc2"
    sha256 cellar: :any, big_sur:       "da64016e8475c07200f43ba4f5de2148795c2cd0ae0172d7e4e307be3dcb293a"
    sha256 cellar: :any, catalina:      "99713ede7b47b2dbed13ac1312d52acbc4b20e7bb22e3171160f2ed063a7dec2"
    sha256 cellar: :any, mojave:        "ba6eed10bc969358ba4b002a02bc76d97a048c30968cc18928b1b0261e2d91b5"
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
