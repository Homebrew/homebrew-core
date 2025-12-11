class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https://github.com/Loki-Astari/ThorsMongo"
  url "https://github.com/Loki-Astari/ThorsMongo.git",
      tag:      "7.0.07",
      revision: "2fbd6b84e2b154b36e03b5d8ab1aae97a62ff5da"
  license "GPL-3.0-only"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "71cba43a8c7214aab34451153140ec9b1001bce77bbdb633ca5219c83c353c32"
    sha256 cellar: :any,                 arm64_sequoia: "50dac827b9b016b461d1ef06280dc5fd223ff2af154adb3c4f2e8f91a4b24a8c"
    sha256 cellar: :any,                 arm64_sonoma:  "261628d5717413b17109187cf52197a43944379cafe307c23b858845370d3b12"
    sha256 cellar: :any,                 sonoma:        "48dc65704a45d73e652e3903657f40352ca9f8d7575b748664b2823e4f886b43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d21d5941b333706b86cad6999ecfe1b4896243da575b443af394d6e7cb127a4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "290218a8eb76ae0654e43b25f8df877f985197a8584a5150369d7cf2703f8788"
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
