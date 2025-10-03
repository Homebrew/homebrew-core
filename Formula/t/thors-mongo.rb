class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https://github.com/Loki-Astari/ThorsMongo"
  url "https://github.com/Loki-Astari/ThorsMongo.git",
      tag:      "6.0.06",
      revision: "9ff64c7f7d52415a9f09d764078a9d2b29b06f16"
  license "GPL-3.0-only"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb4b075302bd83e81f8035e2c7a581bc4bf48f0593364f68b1d703170b53d9f6"
    sha256 cellar: :any,                 arm64_sequoia: "df22574c3d8d42c2acd7545936aac68e10fb01a62d468e8a37737fdf29d0d61e"
    sha256 cellar: :any,                 arm64_sonoma:  "ba80135aa78d5bbd0bd423da47424b2f2ecf57321971e20574c91e92ea9bc299"
    sha256 cellar: :any,                 arm64_ventura: "45f3b9efe0946ceb9b65e733276324e0627dee6935c6de01a754db430fc74ef7"
    sha256 cellar: :any,                 sonoma:        "685f7324a917a8a8c535483572c45fdb40324be940c5ac3347792df6f43898c9"
    sha256 cellar: :any,                 ventura:       "5f2ef80e0b25ca4b261d310ce1f4e3d555024c9681e445dc6881575f55de48e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fdff2c40dd5efb489fad7025d5e026a9dc69163bfbb5fb0ff938a7ad1410b40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e075ff4433d7bfe5d4a31dc004ca0a3243e8de78d7046866174d493d90d57118"
  end

  depends_on "libyaml"
  depends_on "magic_enum"
  depends_on "openssl@3"
  depends_on "snappy"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    ENV["COV"] = "gcov"
    # Workaround for failure when building with Xcode std::from_chars
    # src/Serialize/./StringInput.h:104:27: error: call to deleted function 'from_chars'
    ENV.append_to_cflags "-DNO_STD_SUPPORT_FROM_CHAR_DOUBLE=1" if DevelopmentTools.clang_build_version == 1700

    system "./brew/init"
    system "./configure", "--disable-vera",
                          "--disable-test-with-integration",
                          "--disable-test-with-mongo-query",
                          "--disable-Mongo-Service",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "-std=c++20", "test.cpp", "-o", "test",
           "-I#{include}", "-L#{lib}", "-lThorSerialize", "-lThorsLogging", "-ldl"
    system "./test"
  end
end
