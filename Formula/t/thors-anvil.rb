class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "9.1.14",
      revision: "90cf2b697ba94e9da335dc8dbd8c2fae77f44771"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b10235fa39a6491082a96e13d1baf4c1c0a3c9c02ac68b1c7116cc8ec83c4e21"
    sha256 cellar: :any,                 arm64_sequoia: "9611bedf6b2d8fd79ffbaefa305384252fc4b4043b00bb774ca4c79dc0610bb3"
    sha256 cellar: :any,                 arm64_sonoma:  "0f11c9c7b69bf81ee1d4eb343a04b0ce8a86b811466d1348a20c87f72f9a52ec"
    sha256 cellar: :any,                 sonoma:        "f6d143db25795bb19bbb10dfbcd31397eed970debb8f5e60444d4d8dbe53065a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5955c773927e445d95d0aa06c2fefc48289ff12994902fef5434e9bc40f15a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff413bdd5da4ea620faf5ad6cbafb45476ee411b26c2982edcebf3aded1bf70f"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "magic_enum"
  depends_on "openssl@3"
  depends_on "snappy"
  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    ENV["DISBALE_CONTROL_CODES"] = "TRUE"
    system "make", "-j", "1", "JOBS=" + ENV.make_jobs.to_s
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
