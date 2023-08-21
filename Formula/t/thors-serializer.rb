class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      tag:      "2.2.31",
      revision: "94edddb0bd9880d2c1fedee2b8f420f4ce023c9e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9a42483052a911a3270f11972a0506e5078dfeea0126f0a1d8378bea102b2176"
    sha256 cellar: :any,                 arm64_monterey: "14864b1699257f98a07ec60d442f5b2b5972cee3d5ac8fe1b04a81fa44146f76"
    sha256 cellar: :any,                 arm64_big_sur:  "7fd1edc53ae5614a88cc9e895cd9deef4260ce36dfeec3565b7a3b7f3c53b279"
    sha256 cellar: :any,                 ventura:        "1b40008dac9e9f70753e90717f303ce4b7631275bc325eb9c99ed8cbeb590c95"
    sha256 cellar: :any,                 monterey:       "46df04b093be21f2db55758bfaf7a6b7fd88d168bfb27c64d64a9947cd42926a"
    sha256 cellar: :any,                 big_sur:        "4f670a98b27f53f477906f4eadc484e6231d5190e3bd270b14c977ae8037d189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "799052fbf94b4422d0d9143f7954afd8da0623a17c5312c44c4034284973c8b3"
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
