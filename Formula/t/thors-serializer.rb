class ThorsSerializer < Formula
  desc "Declarative serialization library (JSON/YAML) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git",
      tag:      "3.0.2",
      revision: "62f95423c42fd1acab45609a39f985021163d34f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "67e948220403d08b240c97478911c5b8c6430499f930cd4b2c08799b1c53e099"
    sha256 cellar: :any,                 arm64_ventura:  "b01bf56bbf929de7873b5540ba33c0354ca408ce8ebef280f169b7e9ca2aa5d8"
    sha256 cellar: :any,                 arm64_monterey: "e52cce199b7e2e1b204a21deb7c2c36b9a785ce7b7489f55e0ca8f735ff985a3"
    sha256 cellar: :any,                 sonoma:         "d10c794d88626e9ffa8e972cc7d101a1ce5c6873bf0fa9bc297439146f58f46b"
    sha256 cellar: :any,                 ventura:        "9d261871c54d4157c8553dbd09662dedeed760582d3b163faf4b4d1743dfef50"
    sha256 cellar: :any,                 monterey:       "c40ad99bf5d524d7434b1a85c4f9140e163bad5cd4adcd3ca2ea77c974b582db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9409f08e08b781498fb6eee4258e5e3a555020a12906623971a12f5a39bf3f4"
  end

  depends_on "boost" => :build
  depends_on "bzip2"
  depends_on "libyaml"
  depends_on "magic_enum"
  depends_on "openssl@3"

  fails_with gcc: "5"

  def install
    ENV["COV"] = "gcov"

    system "./configure", "--disable-vera",
                          "--prefix=#{prefix}"
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
           "-I#{Formula["boost"].opt_include}",
           "-I#{include}", "-L#{lib}", "-lThorSerialize17", "-lThorsLogging17", "-ldl"
    system "./test"
  end
end
