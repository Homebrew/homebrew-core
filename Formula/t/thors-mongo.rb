class ThorsMongo < Formula
  desc "Mongo API and Serialization library"
  homepage "https://github.com/Loki-Astari/ThorsMongo"
  url "https://github.com/Loki-Astari/ThorsMongo.git",
      tag:      "3.3.00",
      revision: "50edea0a79cb00ac0469e14e37e46188f20d5ae3"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5bbdc57ecd5330c916f0c76d6a1e3497c2127d371349b15b2d534b62e802f516"
    sha256 cellar: :any,                 arm64_ventura:  "0ff914b3b50e73d3b6b69e9c6b1deb1e19489d3119bd71d90f53937b6ceeab50"
    sha256 cellar: :any,                 arm64_monterey: "1ce642bd9357de6608770d44c23ad67b2f03b4e0c51963fcd4a2baffb8b7bdf0"
    sha256 cellar: :any,                 sonoma:         "df324671b1735d7d52d68da1b436e6706f00d5872861ec83105ce4771aef4eaa"
    sha256 cellar: :any,                 ventura:        "76fc80118d6e7fe6511856b290f37e36de87dcd104b9d4bdcfbc32236988c5c4"
    sha256 cellar: :any,                 monterey:       "4bae200a85947f3a300805f9fe4e7e90ef351328b382441c67645a67fad3c336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71d226417944427ea75751a1e2ce4901c89f5a5216b9fc0e4ec4246fac1c037b"
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
