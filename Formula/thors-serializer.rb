class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      tag:      "2.2.8",
      revision: "f1f665fd55ca81acbea0cf9b081765586b194688"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "6ace458d942191d9b1d5c47ee7f8f01384e5d03e234dbee2c061aba01f4cb61b"
    sha256 cellar: :any,                 big_sur:       "d5045397ac4a47c33712f87b83b3ff7ca175820be9db331e22d1aed6e9df548b"
    sha256 cellar: :any,                 catalina:      "b795c7bc69d7b80b57e886c4e62f7fd6cdf60d8c7d1b09fd3e3f68347c306fad"
    sha256 cellar: :any,                 mojave:        "1363dd063032942dc5c8f280555d6bf47e77db1e40f63080d5ab7fce478b97ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f478a995575e84294e27888bb1bff89de2fda695dfb245690019fd87340ac6a"
  end

  depends_on "boost" => :build
  depends_on "bzip2"
  depends_on "libyaml"

  on_linux do
    depends_on "gcc"
  end

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
