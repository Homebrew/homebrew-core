class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "9.1.2",
      revision: "5bd5b2af3fc99ae435f70c1ceead2c7570f6c3bd"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d269666fdf1691aba8a12a7b839165f5f7ef24744e2234b390803318dc84ca76"
    sha256 cellar: :any,                 arm64_sequoia: "cc7c86ead04d2c8fe80dd3bcf7fc98d528a844573034030449a6b70588c6b838"
    sha256 cellar: :any,                 arm64_sonoma:  "202ab9d8242dedecdb67ef19568f2135cbecd006db27f83a00c1ba7451d838a3"
    sha256 cellar: :any,                 sonoma:        "bf6677ef6155f63b41943ef5e85cea07240b7b2117b97c03f62a2406cea3de31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69d4c9e1a73aa019c17e37ea99bec922ee3b55b70af08b12e3ae015778909fda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "053ad943e3fdc7db8f01bad292e66847035f3a483d48ed664a096688b9568bb5"
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
