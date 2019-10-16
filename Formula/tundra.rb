class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.10.tar.gz"
  sha256 "89f834f4ab075525b6862908788487763a189ce1124c692a75e740749f69659a"

  bottle do
    cellar :any_skip_relocation
    sha256 "db24a99fecb494c1a14ee6a372a31dedd3a78b004b9a8202e827c50e8e528794" => :catalina
    sha256 "c0df5e3c6bfc993677832251cb21126a752d9c568a523d0a46cd4aa6fc4bdb88" => :mojave
    sha256 "c38d5302a7ce1685ce37c2c4a1d7284458b58368d5e001b00acad133903a532e" => :high_sierra
    sha256 "c25a23cb0b88587aea2e31261965af6b71c792cd04cb6b2366b5c5af9df20046" => :sierra
  end

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
    sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"
  end

  def install
    (buildpath/"unittest/googletest").install resource("gtest")
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <stdio.h>
      int main() {
        printf("Hello World\n");
        return 0;
      }
    EOS
    (testpath/"tundra.lua").write <<~'EOS'
      Build {
        Units = function()
          local test = Program {
            Name = "test",
            Sources = { "test.c" },
          }
          Default(test)
        end,
        Configs = {
          {
            Name = "macosx-clang",
            DefaultOnHost = "macosx",
            Tools = { "clang-osx" },
          },
        },
      }
    EOS
    system bin/"tundra2"
    system "./t2-output/macosx-clang-debug-default/test"
  end
end
