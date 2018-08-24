class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      :tag => "1.7.5",
      :revision => "338a933fe3071ed509b99cf6c44a99c8068797b1"

  bottle do
    cellar :any
    sha256 "6f898a67264e5b92ec1c52aca0c0a5f672d41fdbddd832c480bae9db3ea24a8e" => :mojave
    sha256 "2548c7d97caf794154f434f3852236fbafc4331ed65e1cd40340db7579a9b025" => :high_sierra
    sha256 "95772d76896402a22b20987e7a10dfd85ba441c0f704bd86dee389d1a5b387fd" => :sierra
    sha256 "057eb717b5f941bbb3f760510356bbba2df8a9996dd40567c7abe8acea62ef14" => :el_capitan
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
