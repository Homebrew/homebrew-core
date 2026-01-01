class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "8.0.12",
      revision: "060ffdda8623ca8734899e9d8ee8da4e0d979078"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe9fc54afbcd0c7ea97509b108bf208cb29d44264c10ffd86dd7658dd29a7c28"
    sha256 cellar: :any,                 arm64_sequoia: "2fb6228434b51c78dcffa71addd691a58d9571ded0840db4cabf3ccc6be37f88"
    sha256 cellar: :any,                 arm64_sonoma:  "772edc732064f2d7688ad32ea5ae2615dbb5135ed9b4933c60df566a6db86548"
    sha256 cellar: :any,                 sonoma:        "eb154ec067e467c5fab78735d84212ac1bb0832d37356535ad73dc5581faf0ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a77a9ad9b7c4a088a5ee4bb80e06607c1f574806cf85b065035e8c20c498aefe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e37885e85bc2e6b65850858b90d2e599003c8db6bced287c4925177c623ae863"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libevent"
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
                          "--disable-slacktest",
                          *std_configure_args
    ENV.deparallelize
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
