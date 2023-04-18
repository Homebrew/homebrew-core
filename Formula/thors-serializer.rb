class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      tag:      "2.2.19",
      revision: "426ba1018f03b77594e6202c4352b0e1a9a150a1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9fe2cddd9b4b85388263b3a473fd3bd96c669c84a9819624ad7724cb8ed905ce"
    sha256 cellar: :any,                 arm64_monterey: "6f58837a3181bd172d3baafbbf15d8d9a596d0620554715cc3657706a507a52c"
    sha256 cellar: :any,                 arm64_big_sur:  "e2b6115a023b49370baa58e4a0a663441ed9f693cddb0b6f2a3a5d5d3b60be04"
    sha256 cellar: :any,                 ventura:        "8ddbba88cfe30a3ba1270f415ba1d802ff7cd4d5725922c2cae64f528c315592"
    sha256 cellar: :any,                 monterey:       "18997a3d6a141f608ed87c84df7be449cccc04470d36714793020d44c6e02550"
    sha256 cellar: :any,                 big_sur:        "8d7dbfec01d7f20f42ec3bdb5bc03c83295253ee298153ef9470fdb32586a066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a4a38ee332cae8d39fdabed574bd36a626777e361145ccc326a9baa1771a2e4"
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
