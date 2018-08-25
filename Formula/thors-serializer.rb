class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      :tag => "1.8.1",
      :revision => "b3fbc80cdc906c0582f1a390f1ee7a3cb3d0fdc9"

  bottle do
    cellar :any
    sha256 "e6b95a75a5e6e7c7cd10b8f7dc4986e29fec79f6ec4a83aff386f9bb7ae48203" => :high_sierra
    sha256 "7ff244bac8dbbc345556d19f9f81b84af9360be9f1f9eecb9f3e58680b78ea6e" => :sierra
    sha256 "0041c553fd89ad82220ec8c0114bbdf24ad2df5abb60940fb7130be09f40f024" => :el_capitan
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
