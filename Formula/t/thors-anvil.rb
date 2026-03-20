class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "9.1.6",
      revision: "0aeb857107b7b76ce8f53580d921f409001a3c5f"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d52500635669d1edf55f4f2910cece96a508de175402eef2877f0d2aaeab58fa"
    sha256 cellar: :any,                 arm64_sequoia: "1c78b0ab0859f874f2ea04025d97295879bfa9c8d3ef9d83d0ccf0e797fd09bd"
    sha256 cellar: :any,                 arm64_sonoma:  "e9cf66e65e44ca6b0abf18b786fd25f9c2195456f25a704d2480b2290b7c19be"
    sha256 cellar: :any,                 sonoma:        "ac846b7c5ffdbc9af3e20dd63458c97ffa59f2eed317fc8ce54bb58eaba75266"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d85b988a10a204561a7eb2b1e6b162ac8a238e09d43dab54e3b9a95aef77afe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "289b84cceed87bef25952787a46976f6051027aeb99081bdf341f476ff77dd2c"
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
