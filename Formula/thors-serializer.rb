class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      tag:      "2.1.3",
      revision: "be7fc13c953cb4f04a66238219f300a4f579347c"
  license "MIT"

  bottle do
    cellar :any
    sha256 "76659fd2fccd00a3dfb2ead0f29c2ac449be37bfbede717c7fa50b9d166643f7" => :big_sur
    sha256 "c40d919edcef045430f2318f7fe074f06a2e52c1adf99cadc4afbd1c16ed3387" => :arm64_big_sur
    sha256 "035c0adeb315c6291902743dacf1b19a99657fcded3dc7d5a8c7f8412cd3ec27" => :catalina
    sha256 "5d2b889102c559efc3bee745f2cbcaf3a353bda2c65198ed144e93248cfa0597" => :mojave
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
