class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      :tag      => "1.9.1",
      :revision => "0f60ae61e1e37dd6343c9afe28898125a77ecc2d"

  bottle do
    cellar :any
    sha256 "736892141ba33ef4425361d797a1c088a58668a6bf6005239c5c9d7d770898eb" => :mojave
    sha256 "8883c664e953a4567ca1c158ce4dc02af834009b0df32eb095c67e1c3d66126d" => :high_sierra
    sha256 "1eb242a70936dfaf6947cb1ce3f6467e772e9e4f409d2fad30ab9ccbf0254b4a" => :sierra
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
