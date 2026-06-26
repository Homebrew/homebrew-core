class ThorsAnvil < Formula
  desc "Set of modern C++20 libraries for writing interactive Web-Services"
  homepage "https://github.com/Loki-Astari/ThorsAnvil"
  url "https://github.com/Loki-Astari/ThorsAnvil.git",
      tag:      "11.0.4",
      revision: "1ac2e1a667f5e6fe660eb8158f9545fa69efeadf"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0aec79ba2d849282d128fd78b23bef0735a7661e5625c47aff8cfd3cd3d3a5e8"
    sha256 cellar: :any, arm64_sequoia: "4b3a2f444c855c5435afe30a780cc96209a67c0ee7c099ea7baa7393ba93e49e"
    sha256 cellar: :any, arm64_sonoma:  "52c7b479a2f659f26df79d64fdd45bb9983c8fe1149a51d2d7baa65a831b0676"
    sha256 cellar: :any, sonoma:        "67fc0a76af6dc6d94037a62b9b09316ccae1676d06ef9c75739cf3e46f60735b"
    sha256 cellar: :any, arm64_linux:   "9cce211e26090fa463af370f13f1295f02b7f8edda95e85cb91b0f4c3d208c0c"
    sha256 cellar: :any, x86_64_linux:  "870f6a3b08640eb8e5d9441791cec8eec2d757420c7b0de2520dc45ae6171311"
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
    ENV["DISABLE_CONTROL_CODES"] = "TRUE"
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
