class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      tag:      "2.2.15",
      revision: "8a6f4ace2461ee2939879ae8dc250f4454ba6e3d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "72b292e2bd2fc4edd7257fd4d33e7aa1754bc253e0851ae35ea7e08eb156a41b"
    sha256 cellar: :any,                 arm64_big_sur:  "7eb4a16cff723e979c9dd01fe7bc476353fca489d0f917b9b543a4f30646aaf9"
    sha256 cellar: :any,                 monterey:       "9581c49a0c8ca7760e5b803cf26eeacba6761763e727da75115735db01163854"
    sha256 cellar: :any,                 big_sur:        "cb5f3cad13ff513a0e66ea480977627ba52e01aa487a8f428763fa04c945f788"
    sha256 cellar: :any,                 catalina:       "cb9c646b0d010c261a96faf8376c4329615547ba60335d8407e0935c2551d3ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a878988168438c306e22282659c5cbaff5480d6833b9fdc88a5b2ddeee3cb121"
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
