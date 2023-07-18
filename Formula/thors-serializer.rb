class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      tag:      "2.2.23",
      revision: "c50c8afc589d9c5d67704739885329c2e5feadeb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9c92403671fda746554769fb01bbe5cd295ad9a9bca7a32619df8de22a498937"
    sha256 cellar: :any,                 arm64_monterey: "a4729a1fb28fe8e4fc7f811fb7aca195bc6c1b8ac8766659bce30f0ca4535c2d"
    sha256 cellar: :any,                 arm64_big_sur:  "4d1e937c8c3a3b92c63d1ebbbf9aa5066696302c68e5889c200675b2f3152806"
    sha256 cellar: :any,                 ventura:        "22ce298cc6f2c268369c4d7517f713bdbd3b83c13c70f049a46863344306d822"
    sha256 cellar: :any,                 monterey:       "e69b1e9412457955c60a941c2f8dc8d96b8da2c453a040452425f801aa91b677"
    sha256 cellar: :any,                 big_sur:        "a3e33a09e063ec1c05f62f8f418ab23587b00b010e916d6332b5a8af96eb4910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "540ab7efb73970ef3dd347cafda57e71fedd1cae41af8e964055b86b07f06bb6"
  end

  depends_on "boost" => :build
  depends_on "bzip2"
  depends_on "libyaml"
  depends_on "magic_enum"

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
