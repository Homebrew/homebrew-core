class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https://github.com/Loki-Astari/ThorsMongo"
  url "https://github.com/Loki-Astari/ThorsMongo.git",
      tag:      "4.2.02",
      revision: "6502639bfa2db6d904fe96e708ce40d04640c6bf"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b450f53662e4b51da8433b7090183e1014c4f9d88eb4dca5d51616878caf89e"
    sha256 cellar: :any,                 arm64_sonoma:  "1b06796c25e4e46ab97b0bee70e9eaf09330b5c98fead5cb41ddf012724023db"
    sha256 cellar: :any,                 arm64_ventura: "086a709986a6678671cc3b1c8dae93f3e2f4deef550c506a66684c76434c1f34"
    sha256 cellar: :any,                 sonoma:        "43438a9ddb4da52350e32063fcb014a7a5c630f70bc823219ee263b9cc0db819"
    sha256 cellar: :any,                 ventura:       "d1a415b92e8c0f28aa786f7004a29522e0eaa60b1c74bd49a8f2dd047b8012f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d96a1487726a6da0e859debfd689a77afc97108288ced7a49f950dfde6f88357"
  end

  depends_on "libyaml"
  depends_on "magic_enum"
  depends_on "openssl@3"
  depends_on "snappy"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    ENV["COV"] = "gcov"

    system "./brew/init"

    system "./configure", "--disable-vera",
                          "--prefix=#{prefix}",
                          "--disable-test-with-integration",
                          "--disable-test-with-mongo-query",
                          "--disable-Mongo-Service"

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
    system ENV.cxx, "-std=c++20", "test.cpp", "-o", "test",
           "-I#{include}", "-L#{lib}", "-lThorSerialize", "-lThorsLogging", "-ldl"
    system "./test"
  end
end
