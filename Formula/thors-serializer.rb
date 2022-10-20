class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      tag:      "2.2.17",
      revision: "141f3db31e276566fa18c6bb7ee00d5eafa3f249"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fed38939de49fd5392bb5eb5b73a232a908f3d7fcc6c8c6f46cbd62cb9692f66"
    sha256 cellar: :any,                 arm64_big_sur:  "c0bc34ed11e301a8c6c1d431b199a5d551ce001a645d3afcb4027be80175ebca"
    sha256 cellar: :any,                 monterey:       "5b0f10dddcf34051c3dae5a89d645d9a8038fdfa205dfd1352a08fbb5ab512e2"
    sha256 cellar: :any,                 big_sur:        "345aa3d840c70e080ffdda7323a25aed65d264fd15e092a254bd0f798054f978"
    sha256 cellar: :any,                 catalina:       "6042a23651e48c42fc1f24736ce9c76f7c1b067321f882d1bd9e88836560ac28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74c185a7fe800e562b471806d56f92469a9caabb53fced25b24c0e368fa65ffd"
  end

  depends_on "boost" => :build
  depends_on "bzip2"
  depends_on "libyaml"

  fails_with gcc: "5"

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
           "-I#{include}", "-L#{lib}", "-lThorSerialize17", "-lThorsLogging17", "-ldl"
    system "./test"
  end
end
