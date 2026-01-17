class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "9.0.05",
      revision: "93b0814474e35ece5a2d28592fb7b6c159b4ed08"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a2383c27dc83e8d2420fbbf89b033023eb626f99fbc56d4139b7bc9cdc545e5"
    sha256 cellar: :any,                 arm64_sequoia: "d8fd5f22be9f8481a1e7914ccd2751afa33ec833f249ee10542566f5d69474f7"
    sha256 cellar: :any,                 arm64_sonoma:  "2e54c4d342fb857a296c9f6b7d544a38f4a6f54840cb134a4bd3faaf19f823f0"
    sha256 cellar: :any,                 sonoma:        "1546391b3bbf1a916b63cbbd25aa79836c244ab9aaf3f1c5b6ac1c4609cc44a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "536b2ce4149ec204e9303cdfc30ea33cf937d58afdc68a9f3043616cdcb9abab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b8b9042ba3ada185751bbedb05ac2813958f1997dbd9faade21a3be9e94762e"
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
