class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      tag:      "2.2.10",
      revision: "9a508808d5b2a43a0f52a50aadb7645915202309"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "21992172551a86998c68a66c1cba7804b36bb7c9fa4172e26a27475d67f43bfe"
    sha256 cellar: :any,                 arm64_big_sur:  "4651acf8a32970d42ea85a0e7db8649dba6221486f59d52bcf57ea089c0b5fb1"
    sha256 cellar: :any,                 monterey:       "08e5784cde54f98fd26f16e831a20261373fb73aaa5ccfbcf74d3d33445a4e0a"
    sha256 cellar: :any,                 big_sur:        "2b97e4a4d91ab8b977b18c176b1e440f238825e1e43a5a7cdebc6a56178b1f08"
    sha256 cellar: :any,                 catalina:       "9c8f540a49fc00748a477344344adbe2dbf2fd867b599ffc8e9e1f0aa0dbd391"
    sha256 cellar: :any,                 mojave:         "72728f0f7647bb87b6cfc5cb5123d18b090660c03c58dbeff12418629bf396b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "501f35e0df7b8d5131a06b59a2e03f366b7f6621f7c5309a0c0503a0c53bdb54"
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
