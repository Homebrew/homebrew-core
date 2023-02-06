class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      tag:      "2.2.19",
      revision: "426ba1018f03b77594e6202c4352b0e1a9a150a1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "185f4d9895ce6f5a43d19814099991d60ffd7c1a83d702d241ae74f69bbc594f"
    sha256 cellar: :any,                 arm64_monterey: "201a0ab3c322014325188bf69e4886181f81a1b16a11f10da83c6484936c52fb"
    sha256 cellar: :any,                 arm64_big_sur:  "45be673d21f5831fbee9bc0007eca37599f2feba3ec49fd52e4851f81befc949"
    sha256 cellar: :any,                 ventura:        "5bcdc312df0a341aa8b260b473418d2aa8717e3774deba4db497d00d605c3400"
    sha256 cellar: :any,                 monterey:       "a771a6a6f095fd328fb35ad8f730c26695e311eeb20eb3b974ceadce681ae934"
    sha256 cellar: :any,                 big_sur:        "7aa993e7ce4ec1c4340b5b677bae017e5a0abfbe39c5b8c93d2947cb3daa9b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "994ddb7164a1bcf5f6dad907e45d7650231bbc31bdaefeda1b83dd6b0ecbdf96"
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
